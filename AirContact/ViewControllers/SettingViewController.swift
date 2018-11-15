//
//  SettingViewController.swift
//  AirContact
//
//  Created by MacBook on 12/11/2018.
//  Copyright © 2018 abc. All rights reserved.
//

import UIKit


class SettingViewController: UIViewController {

    @IBAction func onClickPersonalProfile(_ sender: Any) {
        let loginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "PersonalProfileViewController") as! PersonalProfileViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickBusinessProfile(_ sender: Any) {
        let loginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileViewController") as! BusinessProfileViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
