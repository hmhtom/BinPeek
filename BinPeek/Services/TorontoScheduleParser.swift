import Foundation

struct TorontoScheduleParser {
    private let dateFormatter: DateFormatter

    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    }

    func parseDate(_ value: String?) -> Date? {
        guard let value else {
            return nil
        }

        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else {
            return nil
        }

        return dateFormatter.date(from: trimmedValue)
    }

    func parseCollectionFlag(_ value: String?) -> Bool {
        guard let value else {
            return false
        }

        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else {
            return false
        }

        return trimmedValue.uppercased() == "T"
    }

    func convert(record: TorontoCollectionScheduleRecord) -> CollectionSchedule? {
        guard let date = parseDate(record.weekStartingRaw) else {
            return nil
        }

        return CollectionSchedule(
            date: date,
            greenBin: parseCollectionFlag(record.greenBinRaw),
            recycling: parseCollectionFlag(record.recyclingRaw),
            garbage: parseCollectionFlag(record.garbageRaw)
        )
    }
}
