//
//  Blood_Bank_SystemUITestsLaunchTests.swift
//  Blood-Bank-SystemUITests
//
//  Created by Konanki,Naga Lakshmi on 3/29/24.
//

import XCTest

final class Blood_Bank_SystemUITestsLaunchTests: XCTestCase {
    
    var app: XCUIApplication!

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Login Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    // Test launching the app with valid credentials
        func testLaunchWithValidCredentials() throws {
            app.launchArguments.append("validCredentials")
            app.launch()
            XCTAssertTrue(app.isDisplayingDashboard)
        }

        // Test launching the app with invalid credentials
        func testLaunchWithInvalidCredentials() throws {
            app.launchArguments.append("invalidCredentials")
            app.launch()
            XCTAssertTrue(app.isDisplayingLoginScreen)
        }

        // Test launching the app with empty username
        func testLaunchWithEmptyUsername() throws {
            app.launchArguments.append("emptyUsername")
            app.launch()
            XCTAssertTrue(app.isDisplayingLoginScreen)
        }

        // Test launching the app with empty password
        func testLaunchWithEmptyPassword() throws {
            app.launchArguments.append("emptyPassword")
            app.launch()
            XCTAssertTrue(app.isDisplayingLoginScreen)
        }

        // Test launching the app with no internet connection
        func testLaunchWithNoInternetConnection() throws {
            app.launchArguments.append("noInternetConnection")
            app.launch()
            XCTAssertTrue(app.isDisplayingNoInternetConnectionScreen)
        }

        // Test launching the app with slow internet connection
        func testLaunchWithSlowInternetConnection() throws {
            app.launchArguments.append("slowInternetConnection")
            app.launch()
            XCTAssertTrue(app.isDisplayingNoInternetConnectionScreen)
        }
    }

    extension XCUIApplication {
        var isDisplayingLoginScreen: Bool {
            return otherElements["loginView"].exists
        }

        var isDisplayingDashboard: Bool {
            return otherElements["dashboardView"].exists
        }

        var isDisplayingNoInternetConnectionScreen: Bool {
            return otherElements["noInternetConnectionView"].exists
        }
}
