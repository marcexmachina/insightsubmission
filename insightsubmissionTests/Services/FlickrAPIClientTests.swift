//
//  NetworkManagerTests.swift
//  insightsubmissionTests
//
//  Created by Marc O'Neill on 16/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import XCTest
@testable import insightsubmission

class NetworkSessionMock: NetworkSession {
    var data: Data?
    var error: Error?
    var response: URLResponse?

    func loadData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        completionHandler(data, response, error)
    }
}

class FlickrAPIClientTests: XCTestCase {

    var sut: FlickrAPIClient!
    var mockSession: NetworkSessionMock!

    let baseUrl = "https://\(Constants.Flickr.baseURL)\(Constants.Flickr.path)?method=\(APIMethod.search.rawValue)&format=json&api_key=\(Constants.Flickr.apiKey)&nojsoncallback=1&safe_search=1&extras=\(Constants.Flickr.Extras.asString())"
    
    override func setUp() {
        super.setUp()
        mockSession = NetworkSessionMock()
        sut = FlickrAPIClient(session: mockSession)
    }
    
    override func tearDown() {
        sut = nil
        mockSession = nil
        super.tearDown()
    }

    // MARK: - URL Creation
    
    func testTextQueryUrlString() {
        let expected = baseUrl.appending("&text=test")
        let url = sut.url(text: "test")
        XCTAssert(url.absoluteString == expected, "URL for search with text is not correct")
    }

    func testLocationQueryUrlString() {
        let expected = baseUrl.appending("&lat=123.0&lon=123.0")
        let url = sut.url(latitude: 123.0, longitude: 123.0)
        XCTAssert(url.absoluteString == expected, "URL for search with coordinates is not correct")
    }

    func testTagQueryUrlString() {
        let expected = baseUrl.appending("&tags=test")
        let url = sut.url(tag: "test")
        XCTAssert(url.absoluteString == expected, "URL for search with tag is not correct")
    }

    // MARK: - Successful Response

    func testSearchText_SuccessfulResponse() {
        let expectation = self.expectation(description: "Successful response")

        let mockResult = FlickrPhotosResult(stat: "200", photos: nil)
        let url = URL(fileURLWithPath: "test")
        mockSession.data =  try? JSONEncoder().encode(mockResult)
        mockSession.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        var isSuccess = false
        sut.getPhotos(text: "test") { result in
            switch result {
            case .success(_):
                isSuccess = true
            default:
                break
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(isSuccess, "Result not successful")
    }

    func testSearchLatitudeLongitude_SuccessfulResponse() {
        let expectation = self.expectation(description: "Successful response")

        let mockResult = FlickrPhotosResult(stat: "200", photos: nil)
        let url = URL(fileURLWithPath: "test")
        mockSession.data =  try? JSONEncoder().encode(mockResult)
        mockSession.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        var isSuccess = false
        sut.getPhotos(latitude: 0, longitude: 0) { result in
            switch result {
            case .success(_):
                isSuccess = true
            default:
                break
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(isSuccess, "Result not successful")
    }

    func testSearchTags_SuccessfulResponse() {
        let expectation = self.expectation(description: "Successful response")

        let mockResult = FlickrPhotosResult(stat: "200", photos: nil)
        let url = URL(fileURLWithPath: "test")
        mockSession.data =  try? JSONEncoder().encode(mockResult)
        mockSession.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        var isSuccess = false
        sut.getPhotos(tag: "tag") { result in
            switch result {
            case .success(_):
                isSuccess = true
            default:
                break
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(isSuccess, "Result not successful")
    }

    // MARK: - Unsuccessful Response

    func testSearchText_NoDataError() {
        let expectation = self.expectation(description: "No Data Error")

        let url = URL(fileURLWithPath: "test")
        mockSession.data =  nil
        mockSession.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        var isSuccess = false
        sut.getPhotos(text: "test") { result in
            switch result {
            case .success(_):
                isSuccess = true
            case .error(let responseError as FlickrError):
                if case FlickrError.noData = responseError {
                    isSuccess = false
                } else {
                    isSuccess = true
                }
            default:
                // Setting this to true to fail assertion in this case
                isSuccess = true
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(isSuccess == false, "Result not expected error")
    }

    func testSearchText_ServerResponseError() {
        let expectation = self.expectation(description: "Server Response Error")

        let mockResult = FlickrPhotosResult(stat: "500", photos: nil)
        let url = URL(fileURLWithPath: "test")
        mockSession.data =  try? JSONEncoder().encode(mockResult)
        mockSession.response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)

        var isSuccess = false
        sut.getPhotos(text: "test") { result in
            switch result {
            case .success(_):
                isSuccess = true
            case .error(let responseError as FlickrError):
                if case FlickrError.serverResponseError = responseError {
                    isSuccess = false
                } else {
                    // Setting this to true to fail assertion in this case
                    isSuccess = true
                }
            default:
                // Setting this to true to fail assertion in this case
                isSuccess = true
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(isSuccess == false, "Result not expected error")
    }

    func testSearchLatitudeLongitude_NoDataError() {
        let expectation = self.expectation(description: "No Data Error")

        let url = URL(fileURLWithPath: "test")
        mockSession.data =  nil
        mockSession.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        var isSuccess = false
        sut.getPhotos(latitude: 0, longitude: 0) { result in
            switch result {
            case .success(_):
                isSuccess = true
            case .error(let responseError as FlickrError):
                if case FlickrError.noData = responseError {
                    isSuccess = false
                } else {
                    isSuccess = true
                }
            default:
                // Setting this to true to fail assertion in this case
                isSuccess = true
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(isSuccess == false, "Result not expected error")
    }

    func testSearchLatitudeLongitude_ServerResponseError() {
        let expectation = self.expectation(description: "Server Response Error")

        let mockResult = FlickrPhotosResult(stat: "500", photos: nil)
        let url = URL(fileURLWithPath: "test")
        mockSession.data =  try? JSONEncoder().encode(mockResult)
        mockSession.response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)

        var isSuccess = false
        sut.getPhotos(latitude: 0, longitude: 0) { result in
            switch result {
            case .success(_):
                isSuccess = true
            case .error(let responseError as FlickrError):
                if case FlickrError.serverResponseError = responseError {
                    isSuccess = false
                } else {
                    // Setting this to true to fail assertion in this case
                    isSuccess = true
                }
            default:
                // Setting this to true to fail assertion in this case
                isSuccess = true
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(isSuccess == false, "Result not expected error")
    }

    func testSearchTag_NoDataError() {
        let expectation = self.expectation(description: "No Data Error")

        let url = URL(fileURLWithPath: "test")
        mockSession.data =  nil
        mockSession.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        var isSuccess = false
        sut.getPhotos(tag: "test") { result in
            switch result {
            case .success(_):
                isSuccess = true
            case .error(let responseError as FlickrError):
                if case FlickrError.noData = responseError {
                    isSuccess = false
                } else {
                    isSuccess = true
                }
            default:
                // Setting this to true to fail assertion in this case
                isSuccess = true
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(isSuccess == false, "Result not expected error")
    }

    func testSearchTag_ServerResponseError() {
        let expectation = self.expectation(description: "Server Response Error")

        let mockResult = FlickrPhotosResult(stat: "500", photos: nil)
        let url = URL(fileURLWithPath: "test")
        mockSession.data =  try? JSONEncoder().encode(mockResult)
        mockSession.response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)

        var isSuccess = false
        sut.getPhotos(tag: "test") { result in
            switch result {
            case .success(_):
                isSuccess = true
            case .error(let responseError as FlickrError):
                if case FlickrError.serverResponseError = responseError {
                    isSuccess = false
                } else {
                    // Setting this to true to fail assertion in this case
                    isSuccess = true
                }
            default:
                // Setting this to true to fail assertion in this case
                isSuccess = true
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(isSuccess == false, "Result not expected error")
    }
}
