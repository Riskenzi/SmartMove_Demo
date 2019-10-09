//
//  ViewController.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 25.09.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func test(_ sender: Any) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PopupViewUnlockerController") as! PopupViewUnlockerController
//        newViewController.modalPresentationStyle = .fullScreen
//         self.navigationController?.pushViewController(newViewController, animated: true)
        
        let secondViewController:GoogleMap = GoogleMap()
        self.show(secondViewController, sender: nil)
       // self.present(secondViewController, animated: true, completion: nil)
    }
    

}

