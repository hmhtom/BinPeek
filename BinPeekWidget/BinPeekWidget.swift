import WidgetKit
import SwiftUI

struct BinPeekWidgetEntry: TimelineEntry {
    let date: Date
    let payload: WidgetSharedPayload?
}

struct BinPeekWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> BinPeekWidgetEntry {
        BinPeekWidgetEntry(date: Date(), payload: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (BinPeekWidgetEntry) -> Void) {
        completion(BinPeekWidgetEntry(date: Date(), payload: loadPayload()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BinPeekWidgetEntry>) -> Void) {
        let entry = BinPeekWidgetEntry(date: Date(), payload: loadPayload())
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 6, to: Date()) ?? Date()
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func loadPayload() -> WidgetSharedPayload? {
        guard
            let defaults = UserDefaults(suiteName: SharedConstants.appGroupID),
            let data = defaults.data(forKey: SharedConstants.widgetSharedPayloadKey)
        else {
            return nil
        }

        return try? JSONDecoder().decode(WidgetSharedPayload.self, from: data)
    }
}

struct BinPeekWidgetView: View {
    var entry: BinPeekWidgetProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)

            ForEach(items.indices, id: \.self) { index in
                let item = items[index]
                Text("\(symbol(for: item.type)) \(item.title)")
                    .font(.subheadline)
            }

            Spacer()
        }
        .containerBackground(.background, for: .widget)
    }

    private var title: String {
        entry.payload?.title ?? "Tonight:"
    }

    private var items: [WidgetCollectionItem] {
        entry.payload?.items ?? [
            WidgetCollectionItem(type: .greenBin, title: "Green Bin"),
            WidgetCollectionItem(type: .recycling, title: "Recycling")
        ]
    }

    private func symbol(for type: WidgetCollectionType) -> String {
        switch type {
        case .greenBin:
            return "🟩"
        case .recycling:
            return "🟦"
        case .garbage:
            return "⬛"
        }
    }
}

struct BinPeekWidget: Widget {
    let kind = SharedConstants.binPeekWidgetKind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BinPeekWidgetProvider()) { entry in
            BinPeekWidgetView(entry: entry)
        }
        .configurationDisplayName("BinPeek")
        .description("Peek at the next bin collection.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    BinPeekWidget()
} timeline: {
    BinPeekWidgetEntry(date: Date(), payload: nil)
}
