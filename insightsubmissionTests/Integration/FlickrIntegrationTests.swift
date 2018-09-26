//
//  FlickrIntegrationTests.swift
//  insightsubmissionTests
//
//  Created by Marc O'Neill on 22/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import XCTest
@testable import insightsubmission

class FlickrIntegrationTests: XCTestCase {

    var sut: FlickrAPIClient!

    override func setUp() {
        super.setUp()
        sut = FlickrAPIClient(session: URLSession.shared)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testResponseNotNil_givenLatitudeLongitude() {
        let expectation = self.expectation(description: "Response not nil")
        var success = false
        sut.getPhotos(latitude: 0, longitude: 0) { result in
            switch result {
            case .success(let photosResult):
                success = photosResult.photos != nil
                expectation.fulfill()
            default:
                success = false
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(success, "Response not successful")
    }

    func testResponseNotNil_givenText() {
        let expectation = self.expectation(description: "Response not nil")
        var success = false
        sut.getPhotos(text: "test") { result in
            switch result {
            case .success(let photosResult):
                success = photosResult.photos != nil
                expectation.fulfill()
            default:
                success = false
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(success, "Response not successful")
    }

    func testResponseNotNil_givenTag() {
        let expectation = self.expectation(description: "Response not nil")
        var success = false
        sut.getPhotos(tag: "test") { result in
            switch result {
            case .success(let photosResult):
                success = photosResult.photos != nil
                expectation.fulfill()
            default:
                success = false
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(success, "Response not successful")
    }
}
