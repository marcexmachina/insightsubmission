//
//  PhotoTests.swift
//  insightsubmissionTests
//
//  Created by Marc O'Neill on 18/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import XCTest
@testable import insightsubmission

class PhotoTests: XCTestCase {

    var jsonData: Data!
    
    override func setUp() {
        super.setUp()

        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "text_search_response", withExtension: "json") else { return }
        jsonData = try! Data(contentsOf: url)
    }
    
    func testNumberOfPhotosGivenJSON() {
        do {
            let flickrResponse: FlickrPhotosResult = try JSONDecoder().decode(FlickrPhotosResult.self, from: jsonData)
            XCTAssert(flickrResponse.photos?.photo.count == 3, "Incorrect number of photos")
        } catch(let error) {
            XCTFail("\(error)")
        }
    }

    func testIsPublicIsTrue() {
        do {
            let flickrResponse: FlickrPhotosResult = try JSONDecoder().decode(FlickrPhotosResult.self, from: jsonData)
            XCTAssert((flickrResponse.photos?.photo.first!.isPublic)!, "Photo.isPublic value incorrect")
        } catch(let error) {
            XCTFail("\(error)")
        }
    }

    func testIsFriendIsFalse() {
        do {
            let flickrResponse: FlickrPhotosResult = try JSONDecoder().decode(FlickrPhotosResult.self, from: jsonData)
            XCTAssert((flickrResponse.photos?.photo.first!.isFriend)! == false, "Photo.isFriend value incorrect")
        } catch(let error) {
            XCTFail("\(error)")
        }
    }

    func testIsFamilyIsFalse() {
        do {
            let flickrResponse: FlickrPhotosResult = try JSONDecoder().decode(FlickrPhotosResult.self, from: jsonData)
            XCTAssert((flickrResponse.photos?.photo.first!.isFamily)! == false, "Photo.isFamily value incorrect")
        } catch(let error) {
            XCTFail("\(error)")
        }
    }
    
}
