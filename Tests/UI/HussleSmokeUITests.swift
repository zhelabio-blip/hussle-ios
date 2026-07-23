import XCTest

final class HussleSmokeUITests: XCTestCase {
    func testDemoLaunchShowsDiscoverAndTabs() {
        let app = XCUIApplication()
        app.launchArguments.append("UITEST_DEMO")
        app.launch()

        XCTAssertTrue(app.staticTexts["discoverTitle"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.tabBars.buttons["Discover"].exists)
        XCTAssertTrue(app.tabBars.buttons["Matches"].exists)
        XCTAssertTrue(app.tabBars.buttons["Messages"].exists)
        XCTAssertTrue(app.tabBars.buttons["Profile"].exists)
        XCTAssertTrue(app.buttons["exitDemoButton"].exists)
    }

    func testDemoModeRemainsAvailableWithBackendConfiguredAndStartsOnboarding() {
        let app = XCUIApplication()
        app.launchArguments.append("UITEST_AUTH")
        app.launch()

        XCTAssertTrue(app.buttons["demoModeButton"].waitForExistence(timeout: 5))
        app.buttons["demoModeButton"].tap()
        XCTAssertTrue(app.buttons["Get started"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["exitDemoButton"].exists)
        XCTAssertFalse(app.staticTexts["discoverTitle"].exists)
    }

    func testExitDemoReturnsToAuthenticationFromMainExperience() {
        let app = XCUIApplication()
        app.launchArguments.append("UITEST_DEMO")
        app.launch()

        XCTAssertTrue(app.buttons["exitDemoButton"].waitForExistence(timeout: 5))
        app.buttons["exitDemoButton"].tap()

        XCTAssertTrue(app.buttons["demoModeButton"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["discoverTitle"].exists)
    }

    func testExitDemoReturnsToAuthenticationFromOnboarding() {
        let app = XCUIApplication()
        app.launchArguments.append("UITEST_AUTH")
        app.launch()

        XCTAssertTrue(app.buttons["demoModeButton"].waitForExistence(timeout: 5))
        app.buttons["demoModeButton"].tap()
        XCTAssertTrue(app.buttons["exitDemoButton"].waitForExistence(timeout: 5))
        app.buttons["exitDemoButton"].tap()

        XCTAssertTrue(app.buttons["demoModeButton"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["Get started"].exists)
    }

    func testCanOpenProfileFromDiscoverCard() {
        let app = XCUIApplication()
        app.launchArguments.append("UITEST_DEMO")
        app.launch()

        XCTAssertTrue(app.staticTexts["discoverTitle"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["profileInfoButton"].waitForExistence(timeout: 3))
        app.buttons["profileInfoButton"].tap()
    }
}
