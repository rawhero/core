import XCTest
import Archivable
@testable import Core

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    
    override func setUp() {
        cloud = .ephemeral
        subs = []
    }
    
    func testBookmarks() async {
        let bookmark = Bookmark(dummy: "hello")
        await cloud.add(bookmark: bookmark)
        
        let current = await cloud.model.current?.id
        var count = await cloud.model.bookmarks.count
        XCTAssertEqual(bookmark.id, current)
        XCTAssertEqual(1, count)
        
        await cloud.add(bookmark: bookmark)
        
        count = await cloud.model.bookmarks.count
        XCTAssertEqual(1, count)
    }
}
