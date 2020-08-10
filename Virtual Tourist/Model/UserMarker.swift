//
//  UserMarker.swift
//  Virtual Tourist
//
//  Created by Jason Yu on 8/3/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import Foundation
import MapKit

class UserMarker: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        super.init()
    }
}
