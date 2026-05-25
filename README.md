# BinPeek

BinPeek is an iOS SwiftUI app with a WidgetKit extension for Toronto garbage pickup reminders.

The current MVP focuses on a minimal local flow:
- User manually selects a Toronto collection calendar.
- App fetches the latest Toronto Open Data schedule records.
- App filters, parses, and stores the next upcoming collection schedule.
- Widget receives a lightweight shared payload through App Group UserDefaults.

## Current MVP Capabilities

- SwiftUI app with Home, Address, and Settings pages.
- WidgetKit extension with static fallback and dynamic shared payload rendering.
- Manual collection calendar selection in Settings.
- Toronto Open Data fetch pipeline:
  - package metadata fetch
  - latest JSON resource resolution
  - records download
  - DTO decode
  - normalized record mapping
- Home manual refresh flow.
- Local `CollectionSchedule` storage with `UserDefaults`.
- Widget shared payload sync through App Group `UserDefaults`.
- Widget timeline reload request after successful schedule refresh.
- GitHub Actions iOS build verification.

## Current Main Flow

```text
Settings select Calendar
-> StorageManager.saveCollectionCalendar
-> Home refresh button
-> HomeViewModel.refreshSelectedSchedule
-> SelectedScheduleRefreshService
-> TorontoScheduleService.fetchLatestScheduleRecords
-> Toronto Open Data API
-> filter by selected Calendar
-> parse records to CollectionSchedule
-> select next upcoming schedule
-> StorageManager.saveSchedule
-> WidgetSharedPayloadWriter.saveSchedulePayload
-> WidgetTimelineReloader.reloadBinPeekWidget
-> Widget provider loadPayload
-> Widget view render payload or fallback
```

## Key Constraints

- No backend.
- No Docker.
- No fake address matching.
- No hardcoded `resource_id`.
- No hardcoded year.
- Manual Calendar selection is the MVP fallback.
- Widget does not directly read App models.
- Widget does not read Toronto raw records.
- Widget receives only `WidgetSharedPayload`.
- HomeView does not call Toronto API directly.
- HomeView does not call Widget APIs directly.

## Verification

### GitHub Actions

GitHub Actions workflow:

```text
.github/workflows/ios-build.yml
```

The workflow runs:

```text
xcodebuild -project BinPeek.xcodeproj -scheme BinPeek -destination 'platform=iOS Simulator,name=iPhone 16' build
```

Expected result:
- latest `iOS Build` run completes successfully.

### Manual App Verification

1. Open `BinPeek.xcodeproj` in Xcode.
2. Build and run the `BinPeek` scheme.
3. Verify app launch.
4. Open Settings.
5. Select a collection calendar, for example `Tuesday1`.
6. Return to Home.
7. Tap the refresh button.
8. Verify loading state appears and then ends.
9. Verify Home displays the refreshed schedule or a safe error state.
10. Restart the app and verify saved schedule persistence.

### Manual Widget Verification

1. Add the BinPeek widget to the iOS Home Screen.
2. Before app refresh, verify fallback content appears.
3. In the app, select Calendar in Settings.
4. Refresh schedule from Home.
5. Return to the Home Screen.
6. Verify the widget updates to the shared payload.

Expected widget fallback:

```text
Tonight:
Green Bin
Recycling
```

Expected dynamic widget behavior:
- Widget reads `WidgetSharedPayload` from App Group `UserDefaults`.
- Widget renders `payload.title`.
- Widget renders `payload.items`.

## Known Limitations

- No automatic address to collection calendar matching.
- Postal code and street address are not used for calendar detection.
- WeekStarting semantics still need validation against real Toronto schedule behavior.
- No test target yet.
- Runtime behavior has not been fully manually verified on local Mac/Xcode in this environment.
- App Group must be configured correctly in Apple Developer for real signing.
- Widget reload is a system request and does not guarantee immediate visual refresh.

## Development Workflow

Project workflow:

```text
PM request
-> Technical Spec
-> PM approval
-> Codex implementation
-> Review
-> CI verification
```

New features require a Technical Spec and PM approval before code changes.

