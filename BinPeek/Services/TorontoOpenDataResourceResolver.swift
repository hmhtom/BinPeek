import Foundation

struct TorontoOpenDataResourceResolver {
    func resolveLatestJSONScheduleResource(
        from resources: [TorontoOpenDataResource]
    ) -> TorontoScheduleResource? {
        resources
            .compactMap(makeScheduleResource(from:))
            .max { lhs, rhs in
                lhs.year < rhs.year
            }
    }

    private func makeScheduleResource(
        from resource: TorontoOpenDataResource
    ) -> TorontoScheduleResource? {
        guard
            resource.format.caseInsensitiveCompare("JSON") == .orderedSame,
            !resource.url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            let year = parseYear(from: resource.name)
        else {
            return nil
        }

        return TorontoScheduleResource(
            year: year,
            url: resource.url,
            format: resource.format
        )
    }

    private func parseYear(from name: String) -> Int? {
        let pattern = #"(?<!\d)\d{4}(?!\d)"#
        guard
            let regex = try? NSRegularExpression(pattern: pattern),
            let match = regex.firstMatch(
                in: name,
                range: NSRange(name.startIndex..., in: name)
            ),
            let range = Range(match.range, in: name),
            let year = Int(name[range])
        else {
            return nil
        }

        guard (1900...3000).contains(year) else {
            return nil
        }

        return year
    }
}
