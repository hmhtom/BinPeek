import Foundation

struct WidgetSharedPayload: Codable {
    let updatedAt: Date
    let title: String
    let items: [WidgetCollectionItem]
}
