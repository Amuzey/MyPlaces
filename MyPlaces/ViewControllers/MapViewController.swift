//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Алексей on 01.09.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var mapView: MKMapView!
    
    // MARK: - Public properties
    var place: Place!
    let annotationIdentifier = "annotationIdentifier"
    
    // MARK: - Lyfe Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupPlacemark()
    }
    
    
    
    // MARK: - IBActions
    @IBAction func cancelAction() {
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    private func setupPlacemark() {
        
        guard let location = place.location else { return }
        let geokoder = CLGeocoder()
        geokoder.geocodeAddressString(location) { placemarks, error in
            if let error = error {
                print(error)
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
            
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
            
        }
    }
}

// MARK: - MKMap View Delegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        if let imageData = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        
        return annotationView
        
    }
}
