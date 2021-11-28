import Foundation
import Archivable

public struct Bookmark: Storable, Identifiable {
    public let id: String
    private let bookmark: Data
    
    public var data: Data {
        .init()
        .adding(size: UInt16.self, string: id)
        .wrapping(size: UInt16.self, data: bookmark)
    }
    
    public init(data: inout Data) {
        id = data.string(size: UInt16.self)
        bookmark = data.unwrap(size: UInt16.self)
    }
    
    init(url: URL) throws {
        guard let bookmark = try? url.bookmarkData(options: .withSecurityScope) else { throw CoreError.noAccess }
        id = url.absoluteString
        self.bookmark = bookmark
    }
    
    init(dummy: String) {
        id = dummy
        bookmark = .init()
    }
    
    var url: URL {
        get throws {
            var stale = false
            
            guard
                let access = try? URL(resolvingBookmarkData: bookmark, options: .withSecurityScope, bookmarkDataIsStale: &stale),
                access.startAccessingSecurityScopedResource()
            else { throw CoreError.noAccess }
                
            guard
                FileManager.default.fileExists(atPath: access.path),
                !access.pathComponents.map(\.localizedLowercase).contains(".trash")
            else {
                access.stopAccessingSecurityScopedResource()
                throw CoreError.notFound
            }
            
            return access
        }
    }
}
