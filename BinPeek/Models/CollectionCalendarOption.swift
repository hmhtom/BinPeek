struct CollectionCalendarOption: Identifiable {
    let id: String
    let title: String

    static let all: [CollectionCalendarOption] = [
        CollectionCalendarOption(id: "Tuesday1", title: "Tuesday 1"),
        CollectionCalendarOption(id: "Tuesday2", title: "Tuesday 2"),
        CollectionCalendarOption(id: "Wednesday1", title: "Wednesday 1"),
        CollectionCalendarOption(id: "Wednesday2", title: "Wednesday 2"),
        CollectionCalendarOption(id: "Thursday1", title: "Thursday 1"),
        CollectionCalendarOption(id: "Thursday2", title: "Thursday 2"),
        CollectionCalendarOption(id: "Friday1", title: "Friday 1"),
        CollectionCalendarOption(id: "Friday2", title: "Friday 2")
    ]
}
