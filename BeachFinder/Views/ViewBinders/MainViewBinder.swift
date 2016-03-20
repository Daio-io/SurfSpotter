//
//  HomeViewBinder.swift
//  BeachFinder
//
//  Created by Dai on 20/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation
import RxSwift
import GoogleMaps

protocol MainViewBinder {
    func bindToBeachScan(viewModel: HomeViewModel) -> Disposable
    func bindToScanDistanceChange(viewModel: HomeViewModel, slider: UISlider, observer: AnyObserver<String>) -> Disposable
    func bindToCurrentCity(viewModel: HomeViewModel, observer: AnyObserver<String>) -> Disposable
    func bindToLocationFound(viewModel: HomeViewModel, observer: AnyObserver<Bool>) -> Disposable
    func bindLocationToMap(viewModel: HomeViewModel, mapView: GMSMapView) -> Disposable
    func bindLocationsFoundToMap(viewModel: HomeViewModel, mapView: GMSMapView) -> Disposable
    func bindShowingErrorForLocation(viewModel: HomeViewModel, observer: AnyObserver<Bool>) -> Disposable
}