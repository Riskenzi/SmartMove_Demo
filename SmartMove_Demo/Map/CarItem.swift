//
//  ArtWork.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 25.09.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import Foundation
import MapKit

class CarItem: NSObject, MKAnnotation {
  let title: String?
  let locationName: String
  let discipline: String
  let coordinate: CLLocationCoordinate2D
    let carID : String
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, carID : String) {
    self.title = title
    self.locationName = locationName
    self.discipline = discipline
    self.coordinate = coordinate
    self.carID = carID
    
    super.init()
  }
  
  var subtitle: String? {
    return locationName
  }
}
