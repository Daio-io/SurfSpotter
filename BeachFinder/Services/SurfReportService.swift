//
//  SurfReportService.swift
//  BeachFinder
//
//  Created by Dai Williams on 22/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import RxSwift

protocol SurfReportService {
    func getNextSurf(locationId: Int, startTime: Int) -> Observable<BeachSurfReport>
}