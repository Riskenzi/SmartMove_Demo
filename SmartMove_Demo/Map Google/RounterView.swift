//
//  RounterView.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 04.10.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import UIKit

class RounterView: UIView {

    @IBOutlet weak var ButtonHelp: UIButton!
    
    @IBOutlet weak var AddressLabel: UILabel!
    
    @IBOutlet weak var startRounteLabel: UILabel!
    
    @IBOutlet weak var ButtonStartRounteLabel: UIButton!
    
    
    let nibName = "RounterView"
    @IBOutlet var contentView: UIView!
    
    @IBAction func StartRounteClick(_ sender: Any) {
        print("StartRounteClick")
        if DataManager.sharedCenter.CarLiveRoutingLatitude != nil{
             StartRounteButton(carPosotionlatitude: String(DataManager.sharedCenter.CarLiveRoutingLatitude!.description), carPosotionlongitude: String((DataManager.sharedCenter.CarLiveRoutingLongtitude!.description)))
        }
    }
    
    @IBAction func ButtonHelpCkick(_ sender: Any) {
         print("ButtonHelpCkick")
    }
    
    func StartRounteButton( carPosotionlatitude : String, carPosotionlongitude : String ){
        let lat = carPosotionlatitude
        let longi = carPosotionlongitude
        let url0 = "comgooglemaps://?saddr=&daddr="
        let url1 = lat + "," + longi
        let url2 = "&directionsmode=driving"
        let final = url0 + url1 + url2
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            if let urlDestination = URL.init(string:  final){
                UIApplication.shared.open(urlDestination)
                
                print("GoogleMap App is installed")
            }
           
        } else {
            // if GoogleMap App is not installed
            print("GoogleMap App is not installed")
            let url0 = "http://maps.google.com/maps/dir/?saddr=&daddr="
            let url1 = lat + "," + longi
            let url2 = "&directionsmode=driving"
            let final = url0 + url1 + url2
            if let urlDestination = URL.init(string:  final)
            {
                UIApplication.shared.open(urlDestination)
            }
        }
    }
    
}
