//
//  LoginViewController.swift
//  AirContact
//
//  Created by MacBook on 12/11/2018.
//  Copyright © 2018 abc. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var emailUITextField: UITextField!
    @IBOutlet weak var passwordUITextField: UITextField!
    
    @IBAction func onClickLogin(_ sender: Any) {
        
        if let email = emailUITextField.text, email.isEmpty
        {
            displayMessage(message: "Email Required")
        }
        
        if let password = passwordUITextField.text, password.isEmpty
        {
            displayMessage(message: "Password Required")
        }
        
         verifyUser()
    }
    
    func verifyUser() {
        
        do
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context =  appDelegate.persistentContainer.viewContext
            let request =  NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
            request.returnsObjectsAsFaults = false
            
            let results = try context.fetch(request)
            if results.count > 0
            {
                var isUserExist: Bool = false
                
                for result in results as! [NSManagedObject]
                {
                    if emailUITextField.text == (result.value(forKey: "emailid") as? String)! && passwordUITextField.text == (result.value(forKey: "password") as? String)!
                    {
                        isUserExist = true
                        self.dismiss(animated: true, completion: nil)
                        let homeViewController =  self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                        self.present(homeViewController, animated: true, completion: nil)
                    }
                }
                
                if !isUserExist
                {
                    displayMessage(message: "Invalid Username or Password")
                }
            }
            else
            {
                displayMessage(message: "User Not Exist")
            }
        }
        catch
        {
            print(error)
        }
    }
    
    func displayMessage(message: String)  {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    @IBAction func onClickSignup(_ sender: Any) {
        let loginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
