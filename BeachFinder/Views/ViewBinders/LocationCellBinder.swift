//
//  LocationCellBinder.swift
//  BeachFinder
//
//  Created by Dai on 19/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation
import RxSwift

protocol LocationCellBinder {
    func bindStars(viewModel: BeachLocationItemViewModel, _ starSwellView: BeachSwellStarsView) -> Disposable
    func bindWind(viewModel: BeachLocationItemViewModel, _ observer: AnyObserver<String>) -> Disposable
    func bindDate(viewModel: BeachLocationItemViewModel, _ observer: AnyObserver<String>) -> Disposable
    func bindTime(viewModel: BeachLocationItemViewModel, _ observer: AnyObserver<String>) -> Disposable
    func bindLocation(viewModel: BeachLocationItemViewModel, _ observer: AnyObserver<String>) -> Disposable
    func bindBeachDistance(viewModel: BeachLocationItemViewModel, _ observer: AnyObserver<String>) -> Disposable
    func bindSwell(viewModel: BeachLocationItemViewModel, _ observer: AnyObserver<String>) -> Disposable
}