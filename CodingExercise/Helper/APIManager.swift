//
//  APIManager.swift
//  DemoApplication
//
//  Created by Sheetal on 20/07/20.
//  Copyright © 2020 Sheetal.com. All rights reserved.
//

import UIKit
import SwiftyJSON
enum ApiResult {
    case success(JSON)
    case failure(RequestError)
}
enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
enum RequestError:String, Error {
    typealias RawValue = String
    case unknownError = "UnKnown Error"
    case connectionError = "Check your Internet connection."
    case authorizationError = "Autherization error"
    case invalidRequest = "Request Failed"
    case notFound = "Data Not Found"
    case invalidResponse = "Invalid Response"
    case serverError = "Server Error"
    case serverUnavailable = "Server is not availble"
}
protocol APIServiceProtocol {
    func requestData(completion: @escaping (ApiResult)->Void)
}

class APIManager: APIServiceProtocol {
    typealias parameters = [String:Any]
    func requestData(completion: @escaping (ApiResult) -> Void) {
        var request = URLRequest(url: URL(string:Constants.BASE_URL)!)
        request.httpMethod = Constants.HTTP_METHOD_GET
        request.timeoutInterval = 30
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                completion(ApiResult.failure(.connectionError))
            }else if let data = data ,let responseCode = response as? HTTPURLResponse {
                do {
                    let utf8Data = String(decoding: data, as: UTF8.self).data(using: .utf8)
                    let responseJson = try JSON(data: utf8Data!)
                    switch responseCode.statusCode {
                    case 200:
                        completion(ApiResult.success(responseJson))
                    case 400...499:
                        completion(ApiResult.failure(.authorizationError))
                    case 500...599:
                        completion(ApiResult.failure(.serverError))
                    default:
                        completion(ApiResult.failure(.unknownError))
                        break
                    }
                }
                catch _ {
                    completion(ApiResult.failure(.unknownError))
                }
            }
        }.resume()
    }
}
