//
//  SurfReportService.swift
//  BeachFinder
//
//  Created by Dai Williams on 22/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation
import RxSwift

protocol SurfReportService {
    func getSurfData(locationId: Int, startTime: Int, finishTime: Int) -> Observable<BeachSurfReport>
}