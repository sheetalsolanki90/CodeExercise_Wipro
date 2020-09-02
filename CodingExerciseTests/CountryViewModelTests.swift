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
        sut = CountryViewModel.init(apiService: mockApiManager)

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
        XCTAssertEqual( sut.alertMessage, error.rawValue)


    }

    func test_create_cell_view_model(){
        //Given
        let countryPropertyList = StubGenerator().stubCountries()
        mockApiManager.completeCountryList = countryPropertyList
        let expect = XCTestExpectation(description: "reload closure triggered")
        sut.reloadTableViewClosure = {() in
            expect.fulfill()
        }

        //when
        sut.requestData()
        mockApiManager.success()

        //Number of cell viewModel is equal to the number of country properties models
        XCTAssertEqual(sut.numberOfCells, countryPropertyList.count)

        //XCTAssert reload closure triggered
        wait(for: [expect], timeout: 1.0)

    }
    func test_loading_when_requesting(){
        //Given

        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        sut.updateLoadingStatus = { [weak sut] in
            loadingStatus = sut!.isLoading
            expect.fulfill()

        }
        //When Requesting
        sut.requestData()

        //Assert
        XCTAssertTrue(loadingStatus)


        //When finished requesting
        mockApiManager.success()
        XCTAssertFalse(loadingStatus)

        wait(for: [expect], timeout: 1.0)
    }

    func test_get_cell_view_model(){

        //Given a sut with fetched country properties
        goToFetchCountryPropertiesFinished()

        let indexPath = IndexPath(row: 0, section: 0)
        let testCountryProperty  = mockApiManager.completeCountryList[indexPath.row]

        //when
        let vm = sut.getCellViewModel(at: indexPath)

        //Assert
        XCTAssertEqual(vm.titleText, testCountryProperty.title)
    }
    func test_cell_view_model(){
        //Given Country properties
        let countryModel = CountryProperties(title: "Canada", description: "desc", imageHref: "http://images.findicons.com/files/icons/662/world_flag/128/flag_of_canada.png")

        //when create cell view model
        let cellViewModel = sut!.createCellViewModel(country: countryModel)

        //Assert the correctness of display information
        XCTAssertEqual(countryModel.title, cellViewModel.titleText)
        XCTAssertEqual(countryModel.imageHref, cellViewModel.imageUrl)


    }

}
//MARK: State control
extension CountryViewModelTests {
    private func goToFetchCountryPropertiesFinished() {
        mockApiManager.completeCountryList = StubGenerator().stubCountries()
        sut.requestData()
        mockApiManager.success()
    }
}
class MockApiManager: APIServiceProtocol{
    var isRequestDataCalled = false
    var completeCountryList: [CountryProperties] = [CountryProperties]()
    var responseJson = JSON()
    var completeClosure: ((ApiResult) -> Void)!
    var completeSuccessClosure:(([CountryProperties]) ->Void)!
    func requestData( completion: @escaping (ApiResult) -> Void) {
        isRequestDataCalled = true
        completeClosure = completion
    }
    func success(){
        responseJson = StubGenerator().stubJson()
        completeClosure(ApiResult.success(responseJson))
    }

    func failure(error: RequestError?){
        completeClosure(ApiResult.failure(.connectionError))

    }


}
class StubGenerator {
    func stubCountries() -> [CountryProperties] {
        var countryRows = [CountryProperties]()
        let path = Bundle.main.path(forResource: "content", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        do {
            let utf8Data = String(decoding: data, as: UTF8.self).data(using: .utf8)
            let responseJson = try JSON(data: utf8Data!)
            countryRows = responseJson["rows"].arrayValue.compactMap {return CountryProperties(data: try! $0.rawData())}
        }
        catch let parseJSONError {
            print("error on parsing request to JSON : \(parseJSONError)")
        }

        return countryRows
    }
    func stubJson()->JSON{
        var responseJson = JSON()
        let path = Bundle.main.path(forResource: "content", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        do {
            let utf8Data = String(decoding: data, as: UTF8.self).data(using: .utf8)
            responseJson = try JSON(data: utf8Data!)

        }
        catch let parseJSONError {
            print("error on parsing request to JSON : \(parseJSONError)")
        }
        return responseJson
    }
}
