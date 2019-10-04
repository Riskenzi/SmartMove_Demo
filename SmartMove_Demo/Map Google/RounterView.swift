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
    }
    
    @IBAction func ButtonHelpCkick(_ sender: Any) {
         print("ButtonHelpCkick")
    }
    
    
//    override init(frame: CGRect) {
//        super.init(frame : frame)
//        commonInit()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//    
//    private func commonInit(){
//        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
//        addSubview(contentView)
//        contentView.frame = self.bounds
//        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
