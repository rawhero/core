import XCTest
@testable import Core

final class DefaultsTests: XCTestCase {
    override func setUp() {
        UserDefaults.standard.removeObject(forKey: Defaults.rated.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.created.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.premium.rawValue)
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: Defaults.rated.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.created.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.premium.rawValue)
    }
    
    func testFirstTime() {
        XCTAssertNil(UserDefaults.standard.object(forKey: Defaults.created.rawValue))
        XCTAssertEqual(.none, Defaults.action)
        XCTAssertNotNil(UserDefaults.standard.object(forKey: Defaults.created.rawValue))
    }
    
    func testRate() {
        UserDefaults.standard.setValue(Calendar.current.date(byAdding: .day, value: -6, to: .now)!, forKey: Defaults.created.rawValue)
        XCTAssertEqual(.none, Defaults.action)
        XCTAssertFalse(Defaults.hasRated)
        UserDefaults.standard.setValue(Calendar.current.date(byAdding: .day, value: -7, to: .now)!, forKey: Defaults.created.rawValue)
        XCTAssertEqual(.rate, Defaults.action)
        XCTAssertTrue(Defaults.hasRated)
        XCTAssertEqual(.none, Defaults.action)
    }
    
    func testFroob() {
        UserDefaults.standard.setValue(Calendar.current.date(byAdding: .day, value: -8, to: .now)!, forKey: Defaults.created.rawValue)
        UserDefaults.standard.setValue(true, forKey: Defaults.rated.rawValue)
        XCTAssertEqual(.none, Defaults.action)
        UserDefaults.standard.setValue(Calendar.current.date(byAdding: .day, value: -9, to: .now)!, forKey: Defaults.created.rawValue)
        XCTAssertEqual(.froob, Defaults.action)
        XCTAssertEqual(.froob, Defaults.action)
    }
    
    func testPremium() {
        UserDefaults.standard.setValue(Calendar.current.date(byAdding: .day, value: -9, to: .now)!, forKey: Defaults.created.rawValue)
        UserDefaults.standard.setValue(true, forKey: Defaults.premium.rawValue)
        XCTAssertEqual(.rate, Defaults.action)
    }
    
    func testCompleted() {
        UserDefaults.standard.setValue(Calendar.current.date(byAdding: .day, value: -9, to: .now)!, forKey: Defaults.created.rawValue)
        UserDefaults.standard.setValue(true, forKey: Defaults.premium.rawValue)
        UserDefaults.standard.setValue(true, forKey: Defaults.rated.rawValue)
        XCTAssertEqual(.none, Defaults.action)
    }
}
