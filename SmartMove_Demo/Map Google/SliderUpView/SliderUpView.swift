//
//  SliderUpView.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 11.10.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import UIKit
import FittedSheets
class SliderUpView: UIViewController,SlideButtonDelegate {
    func buttonStatus(status: String, sender: MMSlidingButton) {
        let alertController = UIAlertController(title: "", message: "Done!", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Okay", style: .default) { (action) in
            sender.reset()
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
    @IBOutlet weak var SliderViewUnlock: MMSlidingButton!
    

        override func viewDidLoad() {
               super.viewDidLoad()
            self.sheetViewController?.handleColor = .white
            self.SliderViewUnlock.delegate = self
           }
           
           static func instantiate() -> SliderUpView {
               return UIStoryboard(name: "SliderUpView", bundle: nil).instantiateInitialViewController() as! SliderUpView
           }

    @IBAction func DamageButton(_ sender: Any) {
        
     
       let storyboard = UIStoryboard(name: "DamageReport", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "DamageReportVC") as! DamageReportVC
        
        present(secondViewController, animated: true, completion: nil)
       
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
