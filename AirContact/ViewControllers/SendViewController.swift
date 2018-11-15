//
//  SendViewController.swift
//  AirContact
//
//  Created by MacBook on 13/11/2018.
//  Copyright © 2018 abc. All rights reserved.
//

import UIKit
import CoreData

class SendViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var cardsList: [CardTemplate] = []
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var contactsTableView: UITableView!
    
    var imageData: Data? = nil
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return cardsList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SendCell", for: indexPath) as! SendTableViewCell
        
        let cardList: CardTemplate = cardsList[indexPath.row]
        cell.nameLabel.text = cardList.name
        cell.jobTitleLabel.text = cardList.jobTitle
        cell.emailLabel.text = cardList.email
        cell.phoneLabel.text = cardList.phone
        
        //let totalCount = cardsList.count
        //let imageData: CardTemplate = cardsList[totalCount-1]
        
        if imageData != nil
        {
            let image : UIImage = UIImage(data: imageData!)!
            cell.userImageView.image = image
            cell.userImageView.layer.cornerRadius = cell.userImageView.frame.width / 2
            cell.userImageView.layer.masksToBounds = true
        }
        //cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateList()
    }
    
     func populateList()
    {
        do
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context =  appDelegate.persistentContainer.viewContext
            let request =  NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
            request.returnsObjectsAsFaults = false
            
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    let cardList = CardTemplate(name:(result.value(forKey: "name") as? String)!,jobTitle:(result.value(forKey: "jobTitle") as? String)!,email:(result.value(forKey: "email") as? String)!,phone:(result.value(forKey: "phone") as? String)!)

                    if result.value(forKey: "image") != nil
                    {
                        imageData = (result.value(forKey: "image") as? Data)!
                    }
                    cardsList.append(cardList)
                }
            }
            self.contactsTableView.reloadData()
        }
        catch
        {
            print(error)
        }
    }
}
