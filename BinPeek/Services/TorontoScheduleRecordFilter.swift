struct TorontoScheduleRecordFilter {
    func records(
        matching calendarID: String?,
        in records: [TorontoCollectionScheduleRecord]
    ) -> [TorontoCollectionScheduleRecord] {
        guard let normalizedCalendarID = normalizedCalendar(calendarID) else {
            return []
        }

        return records.filter { record in
            normalizedCalendar(record.calendar) == normalizedCalendarID
        }
    }

    private func normalizedCalendar(_ value: String?) -> String? {
        guard let value else {
            return nil
        }

        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else {
            return nil
        }

        return trimmedValue.lowercased()
    }
}
