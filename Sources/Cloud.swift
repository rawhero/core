import Foundation
import Archivable

extension Cloud where Output == Archive {
    nonisolated public func load() {
        Task {
            await load("iCloud.rawhero")
        }
    }
    
    public var current: (bookmark: Bookmark, url: URL) {
        get throws {
            guard let current = model.current else { throw CoreError.noCurrent }
            return (bookmark: current, url: try open(bookmark: current))
        }
    }
    
    public func bookmark(url: URL) throws -> (bookmark: Bookmark, url: URL) {
        let bookmark = try Bookmark(url: url)
        add(bookmark: bookmark)
        
        Task
            .detached(priority: .utility) {
                await self.stream()
            }
        
        return (bookmark: bookmark, url: try open(bookmark: bookmark))
    }
    
    public func open(bookmark: Bookmark) throws -> URL {
        do {
            return try bookmark.url
        } catch let error {
            Task
                .detached(priority: .utility) {
                    await self.remove(bookmark: bookmark)
                }
            throw error
        }
    }
    
    public func close(bookmark: Bookmark, url: URL) {
        url.stopAccessingSecurityScopedResource()
        guard bookmark.id == model.current?.id else { return }
        model.current = nil
        
        Task
            .detached(priority: .utility) {
                await self.stream()
            }
    }
    
    func add(bookmark: Bookmark) {
        model.bookmarks = bookmark + model
            .bookmarks
            .filter {
                $0.id != bookmark.id
            }
        
        model.current = bookmark
    }
    
    private func remove(bookmark: Bookmark) async {
        var synch = false
        
        if model.current?.id == bookmark.id {
            model.current = nil
            synch = true
        }
        
        if model.bookmarks.contains(where: { $0.id == bookmark.id }) {
            model.bookmarks = model
                .bookmarks
                .filter {
                    $0.id != bookmark.id
                }
            
            synch = true
        }
        
        if synch {
            await stream()
        }
    }
}
