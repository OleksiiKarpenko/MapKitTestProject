//
//  LocationService.swift
//  TestProject7devs
//
//  Created by Alexey on 7/17/17.
//  Copyright © 2017 Alexey. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
    func locationServiceUpdatedUserLocation(coordinate: CLLocationCoordinate2D)
    func locationServiceFailedToUpdateUserLocation(error: Error)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    weak var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.first else {
            return
        }
        
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        self.delegate?.locationServiceUpdatedUserLocation(coordinate: coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.locationServiceFailedToUpdateUserLocation(error: error)
    }
}
