import Foundation

extension FileManager {
    public func pictures(at: URL) -> Set<Picture> {
        enumerator(at: at, includingPropertiesForKeys: [
            .contentTypeKey,
            .creationDateKey,
            .fileSizeKey],
                   options: [
                    .producesRelativePathURLs,
                    .skipsHiddenFiles,
                    .skipsPackageDescendants,
                    .skipsSubdirectoryDescendants])
            .map {
                .init($0.compactMap(Picture.init(item:)))
            }
        ?? []
    }
}
