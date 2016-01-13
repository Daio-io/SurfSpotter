//
//  BeachLocatorService.swift
//  BeachFinder
//
//  Created by Dai Williams on 12/01/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol BeachLocatorServiceDelegate {
    func didFindLocation(location: BeachLocation)
}

public typealias BeachLocatorCoordinate = Double

struct BeachLocation {
    var location: String
    var spotId: Int
    var country: String
    var lat: BeachLocatorCoordinate
    var lon: BeachLocatorCoordinate
}

class BeachLocatorService : NSObject {
    
    internal var delegate: BeachLocatorServiceDelegate?
    
    let baseUrl = "https://beach-locator.herokuapp.com/location"
    
    func getNearestBeachesForLocation(latitude: BeachLocatorCoordinate,
        longitide: BeachLocatorCoordinate, distance: Int) {
            
            if let del = self.delegate {
                
                let url = getRequestString(latitude, lon:longitide, dist: distance)
                
                Alamofire.request(.GET, url)
                    .responseJSON { response in switch response.result {
                    case .Success(let jsonData):
                        let json = JSON(jsonData)
                        if json["status"] == "success" {
                            
                            let result = json["response"][0]
                            let loc = result["location"].stringValue
                            let spotId = result["spotId"].intValue
                            let county = result["country"].stringValue
                            let lat = result["coords"]["lat"].doubleValue
                            let lon = result["coords"]["long"].doubleValue
                            
                            let beachLocation = BeachLocation(location: loc, spotId: spotId, country: county, lat: lat, lon: lon)
                            del.didFindLocation(beachLocation)
                        }
                        
                        
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        }
                }
                
            }
    }
    
    private func getRequestString(lat: BeachLocatorCoordinate, lon: BeachLocatorCoordinate, dist: Int) -> String {
        return baseUrl + "?lat=\(lat)&long=\(lon)&dist=\(dist)"
    }
    
}