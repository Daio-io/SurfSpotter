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
        let marker = BeachMarker(title: title, coords: coords)
        marker.map = self
    }
    
    func addPin(title: String, coords: Coordinates) {
        clear()
        camera = GMSCameraPosition.cameraWithLatitude(coords.lat,
                                                          longitude: coords.lon, zoom: 10)
        addAnotherPin(title, coords: coords)
    }
    
    // Beach Marker Class
    private class BeachMarker: GMSMarker {
        
        init(title: String, coords: Coordinates){
            super.init()
            icon = UIImage(named: "beach-marker")
            position = CLLocationCoordinate2DMake(coords.lat, coords.lon)
            self.title = title
        }
        
    }

}
