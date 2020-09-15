//
//  CountryViewModel.swift
//  DemoApplication
//
//  Created by Sheetal on 20/07/20.
//  Copyright © 2020 Sheetal.com. All rights reserved.
//

import UIKit
class CountryViewModel: NSObject {
    let apiService: APIServiceProtocol
    private var countries:[CountryProperties] = [CountryProperties]()
    private var cellViewModels: [CountryCellViewModel] = [CountryCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    var isLoading: Bool = false{
        didSet{
            self.updateLoadingStatus?()
        }
    }
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    var countryTitle : String?{
        didSet{
            self.updateCountryTitle?()
        }
    }
    var numberOfCells: Int{
        return cellViewModels.count
    }
    var reloadTableViewClosure:(()->())?
    var updateLoadingStatus: (()->())?
    var updateCountryTitle: (()->())?
    var showAlertClosure: (()->())?
    
    init(apiService: APIServiceProtocol = APIManager()){
        self.apiService = apiService
    }
    public func requestData(){
        self.isLoading = true
        apiService.requestData(completion: {[weak self] (result) in
            self?.isLoading = false
            switch result {
            case .success(let returnJson) :
                self?.countryTitle = (returnJson["title"].stringValue)
                let countryRows = returnJson["rows"].arrayValue.compactMap {return CountryProperties(data: try! $0.rawData())}
                
                //                self?.countries = countryRows
                self?.countries = countryRows.filter { $0.title != nil }
                
                self?.processFetchedData(countries: self!.countries)
            case .failure(let failure) :
                switch failure {
                case .connectionError:
                    self?.alertMessage = Constants.ErrorConstants.NETWORK_ERROR
                    
                case .authorizationError:
                    self?.alertMessage = Constants.ErrorConstants.AUTHENTICATION_ERROR
                    
                default:
                    self?.alertMessage = Constants.ErrorConstants.REQUEST_FAILED
                }
            }
        })
        
    }
    func getCellViewModel(at indexPath: IndexPath)-> CountryCellViewModel{
        return cellViewModels[indexPath.row]
    }
    func createCellViewModel(country: CountryProperties) -> CountryCellViewModel {
        
        return CountryCellViewModel( titleText: country.title ?? "",
                                     descText: country.description ?? "",
                                     imageUrl: country.imageHref ?? "")
    }
    private func processFetchedData( countries: [CountryProperties] ) {
        self.countries = countries // Cache
        var vms = [CountryCellViewModel]()
        for countryObj in countries {
            vms.append( createCellViewModel(country: countryObj) )
        }
        self.cellViewModels = vms
    }
}
struct CountryCellViewModel {
    let titleText: String
    let descText: String
    let imageUrl: String
}
