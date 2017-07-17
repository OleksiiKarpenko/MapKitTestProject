//
//  MapViewController.swift
//  TestProject7devs
//
//  Created by Alexey on 7/11/17.
//  Copyright © 2017 Alexey. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, LocationServiceDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var destinationCoordinate: CLLocationCoordinate2D!
    var userCoordinate: CLLocationCoordinate2D?
    
    let locationService = LocationService()
    
    @IBAction func mapTypeSelected(_ sender: UISegmentedControl) {
        
        switch (sender.selectedSegmentIndex) {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationService.delegate = self
    }
    
    func drawRoute(sourceLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D)
    {
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Times Square"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire State Building"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    self.showErrorAlert(error: error)
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            self.mapView.setVisibleMapRect(rect, edgePadding: insets, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    // MARK: LocationServiceDelegate
    
    func locationServiceUpdatedUserLocation(coordinate: CLLocationCoordinate2D) {
        
        if self.userCoordinate != nil {
            return 
        }
        
        self.userCoordinate = coordinate
        self.drawRoute(sourceLocation: coordinate, destinationLocation: self.destinationCoordinate)
    }
    
    func locationServiceFailedToUpdateUserLocation(error: Error) {
        showErrorAlert(error: error)
    }
    
    // MARK: Private
    
    func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
            
        self.present(alert, animated: true, completion: nil)
    }
}
