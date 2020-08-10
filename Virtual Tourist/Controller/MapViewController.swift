//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Jason Yu on 8/2/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var identifier: String?
    var latitude: Double?
    var longitude: Double?
    var userAnnotations = [MapLocation]()
    
    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(press:)))
        longPressGestureRecognizer.minimumPressDuration = 1.5
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        
        loadUserLocation()
    }

    func loadUserLocation() {
        do {
            self.userAnnotations = try viewContext.fetch(MapLocation.fetchRequest())
            
            DispatchQueue.main.async {
                for annotations in self.userAnnotations {
                    let annotaion = MKPointAnnotation()
                    annotaion.coordinate = CLLocationCoordinate2D(latitude: annotations.latitude, longitude: annotations.longitude)
                    self.mapView.addAnnotation(annotaion)
                }
            }
            
        } catch {
            print("Error fetching item from core data \(error)")
        }
        
    }
    
    @objc func addAnnotation(press: UILongPressGestureRecognizer) {
        if press.state == .began {
            let location = press.location(in: mapView)  //getting where user touches
            let coordinates = mapView.convert(location, toCoordinateFrom: mapView)  //turning user touch into coordinates
            saveAnnotations(lat: coordinates.latitude, long: coordinates.longitude)
            
            let annotaion = MKPointAnnotation()
            annotaion.coordinate = coordinates
            mapView.addAnnotation(annotaion)
        }
    }
    
    func saveAnnotations(lat: Double, long: Double) {
        
        //Create a location object
        let newLocation = MapLocation(context: self.viewContext)
        newLocation.latitude = lat
        newLocation.longitude = long
        
        //Save the data
        do {
            try self.viewContext.save()
        } catch {
            print("Error saving item to core data \(error)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pinSegue" {
            if let photoVC = segue.destination as? PhotoViewController {
                let annotation = mapView.selectedAnnotations[0]
                photoVC.lat = annotation.coordinate.latitude
                photoVC.long = annotation.coordinate.longitude
                print(annotation.coordinate.latitude)
            }
        }
    }
    

}

extension MapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
//            annotationView.animatesWhenAdded = true
//            annotationView.titleVisibility = .adaptive
//
//
//            return annotationView
//        }
//
//        return nil
//    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("didSelect")
        //segue to collectionView
        performSegue(withIdentifier: "pinSegue", sender: self)
    }
    
}
