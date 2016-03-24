//
//  BeachFinderMap.swift
//  BeachFinder
//
//  Created by Dai on 23/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit
import GoogleMaps

class BeachFinderMap: GMSMapView {

    override init(frame: CGRect){
        super.init(frame: frame)
        settings.consumesGesturesInView = false
        settings.zoomGestures = false
        settings.scrollGestures = false
        alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addAnotherPin(title: String, coords: Coordinates) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(coords.lat, coords.lon)
        marker.title = title
        marker.map = self
    }
    
    func addPin(title: String, coords: Coordinates) {
        clear()
        camera = GMSCameraPosition.cameraWithLatitude(coords.lat,
                                                          longitude: coords.lon, zoom: 10)
        addAnotherPin(title, coords: coords)
    }

}
