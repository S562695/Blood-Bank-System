//
//  Blood_Bank_SystemUITests.swift
//  Blood-Bank-SystemUITests
//
//  Created by Konanki,Naga Lakshmi on 3/29/24.
//

import XCTest

final class Blood_Bank_SystemUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
                app = XCUIApplication()
                app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        XCUIApplication().buttons["Logout"].tap()
    }
    
    func testUserRegistration() throws {
            // UI test for user registration flow
            let userNameTextField = app.textFields["usernameTextField"]
            XCTAssertTrue(userNameTextField.exists, "Username text field should exist")
            
            let emailTextField = app.textFields["emailTextField"]
            XCTAssertTrue(emailTextField.exists, "Email text field should exist")
            
            let passwordTextField = app.secureTextFields["passwordTextField"]
            XCTAssertTrue(passwordTextField.exists, "Password text field should exist")
            
            let signUpButton = app.buttons["signUpButton"]
            XCTAssertTrue(signUpButton.exists, "Sign Up button should exist")
            
            // Perform user registration
            userNameTextField.tap()
            userNameTextField.typeText("John Doe")
            
            emailTextField.tap()
            emailTextField.typeText("john@example.com")
            
            passwordTextField.tap()
            passwordTextField.typeText("password123")
            
            signUpButton.tap()
            
            // Verify successful registration
            XCTAssertTrue(app.staticTexts["registrationSuccessLabel"].exists, "Registration should be successful")
        }
    
    func testFAQSection() throws {
            // Tap on the FAQ button to navigate to the FAQ section
            app.buttons["faqButton"].tap()

            // Verify that the FAQ screen is displayed
            XCTAssertTrue(app.navigationBars["FAQ"].exists)

            // Check for email and textbox for inquiries
            XCTAssertTrue(app.textFields["emailTextField"].exists)
            XCTAssertTrue(app.textViews["inquiryTextView"].exists)
        }

        func testProfileManagement() throws {
            // Tap on the profile button to navigate to the profile screen
            app.buttons["profileButton"].tap()

            // Verify that the profile screen is displayed
            XCTAssertTrue(app.navigationBars["Profile"].exists)

            // Simulate profile management actions, such as editing user information
            let editButton = app.buttons["editButton"]
            XCTAssertTrue(editButton.exists)
            editButton.tap()

            // Verify that the edit profile screen is displayed
            XCTAssertTrue(app.navigationBars["Edit Profile"].exists)

            // Simulate editing user information
            let nameTextField = app.textFields["nameTextField"]
            nameTextField.tap()
            nameTextField.typeText("Updated Name")

            let saveButton = app.buttons["saveButton"]
            XCTAssertTrue(saveButton.exists)
            saveButton.tap()

            // Verify that the user information is updated successfully
            XCTAssertTrue(app.staticTexts["Updated Name"].exists)
        }

        func testSearchBloodDonors() throws {
        // Assuming there's a text field to enter blood type and a button to search
        let bloodTypeTextField = app.textFields["bloodTypeTextField"]
        bloodTypeTextField.tap()
        bloodTypeTextField.typeText("O+")
        
        let searchButton = app.buttons["searchButton"]
        searchButton.tap()
        
        // Assuming there's a table view displaying search results
        let donorsTableView = app.tables["donorsTableView"]
        XCTAssertTrue(donorsTableView.cells.count > 0)
        
        // Additional assertions can be added to verify specific donor information
    }
    
    func testMakeBloodDonationRequest() throws {
        // Assuming there's a text field for requester name, blood type, and a button to request donation
        let requesterNameTextField = app.textFields["requesterNameTextField"]
        requesterNameTextField.tap()
        requesterNameTextField.typeText("John Doe")
        
        let bloodTypeTextField = app.textFields["bloodTypeTextField"]
        bloodTypeTextField.tap()
        bloodTypeTextField.typeText("A-")
        
        let requestButton = app.buttons["requestButton"]
        requestButton.tap()
        
        // Assuming there's a confirmation message or UI element after making the request
        let confirmationLabel = app.staticTexts["confirmationLabel"]
        XCTAssertTrue(confirmationLabel.exists)
    }

        func testDonorInformation() throws {
            // Tap on the donor info button to navigate to the donor info screen
            app.buttons["donorInfoButton"].tap()

            // Verify that the donor info screen is displayed
            XCTAssertTrue(app.navigationBars["Donor Information"].exists)

            // Simulate entering and amending donor information
            let bloodTypeTextField = app.textFields["bloodTypeTextField"]
            bloodTypeTextField.tap()
            bloodTypeTextField.typeText("O+")

            let locationTextField = app.textFields["locationTextField"]
            locationTextField.tap()
            locationTextField.typeText("New York")

            // Save donor information
            app.buttons["saveButton"].tap()

            // Verify that donor information is saved successfully
            XCTAssertTrue(app.staticTexts["O+"].exists)
            XCTAssertTrue(app.staticTexts["New York"].exists)
        }

        func testLiveChat() throws {
            // Tap on the live chat button to navigate to the live chat screen
            app.buttons["liveChatButton"].tap()

            // Verify that the live chat screen is displayed
            XCTAssertTrue(app.navigationBars["Live Chat"].exists)

            // Simulate sending a message in live chat
            let messageTextField = app.textFields["messageTextField"]
            messageTextField.tap()
            messageTextField.typeText("Hello, I need some help.")

            app.buttons["sendButton"].tap()

            // Verify that the message is sent successfully
            XCTAssertTrue(app.staticTexts["Hello, I need some help."].exists)
        }

        func testDonationFeedback() throws {
            // Tap on the donation feedback button to navigate to the donation feedback screen
            app.buttons["donationFeedbackButton"].tap()

            // Verify that the donation feedback screen is displayed
            XCTAssertTrue(app.navigationBars["Donation Feedback"].exists)

            // Simulate providing feedback and rating
            let feedbackTextView = app.textViews["feedbackTextView"]
            feedbackTextView.tap()
            feedbackTextView.typeText("Great experience!")

            // Tap on the rating stars
            app.buttons["starButton"].tap()

            // Verify that the feedback is submitted successfully
            XCTAssertTrue(app.staticTexts["Feedback submitted!"].exists)
        }

        func testBloodDonationInformation() throws {
            // Tap on the blood donation info button to navigate to the blood donation info screen
            app.buttons["bloodDonationInfoButton"].tap()

            // Verify that the blood donation info screen is displayed
            XCTAssertTrue(app.navigationBars["Blood Donation Information"].exists)

            // Check for informational materials
            XCTAssertTrue(app.staticTexts["Value of Blood Donation"].exists)
        }

        func testScheduleAppointment() throws {
            // Tap on the schedule appointment button to navigate to the schedule appointment screen
            app.buttons["scheduleAppointmentButton"].tap()

            // Verify that the schedule appointment screen is displayed
            XCTAssertTrue(app.navigationBars["Schedule Appointment"].exists)

            // Simulate scheduling an appointment
            let datePicker = app.datePickers["appointmentDatePicker"]
            datePicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "June")
            datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "29")
            datePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2024")

            // Save the appointment
            app.buttons["saveButton"].tap()

            // Verify that the appointment is scheduled successfully
            XCTAssertTrue(app.staticTexts["Appointment scheduled for June 29, 2024"].exists)
        }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
