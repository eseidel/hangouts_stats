import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chat_graphs/hangouts.dart';

// Per month, per participant buckets
// Bucket size is time-window in which multiple events count as one.
// Buckets are named by their starting time stamp
class Counts {
  Map<int, Map<String, int>> _counts = <int, Map<String, int>>{};
  int _earliestBucket;
  int _latestBucket;

  static int bucketSizeInMs = const Duration(hours: 1).inMilliseconds;

  static int keyFromTime(DateTime time) {
    return (time.millisecondsSinceEpoch.round() ~/ bucketSizeInMs) *
        bucketSizeInMs;
  }

  void countEvent(Event event) {
    int bucket = keyFromTime(event.datetime);
    String senderId = event.senderId.gaia_id;
    _counts.putIfAbsent(bucket, () => <String, int>{});
    _counts[bucket].putIfAbsent(senderId, () => 0);
    _counts[bucket][senderId] += 1;

    _earliestBucket ??= bucket;
    _latestBucket ??= bucket;
    _earliestBucket = min(bucket, _earliestBucket);
    _latestBucket = max(bucket, _latestBucket);
  }

  Map<String, int> countsInRange(DateTime start, DateTime end) {
    int startBucket = keyFromTime(start);
    int endBucket = keyFromTime(end);
    startBucket = max(startBucket, _earliestBucket);
    endBucket = min(endBucket, _latestBucket);
    Map<String, int> counts = {};

    for (int bucket = startBucket;
        bucket <= endBucket;
        bucket += bucketSizeInMs) {
      if (_counts[bucket] == null) continue;
      _counts[bucket].forEach((id, count) {
        counts.putIfAbsent(id, () => 0);
        counts[id] += count;
      });
    }
    return counts;
  }
}

Map<String, String> buildIdToNameMap(Hangouts hangouts) {
  Map<String, String> idToName = {};

  hangouts.conversations.forEach((conversation) {
    conversation.participants.forEach((participant) {
      String existingName = idToName[participant.id.gaia_id];
      if (existingName != null && existingName != participant.name) {
        print("Name change? $existingName to ${participant.name}");
      }
      idToName[participant.id.gaia_id] = participant.name;
    });
  });
  return idToName;
}

dynamic main() {
  var jsonString = File('Hangouts.json').readAsStringSync();
  Map json = jsonDecode(jsonString);
  Hangouts hangouts = Hangouts.fromJson(json);

  Counts globalCounts = new Counts();
  hangouts.conversations.forEach((conversation) {
    conversation.events.forEach((event) {
      globalCounts.countEvent(event);
    });
  });

  Map<String, String> idToName = buildIdToNameMap(hangouts);

  printReport(globalCounts, DateTime(2014), DateTime.now(), idToName);
}

void printReport(Counts globalCounts, DateTime start, DateTime stop,
    Map<String, String> idToName) {
  // Figure out the top N globally, so we can bucket all the rest as "other"
  Map<String, int> topCounts =
      globalCounts.countsInRange(start, DateTime.now());
  List<MapEntry<String, int>> topEntries = topCounts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  // Remove the top id, assuming it's "self".
  Set<String> excludedIds = {topEntries.first.key};
  Set<String> namedIds = topEntries.take(10).map((entry) => entry.key).toSet();

  // Walk through all events
  // sorting into per-month, per-participant buckets.
  DateTime time = start;
  while (time.isBefore(stop)) {
    // FIXME: Year should be an arugment to this function.
    DateTime next = DateTime(time.year + 1);
    Map<String, int> counts = globalCounts.countsInRange(time, next);
    Map<String, int> namedCounts = {};

    counts.forEach((id, count) {
      if (excludedIds.contains(id)) {
        return;
      } else if (namedIds.contains(id)) {
        namedCounts[idToName[id]] = count;
      } else {
        namedCounts['Other'] ??= 0;
        namedCounts['Other'] += count;
      }
    });
    print(time.year);
    print(namedCounts);
    time = next;
  }
}
