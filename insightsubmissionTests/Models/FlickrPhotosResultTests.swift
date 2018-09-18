//
//  FlickrPhotosResult.swift
//  insightsubmissionTests
//
//  Created by Marc O'Neill on 18/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import XCTest
@testable import insightsubmission

class FlickrPhotosResultTests: XCTestCase {

    var jsonData: Data!

    override func setUp() {
        super.setUp()

        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "text_search_response", withExtension: "json") else { return }
        jsonData = try! Data(contentsOf: url)
    }

    func testPhotosNotNilGivenJSON() {
        do {
            let flickrResponse: FlickrPhotosResult = try JSONDecoder().decode(FlickrPhotosResult.self, from: jsonData)
            XCTAssertNotNil(flickrResponse.photos, "Photos should not be nil")
        } catch(let error) {
            XCTFail("\(error)")
        }
    }

    func testNumberOfPhotosGivenJSON() {
        do {
            let flickrResponse: FlickrPhotosResult = try JSONDecoder().decode(FlickrPhotosResult.self, from: jsonData)
            XCTAssert(flickrResponse.photos?.photo.count == 3, "Incorrect number of photos")
        } catch(let error) {
            XCTFail("\(error)")
        }
    }
    
}
