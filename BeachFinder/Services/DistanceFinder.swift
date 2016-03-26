//
//  DistanceFinder.swift
//  Surf Finder
//
//  Created by Dai on 26/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class DistanceFinder {
    
    func distanceToLocation(coords: Coordinates, from: Coordinates) -> Observable<Double> {
        
        let url = buildDistanceUrl(coords, from: from)
        
        let request = Alamofire.request(.GET, url)
        
        return Observable.create { (observer: AnyObserver<Double>) -> Disposable in
            
            request.responseJSON {
                response in switch response.result {
                case .Success(let jsonData):
                    
                    let json = JSON(jsonData)
                    if json["status"] == "OK" {
                        let results = json["rows"].arrayValue.first
                        let elements = results!["elements"].arrayValue.first
                        let distance = elements!["distance"]["value"].doubleValue
                        
                        observer.onNext(distance)
                        
                        observer.onCompleted()
                        
                    } else {
                        observer.onError(NSError(domain: "message", code: 1, userInfo: nil))
                    }
                case .Failure(let error):
                    
                    observer.onError(error)
                }
            }
            
            return AnonymousDisposable {
                request.cancel()
            }
            
        }
    }
    
    private func buildDistanceUrl(coords: Coordinates, from: Coordinates) -> String {
        return  Config.GoogleMapsDistanceBaseUrl + "\(from.lat),%20\(from.lon)&destinations=\(coords.lat),%20\(coords.lon)&key=\(Config.GoogleMapsApiKey)"
        
    }
    
}