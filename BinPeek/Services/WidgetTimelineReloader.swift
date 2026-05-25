import WidgetKit

struct WidgetTimelineReloader {
    func reloadBinPeekWidget() {
        WidgetCenter.shared.reloadTimelines(ofKind: SharedConstants.binPeekWidgetKind)
    }
}
