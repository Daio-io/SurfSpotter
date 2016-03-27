//
//  MyBeachesService.swift
//  Surf Finder
//
//  Created by Dai on 27/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation

class MyBeachesService {
    
    private var userDefaults: NSUserDefaults
    private let BeachesKey = "beaches"
    
    init(userDefaults: NSUserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func saveBeach(location: BeachLocation) {
        
        let data =  ["location": location.location, "lat": location.coords.lat, "lon": location.coords.lon, "id": location.spotId, "country": location.country]
        
        if var beaches = userDefaults.arrayForKey(BeachesKey) {
            beaches.append(data)
            userDefaults.setObject(beaches, forKey: BeachesKey)
        } else {
            let beaches = [data]
            userDefaults.setObject(beaches, forKey: BeachesKey)
        }
    }
    
    func getBeaches() -> [BeachLocation]? {
        
        if let beaches = userDefaults.arrayForKey(BeachesKey) {
            return beaches.map({ (beach) -> BeachLocation in
                let location = beach["location"] as! String
                let spotId = beach["id"] as! Int
                let country = beach["country"] as! String
                let lat = beach["lat"] as! Double
                let lon = beach["lon"] as! Double
                return BeachLocation(location: location, spotId: spotId, country: country, lat: lat, lon: lon)
            })
            
        }
        return nil
    }
    
    
}