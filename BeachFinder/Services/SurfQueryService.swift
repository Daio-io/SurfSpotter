//
//  SurfQueryService.swift
//  BeachFinder
//
//  Created by Dai Williams on 22/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class SurfQueryService : SurfReportService {
    
    // temp
    let apiKey = "KEY_HERE"
    
    func getSurfData(locationId: Int, startTime: Int, finishTime: Int) -> Observable<BeachSurfReport> {
    
        let baseUrl = "https://surf-query.herokuapp.com?apikey=\(apiKey)&spotid=\(locationId)&start=\(startTime)&end=\(finishTime)"
        let request = Alamofire.request(.GET, baseUrl)
        
        return Observable.create {(observer: AnyObserver<BeachSurfReport>) -> Disposable in
            request.responseJSON {
                response in switch response.result {
                case .Success(let jsonData):
                    
                    let json = JSON(jsonData)
                    if json["status"] == "success" {
                        let results = json["response"].array!
                        
                        for item in results {
                            let surfReport = BeachSurfReport(json: item)
                            observer.onNext(surfReport)
                        }
                        
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

}