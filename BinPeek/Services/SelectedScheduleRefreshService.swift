import Foundation

enum SelectedScheduleRefreshServiceError: Error {
    case selectedCalendarNotFound
    case matchingRecordsNotFound
    case upcomingScheduleNotFound
}

struct SelectedScheduleRefreshService {
    private let storageManager: StorageManager
    private let scheduleService: TorontoScheduleService
    private let recordFilter: TorontoScheduleRecordFilter
    private let parser: TorontoScheduleParser
    private let selector: CollectionScheduleSelector
    private let widgetSharedPayloadWriter: WidgetSharedPayloadWriter

    init(
        storageManager: StorageManager = .shared,
        scheduleService: TorontoScheduleService = TorontoScheduleService(),
        recordFilter: TorontoScheduleRecordFilter = TorontoScheduleRecordFilter(),
        parser: TorontoScheduleParser = TorontoScheduleParser(),
        selector: CollectionScheduleSelector = CollectionScheduleSelector(),
        widgetSharedPayloadWriter: WidgetSharedPayloadWriter = WidgetSharedPayloadWriter()
    ) {
        self.storageManager = storageManager
        self.scheduleService = scheduleService
        self.recordFilter = recordFilter
        self.parser = parser
        self.selector = selector
        self.widgetSharedPayloadWriter = widgetSharedPayloadWriter
    }

    func refreshSelectedSchedule(referenceDate: Date = Date()) async throws -> CollectionSchedule {
        guard let selectedCalendar = storageManager.loadCollectionCalendar() else {
            throw SelectedScheduleRefreshServiceError.selectedCalendarNotFound
        }

        let records = try await scheduleService.fetchLatestScheduleRecords()
        let matchingRecords = recordFilter.records(matching: selectedCalendar, in: records)

        guard !matchingRecords.isEmpty else {
            throw SelectedScheduleRefreshServiceError.matchingRecordsNotFound
        }

        let schedules = matchingRecords.compactMap { record in
            parser.convert(record: record)
        }

        guard let schedule = selector.nextSchedule(from: schedules, referenceDate: referenceDate) else {
            throw SelectedScheduleRefreshServiceError.upcomingScheduleNotFound
        }

        storageManager.saveSchedule(schedule)
        _ = widgetSharedPayloadWriter.saveSchedulePayload(schedule)
        return schedule
    }
}
