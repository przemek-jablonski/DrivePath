//
//  FirstViewController.swift
//  DrivePath
//
//  Created by Przemyslaw Jablonski on 14/07/2018.
//  Copyright © 2018 Przemyslaw Jablonski. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

typealias Meters = Double

class MapViewController: UIViewController, CLLocationManagerDelegate {

    private static let MAP_REGION_STRETCH_METERS: Meters = 500
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch (CLLocationManager.authorizationStatus()) {
        case .notDetermined: locationManager.requestAlwaysAuthorization()
        default: return
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeLocationServices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        disposeLocationServices()
    }
    
    private func disposeLocationServices() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    private func onLocationUpdated(location: CLLocation) {
        let location = CLLocationCoordinate2D()
        let viewRegion = MKCoordinateRegionMakeWithDistance(
            location,
            MapViewController.MAP_REGION_STRETCH_METERS,
            MapViewController.MAP_REGION_STRETCH_METERS
        )
        mapView.setRegion(mapView.regionThatFits(viewRegion), animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager didFailWithError \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager didUpdateLocations \(locations)")
        if (locations.last != nil) {
            onLocationUpdated(location: locations.last!)
        }
    }


}

