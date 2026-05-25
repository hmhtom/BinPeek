import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    private let shouldLoadStoredSchedule: Bool

    init(
        viewModel: HomeViewModel = HomeViewModel(),
        shouldLoadStoredSchedule: Bool = true
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.shouldLoadStoredSchedule = shouldLoadStoredSchedule
    }

    var body: some View {
        NavigationStack {
            if let displayState = viewModel.displayState {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Tonight:")
                            .font(.title2)
                            .fontWeight(.semibold)

                        ForEach(displayState.tonightItems) { item in
                            Text("\(icon(for: item.type)) \(item.title)")
                                .font(.body)
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Tomorrow:")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(displayState.tomorrowTitle)
                            .font(.body)
                    }

                    refreshStatusView

                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .navigationTitle("BinPeek")
            } else {
                VStack(spacing: 16) {
                    Text("No collection information available")
                        .foregroundStyle(.secondary)

                    refreshStatusView
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .navigationTitle("BinPeek")
            }
        }
        .onAppear {
            if shouldLoadStoredSchedule {
                viewModel.loadStoredSchedule()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await viewModel.refreshSelectedSchedule()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(viewModel.isRefreshing)
            }
        }
    }

    private func icon(for type: CollectionType) -> String {
        switch type {
        case .greenBin:
            return "🟩"
        case .recycling:
            return "🟦"
        case .garbage:
            return "⬛"
        }
    }

    @ViewBuilder
    private var refreshStatusView: some View {
        if viewModel.isRefreshing {
            ProgressView()
        }

        if let refreshError = viewModel.refreshError {
            Text(message(for: refreshError))
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    private func message(for error: HomeRefreshError) -> String {
        switch error {
        case .selectedCalendarNotFound:
            return "Choose a collection calendar in Settings first."
        case .matchingRecordsNotFound:
            return "No records found for your selected calendar."
        case .upcomingScheduleNotFound:
            return "No upcoming collection schedule found."
        case .refreshFailed:
            return "Unable to refresh schedule."
        }
    }
}

#Preview("Default") {
    HomeView(viewModel: HomeViewModel.preview, shouldLoadStoredSchedule: false)
}

#Preview("Light") {
    HomeView(viewModel: HomeViewModel.preview, shouldLoadStoredSchedule: false)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    HomeView(viewModel: HomeViewModel.preview, shouldLoadStoredSchedule: false)
        .preferredColorScheme(.dark)
}

#Preview("iPhone SE") {
    HomeView(viewModel: HomeViewModel.preview, shouldLoadStoredSchedule: false)
        .previewDevice("iPhone SE (3rd generation)")
}

#Preview("iPhone 15 Pro") {
    HomeView(viewModel: HomeViewModel.preview, shouldLoadStoredSchedule: false)
        .previewDevice("iPhone 15 Pro")
}

#Preview("No Data") {
    HomeView(shouldLoadStoredSchedule: false)
}

private extension CollectionSchedule {
    static let preview = CollectionSchedule(
        date: Date(timeIntervalSinceReferenceDate: 0),
        greenBin: true,
        recycling: true,
        garbage: false
    )
}

private extension HomeViewModel {
    static var preview: HomeViewModel {
        HomeViewModel(
            displayState: HomeViewModel().makeDisplayState(from: CollectionSchedule.preview)
        )
    }
}
