//
//  PhotoViewController.swift
//  Virtual Tourist
//
//  Created by Jason Yu on 8/4/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import UIKit
import MapKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var picturesOfPlaces =  [String]()//[UIImage]()
    
    var lat: Double?
    var long: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "PictureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PictureCollectionViewCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        showCurrentPin()
        loadImages()
    }
    
    func showCurrentPin() {
        guard let lat = lat, let long = long else { return }
        
        let currentPin = CLLocation(latitude: lat, longitude: long)
        let regionRadius: CLLocationDistance = 200000.0
        let region = MKCoordinateRegion(center: currentPin.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        
        //add annotation
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapView.addAnnotation(pin)
    }
    
    func loadImages() {
        guard let lat = lat, let long = long else { return }
        FlickerAPI.shared.getPicturesRequest(lat: lat, long: long) { result in
            switch result {
            case .success(let pics):
                for i in pics.photos.photo {
                    let pictureUrl = Picture(url: i.url)
                    print("SUCCESS FETCHING IMAGES \(pictureUrl)")
                    self.picturesOfPlaces.append(i.url)
                    
//                    if let data = try? Data(contentsOf: URL(string: i.url)!) {
//                        let image: UIImage = UIImage(data: data)!
//                        //append to array?
//                        self.picturesOfPlaces.append(image)
//                    }
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case .failure(let response):
                DispatchQueue.main.async {
                    print("NOO:: \(response)")
                    let alert = UIAlertController(title: "Error fetching Images", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }

}

extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionViewCell.reuseID, for: indexPath) as! PictureCollectionViewCell
//        cell.imageView.image = picturesOfPlaces[indexPath.row]
//        if let data = try?
        cell.imageView.image = picturesOfPlaces[indexPath.row].toImage()
        return cell
    }
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
