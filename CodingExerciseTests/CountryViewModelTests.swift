//
//  CountryViewModelTests.swift
//  CodingExerciseTests
//
//  Created by Sheetal on 02/09/20.
//  Copyright © 2020 Sheetal.com. All rights reserved.
//

import XCTest
@testable import CodingExercise
@testable import SwiftyJSON
class CountryViewModelTests: XCTestCase {
    var sut : CountryViewModel!
    var mockApiManager: MockApiManager!
    override func setUpWithError() throws {
        mockApiManager = MockApiManager()
        sut = CountryViewModel(apiService: mockApiManager)

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        sut = nil
        mockApiManager = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_requested_data(){
        //Given
        mockApiManager.completeCountryList = [CountryProperties]()

        //When
        sut.requestData()

        //Assert
        XCTAssert(mockApiManager!.isRequestDataCalled)
    }

    func test_request_data_fail(){
        //Given a failed request with a certain failure
        let error = RequestError.connectionError

        //When
        sut.requestData()

        mockApiManager.failure(error: error)

        //sut should display predefined error messsage
        XCTAssertEqual( sut.alertMessage, error.localizedDescription )


    }

    func test_create_cell_view_model(){
        
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
class MockApiManager: APIManagerProtocol {

    var isRequestDataCalled = false
    
    var completeCountryList: [CountryProperties] = [CountryProperties]()
    var completeClosure: ((ApiResult) -> Void)!
    func requestData(url: String, completion: @escaping (ApiResult) -> Void) {
        isRequestDataCalled = true
        completeClosure = completion
    }
    func success(){
       do {
            let utf8Data = String(decoding: Data(), as: UTF8.self).data(using: .utf8)
            let responseJson = try JSON(data: utf8Data!)
                completeClosure(ApiResult.success(responseJson))
        }
        catch let parseJSONError {
            completeClosure(ApiResult.failure(.unknownError))
            print("error on parsing request to JSON : \(parseJSONError)")
        }
    }

    func failure(error: RequestError?){
        completeClosure(ApiResult.failure(.connectionError))

    }


}
