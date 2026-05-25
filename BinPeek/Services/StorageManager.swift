import Foundation

struct StoredAddress {
    let streetNumber: String
    let streetName: String
    let postalCode: String
}

final class StorageManager {
    static let shared = StorageManager()

    private enum Key {
        static let streetNumber = "streetNumber"
        static let streetName = "streetName"
        static let postalCode = "postalCode"
        static let collectionSchedule = "collectionSchedule"
        static let collectionCalendar = "collectionCalendar"
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func saveAddress(
        streetNumber: String,
        streetName: String,
        postalCode: String
    ) {
        defaults.set(streetNumber, forKey: Key.streetNumber)
        defaults.set(streetName, forKey: Key.streetName)
        defaults.set(postalCode, forKey: Key.postalCode)
    }

    func loadAddress() -> StoredAddress? {
        guard
            let streetNumber = defaults.string(forKey: Key.streetNumber),
            let streetName = defaults.string(forKey: Key.streetName),
            let postalCode = defaults.string(forKey: Key.postalCode)
        else {
            return nil
        }

        StoredAddress(
            streetNumber: streetNumber,
            streetName: streetName,
            postalCode: postalCode
        )
    }

    func saveSchedule(_ schedule: CollectionSchedule) {
        guard let data = try? encoder.encode(schedule) else {
            return
        }

        defaults.set(data, forKey: Key.collectionSchedule)
    }

    func loadSchedule() -> CollectionSchedule? {
        guard let data = defaults.data(forKey: Key.collectionSchedule) else {
            return nil
        }

        return try? decoder.decode(CollectionSchedule.self, from: data)
    }

    func saveCollectionCalendar(_ calendar: String) {
        let trimmedCalendar = calendar.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedCalendar.isEmpty else {
            return
        }

        defaults.set(trimmedCalendar, forKey: Key.collectionCalendar)
    }

    func loadCollectionCalendar() -> String? {
        guard let calendar = defaults.string(forKey: Key.collectionCalendar) else {
            return nil
        }

        let trimmedCalendar = calendar.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedCalendar.isEmpty ? nil : trimmedCalendar
    }
}
