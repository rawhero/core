import XCTest
@testable import Archivable
@testable import Core

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testCurrent() async {
        archive.bookmarks = [.init(dummy: "hello world")]
        var prototyped = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(1, prototyped.bookmarks.count)
        XCTAssertNil(prototyped.current)
        
        archive.current = .init(dummy: "lorem")
        prototyped = await Archive.prototype(data: archive.compressed)
        XCTAssertNotNil(prototyped.current)
    }
}
