//
//  ReservationViewModelTests.swift
//  ReservationViewModelTests
//
//  Created by Ani's Mac on 04.02.24.
//

import XCTest
@testable import Reserved

final class ReservationViewModelTests: XCTestCase {
    var viewModel: ReservationViewModel!
    
    // MARK: - Override functions
    override func setUpWithError() throws {
        viewModel = ReservationViewModel(selectedRestaurant: createMockRestaurant())
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    // MARK: - Tests
    func testIncrementGuestCount() {
        viewModel.guestCount = 2
        viewModel.incrementGuestCount()
        XCTAssertEqual(viewModel.guestCount, 3)
    }
    
    func testIncrementGuestCountJustBelowUpperLimit() {
        viewModel.guestCount = 11
        viewModel.incrementGuestCount()
        XCTAssertEqual(viewModel.guestCount, 12)
    }
    
    func testIncrementGuestCountAtUpperLimit() {
        viewModel.guestCount = 12
        viewModel.incrementGuestCount()
        XCTAssertEqual(viewModel.guestCount, 12)
    }
    
    func testDecrementGuestCount() {
        viewModel.guestCount = 2
        viewModel.decrementGuestCount()
        XCTAssertEqual(viewModel.guestCount, 1)
    }
    
    func testDecrementGuestCountAtLowerLimit() {
        viewModel.guestCount = 1
        viewModel.decrementGuestCount()
        XCTAssertEqual(viewModel.guestCount, 1)
    }
    
    func testSetSelectedDate() {
        let testDate = Date()
        viewModel.setSelectedDate(testDate)
        XCTAssertEqual(viewModel.selectedDate, testDate)
    }
    
    func testRestaurantNameFormatting() {
        XCTAssertEqual(viewModel.restaurantName, "TEST RESTAURANT")
    }
    
    func testFormattedRestaurantName() {
        let expectedFormattedName = viewModel.restaurantName.map { String($0) }.joined(separator: " ")
        XCTAssertEqual(viewModel.formattedRestaurantName, expectedFormattedName)
    }
    
    // MARK: - Mock Data
    private func createMockRestaurant() -> Restaurant {
        let mockDay = Day(startTime: .the100Am, endTime: .the900Am)
        let openHours = OpenHours(monday: mockDay, tuesday: mockDay, wednesday: mockDay, thursday: mockDay, friday: mockDay, saturday: mockDay, sunday: mockDay)
        let location = Location(address: "Test Address", latitude: 0.0, longitude: 0.0)
        
        return Restaurant(id: 1, name: "Test Restaurant", cuisine: "Test Cuisine", mainImageURL: nil, openHours: openHours, location: location, description: "Test Description", websiteURL: "http://example.com", menuURL: "http://example.com/menu", phoneNumber: "123-456-7890", reviewStars: 5.0)
    }
}

