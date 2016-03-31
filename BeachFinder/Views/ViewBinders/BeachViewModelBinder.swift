//
//  BeachViewModelBinder.swift
//  BeachFinder
//
//  Created by Dai on 19/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import RxSwift

class BeachViewModelBinder: LocationCellBinder {
    
    func bindStars(viewModel: BeachLocationItemViewModel, _ starSwellView: BeachSwellStarsView) -> Disposable {
        return Observable.combineLatest(viewModel.solidStar.asObservable(), viewModel.fadedStar.asObservable()) {
            return ($0, $1)
            }.subscribeNext({(solid, faded) -> Void in
                starSwellView.addSolidStars(solid, fadedStars:faded)
            })
    }
    
    func bindWind(viewModel: BeachLocationItemViewModel, _ observer: AnyObserver<String>) -> Disposable {
        return viewModel.wind.asObservable()
            .map { (wind) -> String in
                return "\(wind)mph"
            }.bindTo(observer)
    }
    
    func bindDate(viewModel: BeachLocationItemViewModel, _ observer: AnyObserver<String>) -> Disposable {
        return viewModel.date.asObservable()
            .bindTo(observer)
    }
    
    func bindTime(viewModel: BeachLocationItemViewModel, _ observer: AnyObserver<String>) -> Disposable {
        return viewModel.time.asObservable()
            .bindTo(observer)
    }
    
    func bindLocation(viewModel: BeachLocationItemViewModel, _ observer: AnyObserver<String>) -> Disposable {
        return viewModel.location.asObservable()
            .bindTo(observer)
    }
    
    func bindBeachDistance(viewModel: BeachLocationItemViewModel, _ observer: AnyObserver<String>) -> Disposable {
        return viewModel.distanceToBeach.asObservable()
            .map({ (distance) -> String in
                let miles = DistanceConverter.metersToMiles(Float(distance))
                return String(format: "%.1f miles away", miles)
            })
            .bindTo(observer)
    }
    
    func bindSwell(viewModel: BeachLocationItemViewModel, _ observer: AnyObserver<String>) -> Disposable {
        
        let swellText = Observable.combineLatest(viewModel.minSwell.asObservable(),
                                                 viewModel.maxSwell.asObservable()) { min, max -> String in
                                                    if min == 0 && max == 0 {
                                                        return "flat"
                                                    }
                                                    return String("\(min)-\(max)ft")
        }
        
        return swellText.asObservable()
            .bindTo(observer)
        
    }
    
}


