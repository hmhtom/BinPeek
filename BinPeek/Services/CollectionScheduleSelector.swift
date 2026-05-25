import Foundation

struct CollectionScheduleSelector {
    func nextSchedule(
        from schedules: [CollectionSchedule],
        referenceDate: Date = Date()
    ) -> CollectionSchedule? {
        let referenceDayStart = Calendar.current.startOfDay(for: referenceDate)

        return schedules
            .filter { schedule in
                Calendar.current.startOfDay(for: schedule.date) >= referenceDayStart
            }
            .sorted { first, second in
                first.date < second.date
            }
            .first
    }
}
