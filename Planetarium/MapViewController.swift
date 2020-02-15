//
//  MapViewController.swift
//  Planetarium
//
//  Created by Irina Cercel on 15/02/2020.
//  Copyright © 2020 Irina Cercel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        checkLocationServices()
        
        let firstHospital = MKPointAnnotation()
        firstHospital.title = "Saint Spiridon County Hospital"
        firstHospital.coordinate = CLLocationCoordinate2D(latitude: 47.168541, longitude: 27.582664)
        mapView.addAnnotation(firstHospital)
        let secondHospital = MKPointAnnotation()
        secondHospital.title = "Emergency Hospital Professor Doctor Nicolae Oblu"
        secondHospital.coordinate = CLLocationCoordinate2D(latitude: 47.161085, longitude: 27.607246)
        mapView.addAnnotation(secondHospital)
    }
    
    func checkLocationServices() {
      if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.showsBackgroundLocationIndicator = true
        mapView.showsCompass = true
        mapView.showsScale = true
        checkLocationAuthorization()
        locationManager.startUpdatingLocation()
      } else {
        print("No authorization!")
      }
    }
    
    func checkLocationAuthorization() {
      switch CLLocationManager.authorizationStatus() {
      case .authorizedWhenInUse:
        mapView.showsUserLocation = true
      case .denied,.restricted: print("No authorization")
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
      case .authorizedAlways:
        locationManager.requestAlwaysAuthorization()
        mapView.showsUserLocation = true
      }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("location = \(locValue.latitude) \(locValue.longitude)")
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region =  MKCoordinateRegion(center: center, latitudinalMeters: 800, longitudinalMeters: 800)
            self.mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


