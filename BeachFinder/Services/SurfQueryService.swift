//
//  SurfQueryService.swift
//  BeachFinder
//
//  Created by Dai Williams on 22/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Alamofire
import RxSwift
import SwiftyJSON

class SurfQueryService : SurfReportService {
    
    private var apiKey: String
    private var baseUrl: String
    
    init(apiKey: String, baseUrl: String) {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
    }
    
    func getNextSurf(locationId: Int, startTime: Int) -> Observable<BeachSurfReport> {
    
        let url = "\(baseUrl)\(apiKey)&spotid=\(locationId)&start=\(startTime)"
        
        let request = Alamofire.request(.GET, url)
        
        return Observable.create {(observer: AnyObserver<BeachSurfReport>) -> Disposable in
            request.responseJSON {
                response in switch response.result {
                case .Success(let jsonData):
                    
                    let json = JSON(jsonData)
                    if json["status"] == "success" {
                        
                        if let item = json["response"].array where item.count > 0 {
                            let surfReport = BeachSurfReport(json: item[0])
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