//
//  SliderUpView.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 11.10.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import UIKit
import FittedSheets
class SliderUpView: UIViewController {

        
        override func viewDidLoad() {
               super.viewDidLoad()
            self.sheetViewController?.handleColor = .white
           // self.sheetViewController?.overlayColor = .white
//               self.sheetViewController?.overlayColor = UIColor(red: 0.933, green: 0.314, blue: 0.349, alpha: 0.3)
           }
           
           static func instantiate() -> SliderUpView {
               return UIStoryboard(name: "SliderUpView", bundle: nil).instantiateInitialViewController() as! SliderUpView
           }

        // Do any additional setup after loading the view.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
