//
//  NetworkingTests.swift
//  UsersPostsTests
//
//  Created by Andrey Volobuev on 8/6/18.
//  Copyright © 2018 blob8129. All rights reserved.
//
import XCTest
@testable import TestAssignment

class NetworkingTests: XCTestCase {
    
    let testUrl = URL(string: "http://google.com")!
    let testData = "Test data".data(using: .utf8)
    
    
    func testEmptyResponseReturnsUnknownError() {
        let sessionMock = SessionMock()
        let networkService = NetworkService(session: sessionMock)
        
        networkService.loadData(at: testUrl) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .error(let error):
                XCTAssertEqual(error, NetworkError.unknown)
            }
        }
    }
    
    func testDataResponseWithHttpStatus200ReturnsSuccess() {
        
        let sessionMock = SessionMock()
        let response = HTTPURLResponse(url: testUrl,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        
        sessionMock.data = "Test data".data(using: .utf8)
        sessionMock.urlResponse = response
      
        let networkService = NetworkService(session: sessionMock)
        
        networkService.loadData(at: testUrl) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, self.testData)
            case .error(_):
                XCTFail()
            }
        }
    }
    
    func testDataResponseWithHttpStatus299ReturnsSuccess() {
        
        let sessionMock = SessionMock()
        let response = HTTPURLResponse(url: testUrl,
                                       statusCode: 299,
                                       httpVersion: nil,
                                       headerFields: nil)
        
        sessionMock.data = "Test data".data(using: .utf8)
        sessionMock.urlResponse = response
        
        let networkService = NetworkService(session: sessionMock)
        
        networkService.loadData(at: testUrl) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, self.testData)
            case .error(_):
                XCTFail()
            }
        }
    }
    
    func testDataResponseWithHttpStatus199ReturnsError() {
        let sessionMock = SessionMock()
        let response = HTTPURLResponse(url: testUrl,
                                       statusCode: 199,
                                       httpVersion: nil,
                                       headerFields: nil)
        
        sessionMock.data = "Test data".data(using: .utf8)
        sessionMock.urlResponse = response
        
        let networkService = NetworkService(session: sessionMock)
        
        networkService.loadData(at: testUrl) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .error(_):
                XCTAssert(true)
            }
        }
    }
    
    func testDataResponseWithHttpStatus300ReturnsError() {
        let sessionMock = SessionMock()
        let response = HTTPURLResponse(url: testUrl,
                                       statusCode: 300,
                                       httpVersion: nil,
                                       headerFields: nil)
        
        sessionMock.data = "Test data".data(using: .utf8)
        sessionMock.urlResponse = response
        
        let networkService = NetworkService(session: sessionMock)
        
        networkService.loadData(at: testUrl) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .error(_):
                XCTAssert(true)
            }
        }
    }
}
