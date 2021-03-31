//
//  NetworkService.swift
//  IMusic
//
//  Created by Платон Конкилов on 05.04.2020.
//  Copyright © 2020 Платон Конкилов. All rights reserved.
//

import UIKit
import Alamofire

class NetworkService {
    func fetchTask(searchText: String, complition: @escaping (SearchResponse?) -> Void ) {
        let url = "https://itunes.apple.com/search"
        let parametrs = ["term":"\(searchText)","limit":"10", "media":"music"]
        
        AF.request(url, method: .get, parameters: parametrs, encoding: URLEncoding.default, headers: nil ).responseData{(dataResponse) in
            if let error = dataResponse.error {
                print("Error recived requesting data \(error.localizedDescription)")
                return
            }
            
            guard let data = dataResponse.data else {return}
            
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SearchResponse.self, from: data)
                print("objrct: \(objects)")
                complition(objects)
                
            } catch let jsonError {
                print("Failed to decode JSON",jsonError)
                complition(nil)
            }
//            let someString = String(data: data, encoding: .utf8)
//            print(someString ?? "")
        }
    }
}
