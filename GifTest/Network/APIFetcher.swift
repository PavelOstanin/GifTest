//
//  APIFetcher.swift
//  GifTest
//
//  Created by admin on 04.10.17.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit
import Alamofire

class APIFetcher: NSObject {
    
    let baseUrl: String = "http://api.giphy.com/v1/gifs/"
    
    let apiKey: String = "nGbG6Y6i2iRFCjXLJyiYccqPeUq927fw"
    
    let kActionSearch = "search"
    
    let kApiKey = "api_key"
    
    var currentSearchString  : String?
    
    var currentOffset = 0
    
    var currentTotal = 0
    
    let limit = 20
    
    static let sharedInstance: APIFetcher = APIFetcher()
    
    func getGifList(searchString: String?, completion: @escaping (SearchResponse) -> ()) -> Bool {
        if let searchString = searchString {
            if self.currentSearchString != searchString {
                self.currentSearchString = searchString
                self.currentTotal = 0
                self.currentOffset = 0
            } else {
                currentOffset += limit
            }
        }
        if currentOffset > currentTotal {
            return false
        }
        sendGetRequest(parameters: ["q" : searchString ?? "", "offset" : "\(self.currentOffset)"], action: kActionSearch, responseClass: SearchResponse()) { response in
            let response = response as! SearchResponse
            self.currentTotal = response.total
            completion(response)
        }
        return true
    }

    func sendGetRequest(parameters: Dictionary<String, String>, action: String, responseClass: Any, completion: @escaping (Any) -> ()){
        var params = parameters
        params[kApiKey] = apiKey
        var urlString = "\(baseUrl)\(action)?"
        var i = 0
        for (k, v) in params {
            urlString += k.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            urlString += "="
            urlString += "\(v)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            if (i != params.count - 1) {
                urlString += "&"
            }
            i += 1
        }
        print(urlString)
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseJSON { response in
            let serverResponse = responseClass as! ServerResponse
            serverResponse.complete = !response.result.isFailure
            serverResponse.errorMessage = ""
            if !serverResponse.complete{
                serverResponse.errorMessage = response.error?.localizedDescription
            }
            if let JSON = response.result.value {
                serverResponse.parseFromResponse(object: JSON)
            }
//            SerialViewConstructor.hideProgressHud()
            DispatchQueue.main.async {
                completion(serverResponse)
            }
        }
    }
    
}
