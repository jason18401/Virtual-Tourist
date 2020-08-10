//
//  FlickerAPI.swift
//  Virtual Tourist
//
//  Created by Jason Yu on 8/4/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import UIKit

struct FlickerAPI {
    static let shared = FlickerAPI()
    static let apiKey = ""
    
    enum Endpoints {
        static let base = "https://api.flickr.com/services/rest?method=flickr.photos.search"
        static let apiKeyParam = "&api_key=\(apiKey)"
        
        case locationEndpoint
        
        var stringValue: String {
            switch self {
            case .locationEndpoint:
                return Endpoints.base + Endpoints.apiKeyParam + "&extras=url_n&format=json&safe_search=1&per_page=10&page=1&nojsoncallback=1"
        //lat=28.388333&lon=-80.60&format=json&nojsoncallback=1
            }
        }
            
        var raw: String {
            return self.stringValue
        }
    }
    
    func getPicturesRequest(lat: Double, long: Double, completionHandler: @escaping (Result<FlickerResponse, Error>) -> Void) {
        let url = Endpoints.locationEndpoint.stringValue + "&lat=\(lat)" + "&lon=\(long)" + "&format=json"
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else { completionHandler(.failure(error!)); return }
            let decoder = JSONDecoder()
            do {
                let flickerResponse = try decoder.decode(FlickerResponse.self, from: data)
                print("RES: \(String(describing: flickerResponse))")
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completionHandler(.success(flickerResponse))
                    }
                }
            }
            catch {
                print("Error Paring usersRes: \(error)")
                completionHandler(.failure(error))
            }

        }
        task.resume()
        
    }
    
}
