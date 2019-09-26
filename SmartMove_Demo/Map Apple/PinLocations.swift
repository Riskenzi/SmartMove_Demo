//
//  PinLocations.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 25.09.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import Foundation
import MapKit
class PinLocations : NSObject,NSCoding
{

    var name: String?
    var favouriteArtist: String?
    var coordinateLatitude: Double?
    var coordinateLongitude: Double?
    var carID: String?

    init(json: NSMutableDictionary) { // Dictionary object
        self.name = (json["name"] as? String)
        self.favouriteArtist = (json["favouriteArtist"] as? String)
        self.coordinateLatitude = ((json["coordinate_latitude"] as? Double)!)
        self.coordinateLongitude = (json["coordinate_longitude"] as? Double)
        self.carID = (json["CarID"] as? String)

        
    }
    
    override init() {
        
    }

    required init?(coder aDecoder: NSCoder) {
        self.name = (aDecoder.decodeObject(forKey: "name") as? String)
        self.favouriteArtist = (aDecoder.decodeObject(forKey: "favouriteArtist") as? String)
        self.coordinateLatitude = (aDecoder.decodeObject(forKey: "coordinate_latitude") as? Double)
        self.coordinateLongitude = (aDecoder.decodeObject(forKey: "coordinate_longitude") as? Double)
        self.carID = (aDecoder.decodeObject(forKey: "CarID") as? String)
    }

    func encode(with aCoder: NSCoder) {
        //aCoder.encode(self.id, forKey: "id")
         aCoder.encode(self.name, forKey: "name")
         aCoder.encode(self.favouriteArtist, forKey: "favouriteArtist")
         aCoder.encode(self.coordinateLatitude, forKey: "coordinate_latitude")
         aCoder.encode(self.coordinateLongitude, forKey: "coordinate_longitude")
         aCoder.encode(self.carID, forKey: "CarID")
    }
}

