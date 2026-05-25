import Foundation

struct WidgetSharedPayloadWriter {
    func saveSchedulePayload(
        _ schedule: CollectionSchedule,
        updatedAt: Date = Date()
    ) -> Bool {
        guard let defaults = UserDefaults(suiteName: SharedConstants.appGroupID) else {
            return false
        }

        let payload = WidgetSharedPayload(
            updatedAt: updatedAt,
            title: "Tonight:",
            items: items(from: schedule)
        )

        guard let data = try? JSONEncoder().encode(payload) else {
            return false
        }

        defaults.set(data, forKey: SharedConstants.widgetSharedPayloadKey)
        return true
    }

    private func items(from schedule: CollectionSchedule) -> [WidgetCollectionItem] {
        var items: [WidgetCollectionItem] = []

        if schedule.greenBin {
            items.append(WidgetCollectionItem(type: .greenBin, title: "Green Bin"))
        }

        if schedule.recycling {
            items.append(WidgetCollectionItem(type: .recycling, title: "Recycling"))
        }

        if schedule.garbage {
            items.append(WidgetCollectionItem(type: .garbage, title: "Garbage"))
        }

        return items
    }
}
