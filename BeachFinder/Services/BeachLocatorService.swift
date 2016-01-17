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

public typealias BeachLocatorCoordinate = Double

struct BeachLocation {
    
    let location: String
    let spotId: Int
    let country: String
    let lat: BeachLocatorCoordinate
    let lon: BeachLocatorCoordinate
}

class BeachLocatorService : NSObject {
    
    let baseUrl = "https://beach-locator.herokuapp.com/location"
    
    func getNearestBeachesForLocation(latitude: BeachLocatorCoordinate,
        longitide: BeachLocatorCoordinate, distance: Int, success: BeachLocation -> Void, failure: NSError -> Void) {
            
            let url = getRequestString(latitude, lon:longitide, dist: distance)
            
            Alamofire.request(.GET, url)
                .responseJSON { response in switch response.result {
                case .Success(let jsonData):
                    let json = JSON(jsonData)
                    if json["status"].stringValue == "success" {
                        
                        let result = json["response"][0]
                        let loc = result["location"].stringValue
                        let spotId = result["spotId"].intValue
                        let county = result["country"].stringValue
                        let lat = result["coords"]["lat"].doubleValue
                        let lon = result["coords"]["long"].doubleValue
                        
                        let beachLocation = BeachLocation(location: loc, spotId: spotId, country: county, lat: lat, lon: lon)
                        success(beachLocation)
                    } else {
                        let message = json["message"].stringValue
                        failure(NSError(domain: message, code: 1, userInfo: nil))
                    }
                    
                case .Failure(let error):
                    failure(error)
                    }
            }
            
    }
    
    private func getRequestString(lat: BeachLocatorCoordinate, lon: BeachLocatorCoordinate, dist: Int) -> String {
        return baseUrl + "?lat=\(lat)&long=\(lon)&dist=\(dist)"
    }
    
}