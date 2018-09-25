//
//  NetworkManagerTests.swift
//  insightsubmissionTests
//
//  Created by Marc O'Neill on 16/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import XCTest
@testable import insightsubmission

class FlickrAPIClientTests: XCTestCase {

    var sut: NetworkManagerProtocol!
    let baseUrl = "https://\(Constants.Flickr.baseURL)\(Constants.Flickr.path)?method=\(APIMethod.search.rawValue)&format=json&api_key=\(Constants.Flickr.apiKey)&nojsoncallback=1&safe_search=1&extras=\(Constants.Flickr.Extras.asString())"
    
    override func setUp() {
        super.setUp()
        sut = FlickrAPIClient(session: URLSession.shared)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTextQueryUrlString() {
        let expected = baseUrl.appending("&text=test")
        let url = sut.url("test")
        XCTAssert(url.absoluteString == expected, "URL for search with text is not correct")
    }

    func testLocationQueryUrlString() {
        let expected = baseUrl.appending("&lat=123.0&lon=123.0")
        let url = sut.url(latitude: 123.0, longitude: 123.0)
        XCTAssert(url.absoluteString == expected, "URL for search with coordinates is not correct")
    }
    
}
