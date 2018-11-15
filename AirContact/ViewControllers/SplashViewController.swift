//
//  SplashViewController.swift
//  AirContact
//
//  Created by MacBook on 12/11/2018.
//  Copyright © 2018 abc. All rights reserved.
//

import UIKit
import CoreData

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context =  appDelegate.persistentContainer.viewContext
            let request =  NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
            request.returnsObjectsAsFaults = false
            
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                
                    AppManager.emailId  = (result.value(forKey: "emailid") as? String)!
                }
                
                self.dismiss(animated: true, completion: nil)
                let homeViewController =  self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                self.present(homeViewController, animated: true, completion: nil)
            }
            else
            {
                self.dismiss(animated: true, completion: nil)
                let loginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginViewController, animated: true, completion: nil)
            }
        }
        catch
        {
            print(error)
        }
    }
    
}
