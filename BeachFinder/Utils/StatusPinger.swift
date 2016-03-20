//
//  StatusPinger.swift
//  BeachFinder
//
//  Created by Dai on 16/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class StatusPinger {
    
    static func ping(endpoint: String) -> Observable<Int> {
        
        return Observable.create({ (observer: AnyObserver<Int>) -> Disposable in
            
            let request = Alamofire.request(.GET, endpoint)
            
            request.responseJSON { response in
                
                if let statusCode = response.response?.statusCode {
                    observer.onNext(statusCode)
                } else {
                    observer.onError(NSError(domain: "Endpoint did not respond", code: 1, userInfo: nil))
                }
                observer.onCompleted();
            }
            
            return AnonymousDisposable {
                request.cancel()
            }
        })
    }
}