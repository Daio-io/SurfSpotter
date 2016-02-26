//
//  BeachLocationService.swift
//  BeachFinder
//
//  Created by Dai Williams on 24/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation

import RxSwift

protocol BeachLocationService {
    func getNearestBeachesForLocation(coords: Coordinates, distance: Int) -> Observable<[BeachLocation]>
}