//
//  APIManagerTests.swift
//  CodingExerciseTests
//
//  Created by Sheetal on 02/09/20.
//  Copyright © 2020 Sheetal.com. All rights reserved.
//

import XCTest
@testable import CodingExercise
class APIManagerTests: XCTestCase {

    var sut : APIManager?
    override func setUpWithError() throws {
        sut = APIManager()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        sut = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_request_data(){

        //Given a Api Service
        let sut = self.sut!

        //While requesting for data
        let expect = XCTestExpectation(description: "CallBack")
        sut.requestData{ ApiResult in
            expect.fulfill()
            XCTAssertNotNil(ApiResult)
        }
        wait(for: [expect], timeout: 3.1)

    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
