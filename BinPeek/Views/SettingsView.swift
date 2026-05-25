import SwiftUI

struct SettingsView: View {
    private let usesStorage: Bool

    @State private var selectedCalendarID: String?

    init(
        selectedCalendarID: String? = nil,
        usesStorage: Bool = true
    ) {
        self.usesStorage = usesStorage
        _selectedCalendarID = State(initialValue: selectedCalendarID)
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Collection Calendar") {
                    ForEach(CollectionCalendarOption.all) { option in
                        Button {
                            selectCalendar(option)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(option.title)
                                    Text(option.id)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                if selectedCalendarID == option.id {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                Section {
                    HStack {
                        Text("Reminder Time")
                        Spacer()
                        Text("8:00 PM")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Theme")
                        Spacer()
                        Text("System")
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                loadSavedCalendar()
            }
        }
    }

    private func loadSavedCalendar() {
        guard usesStorage else {
            return
        }

        guard let savedCalendar = StorageManager.shared.loadCollectionCalendar() else {
            selectedCalendarID = nil
            return
        }

        selectedCalendarID = CollectionCalendarOption.all.contains { option in
            option.id == savedCalendar
        } ? savedCalendar : nil
    }

    private func selectCalendar(_ option: CollectionCalendarOption) {
        selectedCalendarID = option.id

        guard usesStorage else {
            return
        }

        StorageManager.shared.saveCollectionCalendar(option.id)
    }
}

#Preview("Default") {
    SettingsView(usesStorage: false)
}

#Preview("Light") {
    SettingsView(usesStorage: false)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    SettingsView(usesStorage: false)
        .preferredColorScheme(.dark)
}

#Preview("iPhone SE") {
    SettingsView(usesStorage: false)
        .previewDevice("iPhone SE (3rd generation)")
}

#Preview("iPhone 15 Pro") {
    SettingsView(usesStorage: false)
        .previewDevice("iPhone 15 Pro")
}
