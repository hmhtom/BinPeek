import Combine
import Foundation

enum HomeRefreshError {
    case selectedCalendarNotFound
    case matchingRecordsNotFound
    case upcomingScheduleNotFound
    case refreshFailed
}

final class HomeViewModel: ObservableObject {
    private let storageManager: StorageManager
    private let selectedScheduleRefreshService: SelectedScheduleRefreshService

    @Published private(set) var displayState: CollectionDisplayState?
    @Published private(set) var isRefreshing = false
    @Published private(set) var refreshError: HomeRefreshError?

    init(
        storageManager: StorageManager = .shared,
        selectedScheduleRefreshService: SelectedScheduleRefreshService = SelectedScheduleRefreshService(),
        displayState: CollectionDisplayState? = nil
    ) {
        self.storageManager = storageManager
        self.selectedScheduleRefreshService = selectedScheduleRefreshService
        self.displayState = displayState
    }

    func loadStoredSchedule() {
        let schedule = storageManager.loadSchedule()
        displayState = makeDisplayState(from: schedule)
    }

    @MainActor
    func refreshSelectedSchedule(referenceDate: Date = Date()) async {
        guard !isRefreshing else {
            return
        }

        isRefreshing = true
        refreshError = nil

        defer {
            isRefreshing = false
        }

        do {
            let schedule = try await selectedScheduleRefreshService.refreshSelectedSchedule(
                referenceDate: referenceDate
            )
            displayState = makeDisplayState(from: schedule)
        } catch SelectedScheduleRefreshServiceError.selectedCalendarNotFound {
            refreshError = .selectedCalendarNotFound
        } catch SelectedScheduleRefreshServiceError.matchingRecordsNotFound {
            refreshError = .matchingRecordsNotFound
        } catch SelectedScheduleRefreshServiceError.upcomingScheduleNotFound {
            refreshError = .upcomingScheduleNotFound
        } catch {
            refreshError = .refreshFailed
        }
    }

    func makeDisplayState(from schedule: CollectionSchedule?) -> CollectionDisplayState? {
        guard let schedule else {
            return nil
        }

        var tonightItems: [CollectionItem] = []

        if schedule.greenBin {
            tonightItems.append(CollectionItem(type: .greenBin, title: "Green Bin"))
        }

        if schedule.recycling {
            tonightItems.append(CollectionItem(type: .recycling, title: "Recycling"))
        }

        if schedule.garbage {
            tonightItems.append(CollectionItem(type: .garbage, title: "Garbage"))
        }

        return CollectionDisplayState(
            tonightItems: tonightItems,
            tomorrowTitle: "Pickup Day"
        )
    }
}
