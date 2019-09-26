//
//  MapPin.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 25.09.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import Foundation
struct MapPinElement: Codable{
    let name: String
    let favouriteArtist: String
    let coordinate_latitude: Double
    let coordinate_longitude: Double
    let CarID: String

    enum CodingKeys: String, CodingKey {
        case name
        case favouriteArtist
        case coordinate_latitude
        case coordinate_longitude
        case CarID
    }
}

typealias MapPin = [MapPinElement]

//


