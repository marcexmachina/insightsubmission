//
//  ImageCacheTests.swift
//  insightsubmissionTests
//
//  Created by Marc O'Neill on 23/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import XCTest
@testable import insightsubmission

class ImageCacheTests: XCTestCase {

    let imageUrlString = "http://test.com/test.png"
    var image: UIImage!

    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: ImageCacheTests.self)
        let path = bundle.path(forResource: "test", ofType: "png")!
        image = UIImage(contentsOfFile: path)!
        ImageCache.shared.cache(key: imageUrlString, imageData: UIImagePNGRepresentation(image)!)
    }

    override func tearDown() {
        ImageCache.shared.removeAllObjects()
        super.tearDown()
    }

    func testImageCachedInMemory() {
        let expectation = self.expectation(description: "Data found")
        var resultData: Data?

        // Adding this to wait for caching on backgroundqueue to finish
        sleep(2)

        ImageCache.shared.imageDataFromMemory(for: imageUrlString) { data in
            resultData = data
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(resultData, "Image not in memory")
    }

    func testImageCachedOnDisk() {
        let expectation = self.expectation(description: "Data found")
        var resultData: Data?

        // Adding this to wait for caching on background queue to finish
        // Saving on disk can be slow
        sleep(4)
        
        ImageCache.shared.imageDataFromDisk(for: imageUrlString) { data in
            resultData = data
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(resultData, "Image not on disk")
    }

}
