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
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPin(title: String, coords: Coordinates) {
        clear()
        let camera = GMSCameraPosition.cameraWithLatitude(coords.lat,
                                                          longitude: coords.lon, zoom: 10)
        self.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(coords.lat, coords.lon)
        marker.title = title
        marker.map = self
    }

}
