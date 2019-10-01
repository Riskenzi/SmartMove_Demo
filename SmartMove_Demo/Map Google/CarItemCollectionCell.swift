//
//  CarItemCollectionCell.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 01.10.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import UIKit

class CarItemCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var CarName: UILabel!
    
    @IBOutlet weak var CarNumber: UILabel!
    
    @IBOutlet weak var CarImage: UIImageView!
    
    
    @IBOutlet weak var CarDuration: UILabel!
    
    @IBOutlet weak var CarDistancion: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    public func configure(wthi model : CarModel){
        CarName.text = model.CarName
        CarImage.image = model.CarImage
        CarNumber.text = model.CarNumber
        CarDuration.text = model.CarDuration
        CarDistancion.text = model.CarDistancion
        
    }
    @IBAction func ButtonNavigation(_ sender: Any) {
        
        print("navigation")
    }
}

struct CarModel {
    let CarImage: UIImage
    let CarName: String
    let CarNumber : String
    let CarDuration : String
    let CarDistancion : String
}
