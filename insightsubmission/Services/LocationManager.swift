//
//  LocationManager.swift
//  insightsubmission
//
//  Created by Marc O'Neill on 23/09/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation
import CoreLocation

/// LocationManager singleton
final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    private var locationManager: CLLocationManager
    var currentLocation: CLLocation?

    private override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.0
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    // Mark: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        NotificationCenter.default.post(name: .locationDidUpdate, object: currentLocation)
    }


}
