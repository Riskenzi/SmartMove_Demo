//
//  PopupViewUnlockerController.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 08.10.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import UIKit
class PopupViewUnlockerController: UIViewController {
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    var effect : UIVisualEffect!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var dismissButton: UIButton! {
        didSet {
            dismissButton.layer.cornerRadius = dismissButton.frame.height/2
        }
    }
    
   
    @IBOutlet weak var popupMainView: UIView! {
        didSet {
           // popupMainView.layer.cornerRadius = 10
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        animateIn()
    }
    
    func animateIn() {
          self.view.addSubview(popupMainView)
          popupMainView.center = self.view.center
          
          popupMainView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
          popupMainView.alpha = 0
          
          UIView.animate(withDuration: 0.4) {
              self.visualEffectView.effect = self.effect
              self.popupMainView.alpha = 1
              self.popupMainView.transform = CGAffineTransform.identity
          }
          
      }
      
      
      func animateOut () {
          UIView.animate(withDuration: 0.3, animations: {
              self.popupMainView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
              self.popupMainView.alpha = 0
              
              self.visualEffectView.effect = nil
              
          }) { (success:Bool) in
                  self.popupMainView.removeFromSuperview()
          }
      }
    
    
    // MARK: - IBActions
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
                     self.popupMainView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                     self.popupMainView.alpha = 0
                     
                     self.visualEffectView.effect = nil
                     
                 }) { (success:Bool) in
                         self.popupMainView.removeFromSuperview()
                    self.dismiss(animated: true)
                 }
        
    }

}

// MARK: - MIBlurPopupDelegate

