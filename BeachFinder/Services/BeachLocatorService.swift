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

class BeachLocatorService: NSObject {

    let baseUrl = "https://beach-locator.herokuapp.com/location"

    func getNearestBeachesForLocation(coords: (lat:Double, lon:Double),
                                      distance: Int,
                                      success: Array<BeachLocation> -> Void,
                                      failure: NSError -> Void) {

        let url = getRequestString(coords, dist: distance)

        Alamofire.request(.GET, url)
        .responseJSON {
            response in switch response.result {
            case .Success(let jsonData):

                let json = JSON(jsonData)
                if json["status"] == "success" {

                    let results = json["response"].array!

                    let beaches = self.buildResults(results)

                    success(beaches)

                } else {
                    let message = json["message"].stringValue
                    failure(NSError(domain: message, code: 1, userInfo: nil))
                }

            case .Failure(let error):
                failure(error)
            }
        }

    }

    private func buildResults(results: [JSON]) -> [BeachLocation] {
        var beaches: [BeachLocation] = []

        for item in results {

            let loc = item["location"].stringValue
            let spotId = item["spotId"].intValue
            let county = item["country"].stringValue
            let lat = item["coords"]["lat"].doubleValue
            let lon = item["coords"]["long"].doubleValue

            let beachLocation = BeachLocation(location: loc, spotId: spotId, country: county, coords: Coordinates(lat, lon))
            beaches.append(beachLocation)
        }

        return beaches;
    }

    private func getRequestString(coords: Coordinates,
                                  dist: Int) -> String {

        return baseUrl + "?lat=\(coords.lat)&long=\(coords.lon)&dist=\(dist)"
    }

}