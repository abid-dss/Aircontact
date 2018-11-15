//
//  SignupViewController.swift
//  AirContact
//
//  Created by MacBook on 12/11/2018.
//  Copyright © 2018 abc. All rights reserved.
//

import UIKit
import CoreData

class SignupViewController: UIViewController {

    @IBOutlet weak var emailUITextField: UITextField!
    @IBOutlet weak var passwordUITextField: UITextField!
    @IBOutlet weak var confirmPasswordUITextField: UITextField!
    
    
    @IBAction func onClickSignup(_ sender: Any) {
        
        if let email = emailUITextField.text, email.isEmpty
        {
            let alert = UIAlertController(title: "Alert", message: "Email Required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
             return
        }
        
        if let password = passwordUITextField.text, password.isEmpty
        {
            let alert = UIAlertController(title: "Alert", message: "Password Required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if let confirmPassword = confirmPasswordUITextField.text, confirmPassword.isEmpty
        {
            let alert = UIAlertController(title: "Alert", message: "Confirm Password Required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if passwordUITextField.text != confirmPasswordUITextField.text
        {
            let alert = UIAlertController(title: "Alert", message: "Password Match Failed", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        saveData()
    }
    
    func saveData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Login", into: context)
        
        newUser.setValue(emailUITextField.text, forKey: "emailid")
        newUser.setValue(passwordUITextField.text, forKey: "password")
        
        do
        {
            try context.save()
            self.dismiss(animated: true, completion: nil)
        }
        catch
        {}
    }

    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
