//
//  DamageReportVC.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 15.10.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import UIKit

class DamageReportVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ExitButton(_ sender: Any) {
        print("dissmis")
        self.dismiss(animated: true, completion: nil)
    }
    
    
  
    
    @IBAction func ReportDamage(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "DamageReport", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "DamageReportMode") as! DamageReportMode
            present(secondViewController, animated: true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
