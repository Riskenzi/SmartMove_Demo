//
//  NotifyCarCheck.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 16.10.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

protocol PropertyObserver : class {
    func willChangePropertyName(propertyName:String, newPropertyValue:AnyObject?)
    func didChangePropertyName(propertyName:String, oldPropertyValue:AnyObject?)
}
 
class TestChambers {
    
    weak var observer:PropertyObserver?
    
    var testChamberNumber: Int = 0 {
        willSet(newValue) {
            observer?.willChangePropertyName(propertyName: "testChamberNumber", newPropertyValue:newValue as AnyObject)
        }
        didSet {
            observer?.didChangePropertyName(propertyName: "testChamberNumber", oldPropertyValue:oldValue as AnyObject)
        }
    }
}
 
class Observer : PropertyObserver {
    func willChangePropertyName(propertyName: String, newPropertyValue: AnyObject?) {
        if newPropertyValue as? Int == 1 {
            print("⚡️Okay. Look. We both said a lot of things that you're going to regret.")
        }
    }
    
    func didChangePropertyName(propertyName: String, oldPropertyValue: AnyObject?) {
        if oldPropertyValue as? Int == 0 {
            print("🔧Sorry about the mess. I've really let the place go since you killed me.")
        }
    }
}
