struct TorontoCollectionScheduleDTO: Decodable {
    let id: Int?
    let calendar: String?
    let weekStarting: String?
    let greenBin: String?
    let garbage: String?
    let recycling: String?
    let yardWaste: String?
    let christmasTree: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case calendar = "Calendar"
        case weekStarting = "WeekStarting"
        case greenBin = "GreenBin"
        case garbage = "Garbage"
        case recycling = "Recycling"
        case yardWaste = "YardWaste"
        case christmasTree = "ChristmasTree"
    }

    func toRecord() -> TorontoCollectionScheduleRecord {
        TorontoCollectionScheduleRecord(
            calendar: calendar,
            weekStartingRaw: weekStarting,
            greenBinRaw: greenBin,
            garbageRaw: garbage,
            recyclingRaw: recycling,
            yardWasteRaw: yardWaste,
            christmasTreeRaw: christmasTree
        )
    }
}
