//
//  Blood_Bank_SystemTests.swift
//  Blood-Bank-SystemTests
//
//  Created by Konanki,Naga Lakshmi on 3/29/24.
//

import XCTest
@testable import Blood_Bank_System

final class Blood_Bank_SystemTests: XCTestCase {
    
    var bloodBankSystem: BloodBankSystem!

    override func setUpWithError() throws {
        super.setUp()
        //bloodBankSystem = BloodBankSystem()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUserRegistration_Success() {
            let user = User(email: "lk@gmail.com", name: "Lakshmi", password: "987654")
            let registrationResult = bloodBankSystem.registerUser(user)
            
            XCTAssertEqual(registrationResult, .success, "User registration should be successful")
        }
        
        func testUserRegistration_Failure_DuplicateEmail() {
            let user1 = User(name: "John Doe", email: "john@example.com", password: "password123")
            bloodBankSystem.registerUser(user1)
            
            let user2 = User(name: "Jane Doe", email: "john@example.com", password: "password456")
            let registrationResult = bloodBankSystem.registerUser(user2)
            
            XCTAssertEqual(registrationResult, .failure(.duplicateEmail), "User registration should fail due to duplicate email")
        }

        // MARK: - Admin Registration Tests

        func testAdminRegistration_Success() {
            let admin = Admin(name: "Admin", email: "admin@example.com", password: "admin123")
            let registrationResult = bloodBankSystem.registerAdmin(admin)
            
            XCTAssertEqual(registrationResult, .success, "Admin registration should be successful")
        }
        
        func testAdminRegistration_Failure_DuplicateEmail() {
            let admin1 = Admin(name: "Admin", email: "admin@example.com", password: "admin123")
            bloodBankSystem.registerAdmin(admin1)
            
            let admin2 = Admin(name: "Admin 2", email: "admin@example.com", password: "admin456")
            let registrationResult = bloodBankSystem.registerAdmin(admin2)
            
            XCTAssertEqual(registrationResult, .failure(.duplicateEmail), "Admin registration should fail due to duplicate email")
        }

        // MARK: - Donor Profile Management Tests

        func testDonorProfileManagement_Success() {
            let donor = Donor(name: "Donor", email: "donor@example.com", bloodType: .ABPositive, location: "New York")
            let updateResult = bloodBankSystem.updateDonorProfile(donor)
            
            XCTAssertEqual(updateResult, .success, "Donor profile should be updated successfully")
        }

        // MARK: - Patient Profile Management Tests

        func testPatientProfileManagement_Success() {
            let patient = Patient(name: "Patient", email: "patient@example.com", location: "Los Angeles")
            let updateResult = bloodBankSystem.updatePatientProfile(patient)
            
            XCTAssertEqual(updateResult, .success, "Patient profile should be updated successfully")
        }


// Struct representing a blood donor
struct BloodDonor {
    let name: String
    let bloodType: String
}

// Struct representing a blood donation request
struct BloodDonationRequest {
    let requesterName: String
    let bloodTypeNeeded: String
}

// Function to search for blood donors by blood type
func findBloodDonors(by bloodType: String, donors: [BloodDonor]) -> [BloodDonor] {
    let matchingDonors = donors.filter { $0.bloodType == bloodType }
    return matchingDonors
}

// Function to make a blood donation request
func makeBloodDonationRequest(request: BloodDonationRequest, donors: [BloodDonor]) -> Bool {
    let potentialDonors = findBloodDonors(by: request.bloodTypeNeeded, donors: donors)
    
    // Logic for making the request, e.g., contacting potential donors
    
    return !potentialDonors.isEmpty
}

class BloodDonationTests: XCTestCase {
    func testFindBloodDonors() {
        let donors = [
            BloodDonor(name: "lakshmi", bloodType: "O+"),
            BloodDonor(name: "meghana", bloodType: "A-"),
            BloodDonor(name: "meghala", bloodType: "AB+"),
            BloodDonor(name: "Greeshma", bloodType: "O+")
        ]
        
        let oPositiveDonors = findBloodDonors(by: "O+", donors: donors)
        XCTAssertEqual(oPositiveDonors.count, 2)
    }
    
    func testMakeBloodDonationRequest() {
        let donors = [
            BloodDonor(name: "lakshmi", bloodType: "O+"),
            BloodDonor(name: "meghana", bloodType: "A-"),
            BloodDonor(name: "meghala", bloodType: "AB+"),
            BloodDonor(name: "Gresshma", bloodType: "O+")
        ]
        
        let request = BloodDonationRequest(requesterName: "meghana", bloodTypeNeeded: "A-")
        XCTAssertTrue(makeBloodDonationRequest(request: request, donors: donors))
    }
}


        // MARK: - Live Chat Tests
        
        func testLiveChat_SendsMessage_Success() {
            let user = User(email: "lk@gmail.com.com", name: "Lakshmi", password: "password123")
            bloodBankSystem.registerUser(user)
            
            let message = "Hello, I need some help."
            let sendMessageResult = bloodBankSystem.sendMessage(message, from: user)
            
            XCTAssertEqual(sendMessageResult, .success, "Sending message in live chat should be successful")
        }
        
        func testLiveChat_SendsMessage_Failure_UserNotRegistered() {
            let user = User(name: "John Doe", email: "john@example.com", password: "password123")
            
            let message = "Hello, I need some help."
            let sendMessageResult = bloodBankSystem.sendMessage(message, from: user)
            
            XCTAssertEqual(sendMessageResult, .failure(.userNotRegistered), "Sending message in live chat should fail due to user not registered")
        }

        // MARK: - Notification Tests
        
        func testNotification_SendsNotification_Success() {
            let donor = Donor(name: "Donor", email: "donor@example.com", bloodType: .ABPositive)
            bloodBankSystem.registerDonor(donor)
            
            let bloodRequest = BloodRequest(bloodType: .ABPositive, location: "New York")
            let sendNotificationResult = bloodBankSystem.sendNotification(for: donor, with: bloodRequest)
            
            XCTAssertEqual(sendNotificationResult, .success, "Sending notification should be successful")
        }
        
        func testNotification_SendsNotification_Failure_DonorUnavailable() {
            let donor = Donor(name: "Donor", email: "donor@example.com", bloodType: .ABPositive)
            
            let bloodRequest = BloodRequest(bloodType: .ABPositive, location: "New York")
            let sendNotificationResult = bloodBankSystem.sendNotification(for: donor, with: bloodRequest)
            
            XCTAssertEqual(sendNotificationResult, .failure(.donorUnavailable), "Sending notification should fail due to donor unavailable")
        }

        // MARK: - Scheduling Appointment Tests
        
        func testScheduleAppointment_Success() {
            let donor = Donor(name: "Donor", email: "donor@example.com", bloodType: .ABPositive)
            bloodBankSystem.registerDonor(donor)
            
            let appointmentDate = Date().addingTimeInterval(3600) // One hour from now
            let scheduleAppointmentResult = bloodBankSystem.scheduleAppointment(for: donor, at: appointmentDate)
            
            XCTAssertEqual(scheduleAppointmentResult, .success, "Scheduling appointment should be successful")
        }
        
        func testScheduleAppointment_Failure_DonorUnavailable() {
            let donor = Donor(name: "Naga Lakshmi", email: "donor@gmail.com", bloodType: .ABPositive)
            
            let appointmentDate = Date().addingTimeInterval(3600) // One hour from now
            let scheduleAppointmentResult = bloodBankSystem.scheduleAppointment(for: donor, at: appointmentDate)
            
            XCTAssertEqual(scheduleAppointmentResult, .failure(.donorUnavailable), "Scheduling appointment should fail due to donor unavailable")
        }
}
