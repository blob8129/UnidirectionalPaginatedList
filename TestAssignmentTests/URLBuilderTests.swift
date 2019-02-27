//
//  URLBuilderTests.swift
//  VGLiveTests
//
//  Created by Andrey Volobuev on 11/20/17.
//  Copyright © 2017 Andrey Volobuev. All rights reserved.
//
import XCTest
@testable import TestAssignment

class URLBuilderTests: XCTestCase {

    let url = URL(string: "https://test.com")!

    func testURLBuilderWithPath() {
        let testUrl = URLBuilder(url: url).with(paths: "test").url
        XCTAssertEqual(testUrl, URL(string: "https://test.com/test")!)
    }
    
    func testURLBuilderWithPaths() {
        let testUrl = URLBuilder(url: url)
            .with(paths: "test1", "test2")
            .url
        XCTAssertEqual(testUrl, URL(string: "https://test.com/test1/test2")!)
    }
    
    func testURLBuilderWithQuery() {
        let testUrl = URLBuilder(url: url)
            .with(queries: ["date":"TestDate"])
            .url
        XCTAssertEqual(testUrl, URL(string: "https://test.com?date=TestDate")!)
    }
    
    func testURLBuilderWithQueries() {
        let testUrl = URLBuilder(url: url)
            .with(queries: ["date":"TestDate", "sport":"TestSport"])
            .url
         XCTAssertTrue(testUrl.query?.contains("sport=TestSport") == true
            && testUrl.query?.contains("date=TestDate") == true)
    }
    
    func testURLBuilderWithPathsAndQueries() {
        let testUrl = URLBuilder(url: url)
            .with(paths: "test1", "test2")
            .with(queries: ["date":"TestDate", "sport":"TestSport"])
            .url
        let result = testUrl.query?.contains("sport=TestSport") == true && testUrl.query?.contains("date=TestDate") == true
        XCTAssertTrue(result && testUrl.path == "/test1/test2")
    }
}
