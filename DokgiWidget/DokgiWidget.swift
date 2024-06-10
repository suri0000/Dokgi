//
//  DokgiWidget.swift
//  DokgiWidget
//
//  Created by 예슬 on 6/5/24.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let midnight = Calendar.current.startOfDay(for: currentDate)
        let nextDayMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        let entry = SimpleEntry(date: currentDate)
        let timeline = Timeline(entries: [entry], policy: .after(nextDayMidnight))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct DokgiWidgetEntryView: View {
    var entry: Provider.Entry
    var passage: [String] = ["뭘 쓰고 싶었는지 전혀 기억이 나지 않았다. 아무 것도 쓰기 싫었다. 그저 빨리 돌아가 씻고 싶을 뿐이었다.", "허리수술 2천만원", "누군가를 있는 그대로 존중한다는 것은 그만큼 어려운 일이다.", "본질을 아는 것보다, 본질을 알기 위해 있는 그대로를 보기 위해 노력하는 것이 중요하다고, 그것이 바로 그 대상에 대한 존중이라고.", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Image("doubleQuotationMarks")
                Spacer()
            }
            Text(passage.randomElement() ?? "")
                .font(.subheadline)
                .padding(EdgeInsets(top: 7, leading: 15, bottom: 16, trailing: 0))
            Spacer(minLength: 0)
        }
    }
}

struct DokgiWidget: Widget {
    let kind: String = "DokgiWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DokgiWidgetEntryView(entry: entry)
                .containerBackground(.white, for: .widget)
        }
        .configurationDisplayName("구절")
        .description("작성한 구절을 보여줍니다. \n하루에 하나씩 새로운 구절을 만나보세요.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    DokgiWidget()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .distantFuture)
}
