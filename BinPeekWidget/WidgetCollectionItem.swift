enum WidgetCollectionType: Codable {
    case greenBin
    case recycling
    case garbage
}

struct WidgetCollectionItem: Codable {
    let type: WidgetCollectionType
    let title: String
}
