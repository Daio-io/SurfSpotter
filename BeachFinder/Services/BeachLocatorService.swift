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
import RxSwift

class BeachLocatorService: BeachLocationService {
    
    let baseUrl = "https://beach-locator.herokuapp.com/location"
    
    func getNearestBeachesForLocation(coords: (lat:Double, lon:Double),
        distance: Int) -> Observable<[BeachLocation]> {
            
            let url = self.getRequestString(coords, dist: distance)
            let request = Alamofire.request(.GET, url)
            
            return Observable.create {(observer: AnyObserver<[BeachLocation]>) -> Disposable in
                request.responseJSON {
                    response in switch response.result {
                    case .Success(let jsonData):
                        
                        let json = JSON(jsonData)
                        if json["status"] == "success" {
                            let results = json["response"].array!
                            
                            let beaches = results.map({ (result) -> BeachLocation in
                                return BeachLocation(json: result)
                            })
                            
                            observer.onNext(beaches)
                            
                            observer.onCompleted()
                            
                        } else {
                            let message = json["message"].stringValue
                            observer.onError(NSError(domain: message, code: 1, userInfo: nil))
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
    
    private func getRequestString(coords: Coordinates, dist: Int) -> String {
        return baseUrl + "?lat=\(coords.lat)&long=\(coords.lon)&dist=\(dist)"
    }
    
}