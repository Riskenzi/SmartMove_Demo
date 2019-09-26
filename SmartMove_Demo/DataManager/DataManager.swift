//
//  DataManager.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 25.09.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import Foundation

class DataManager {
    // Can't init is singleton
    private init() {}
    // MARK: Shared Instance
    static let sharedCenter = DataManager()
    //Configurations Api
    var DataPoints = NSMutableDictionary()
}



