//
//  CaseTrackerWidget.swift
//  CaseTrackerWidget
//
//  Created by Shaun Fowler on 1/27/23.
//

import WidgetKit
import SwiftUI

struct WidgetEntry: Codable, Identifiable {
    let id = UUID()
    var name: String
    var colorR: CGFloat
    var colorG: CGFloat
    var colorB: CGFloat
}

class WidgetPersistence {

    let jsonDecoder = JSONDecoder()
    let userDefaults = UserDefaults(suiteName: "group.com.shaunfowler.CaseTracker.appGroup")

    func get() -> [WidgetEntry] {
        var result: [WidgetEntry] = []
        if let data = userDefaults?.dictionaryRepresentation().values {
            data.forEach { entry in
                if let entry = entry as? Data,
                   let decoded = try? jsonDecoder.decode(WidgetEntry.self, from: entry) {
                    result.append(decoded)
                    print(decoded)
                }
                print(entry)
            }
        }
        return result
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct CaseTrackerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ForEach(WidgetPersistence().get()) { entry in
            Text(entry.name)
        }
    }
}

struct CaseTrackerWidget: Widget {
    let kind: String = "CaseTrackerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CaseTrackerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct CaseTrackerWidget_Previews: PreviewProvider {
    static var previews: some View {
        CaseTrackerWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
