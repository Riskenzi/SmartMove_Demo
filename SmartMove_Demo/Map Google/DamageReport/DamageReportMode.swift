//
//  DamageReportMode.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 15.10.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import UIKit

class DamageReportMode: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UINavigationBar.appearance().setBackgroundImage(
            UIImage(),
            for: .any,
            barMetrics: .default)

        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    @IBAction func ExitButton(_ sender: Any) {
       print("🔨:sumbin")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func subminButton(_ sender: Any) {
        print("🔨:sumbin")
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
