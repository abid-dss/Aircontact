//
//  ShareViewController.swift
//  AirContact
//
//  Created by MacBook on 12/11/2018.
//  Copyright © 2018 abc. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class ShareViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, shareCellDelegate {

    @IBOutlet weak var userTableView: UITableView!
    var connectedDevices: [String] = []
    var colorService:ConnectionService? = nil
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return connectedDevices.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        cell.userNameLabel.text = connectedDevices[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppManager.onClickedIndex = indexPath.row
        let loginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "SendViewController") as! SendViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    func shareButton(_ sender: UIButton) {
       print("Share")
        
        let card = getCard()
        
        if card.isEmpty
        {
            let alert = UIAlertController(title: "Alert", message: "Create Business Profile First", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else
        {
            colorService?.send(colorName: card)
        }
    }
    
    func getCard() -> String
    {
        var name: String = ""
        var email: String = ""
        var phone: String = ""
        var jobTitle: String = ""
        var imageData: Data = Data()
        
        do
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context =  appDelegate.persistentContainer.viewContext
            let request =  NSFetchRequest<NSFetchRequestResult>(entityName: "BusinessProfile")
            request.returnsObjectsAsFaults = false
            
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    name = (result.value(forKey: "fullname") as? String)!
                    jobTitle  = (result.value(forKey: "jobtitle") as? String)!
                    phone  = (result.value(forKey: "phone") as? String)!
                    email  = (result.value(forKey: "email") as? String)!
                    imageData = (result.value(forKey: "image") as? Data)!
                }
            }
            else{
                return ""
            }
        }
        catch
        {
            print(error)
        }
        
        let image : UIImage = UIImage(data: imageData)!
        let nsData:NSData = UIImagePNGRepresentation(image)! as NSData
        let base64String = nsData.base64EncodedString(options: .lineLength64Characters);
        
        let cardJson = ""+email+" , "+name+" , "+jobTitle+" , "+phone+" , 100 , \(base64String)" //imageData
        
        return cardJson
    }
    
    func updateList()
    {
        self.userTableView.reloadData()
    }
    
    func saveCard(cardString: String)
    {
        let delimiter = ","
        var card = cardString.components(separatedBy: delimiter)
        print (card[0])
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let businessProfile = NSEntityDescription.insertNewObject(forEntityName: "Cards", into: context)
            
        businessProfile.setValue(card[3], forKey: "phone")
        businessProfile.setValue(card[1], forKey: "name")
        businessProfile.setValue(card[2], forKey: "jobTitle")
        businessProfile.setValue(card[0], forKey: "email")
        print(card[5])
        
        let dataDecoded : Data = Data(base64Encoded: card[5] , options: .ignoreUnknownCharacters)!
        businessProfile.setValue(dataDecoded, forKey: "image")
            do
            {
                try context.save()
            }
            catch let error as NSError {
                print("Error: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppManager.personalProfile = getProfile()
        if (AppManager.personalProfile.isEmpty)
        {
            AppManager.personalProfile = UIDevice.current.name
        }
        colorService = ConnectionService()
        colorService?.delegate = self
    }
    
    
    func getProfile() -> String
    {
        var name: String = ""
        //var email: String = ""
        //var phone: String = ""
        //var jobTitle: String = ""
        //var imageData: Data = Data()
        
        do
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context =  appDelegate.persistentContainer.viewContext
            let request =  NSFetchRequest<NSFetchRequestResult>(entityName: "PersonalProfile")
            request.returnsObjectsAsFaults = false
            
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    name = (result.value(forKey: "fullname") as? String)!
                    // jobTitle  = (result.value(forKey: "jobtitle") as? String)!
                    // phone  = (result.value(forKey: "phone") as? String)!
                    // email  = (result.value(forKey: "email") as? String)!
                    // imageData = (result.value(forKey: "image") as? Data)!
                }
            }
            else{
                return ""
            }
        }
        catch
        {
            print(error)
        }
        
        // let image : UIImage = UIImage(data: imageData)!
        // let nsData:NSData = UIImagePNGRepresentation(image)! as NSData
        // let base64String = nsData.base64EncodedString(options: .lineLength64Characters);
        
        //let cardJson = ""+email+" , "+name+" , "+jobTitle+" , "+phone+" , 100 , \(base64String)" //imageData
        let cardJson = name
        return cardJson
    }
}

extension ShareViewController : ConnectionServiceDelegate {
    
    func connectedDevicesChanged(manager: ConnectionService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
           // self.connectionsLabel.text = "Connections: \(connectedDevices)"
            print("Connections: \(connectedDevices)")
            self.connectedDevices = []
            self.connectedDevices = connectedDevices
            self.updateList()
        }
    }
    
    func colorChanged(manager: ConnectionService, colorString: String) {
        OperationQueue.main.addOperation {
              print("Message: \(colorString)")
            self.saveCard(cardString: colorString)
        }
    }
}
