//
//  BusinessProfileViewController.swift
//  AirContact
//
//  Created by MacBook on 12/11/2018.
//  Copyright © 2018 abc. All rights reserved.
//

import UIKit
import CoreData

class BusinessProfileViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {

    
    @IBOutlet weak var fullNameUITextField: UITextField!
    @IBOutlet weak var countryUITextField: UITextField!
    @IBOutlet weak var cityUITextField: UITextField!
    @IBOutlet weak var phoneUITextField: UITextField!
    @IBOutlet weak var jobTitleUITextField: UITextField!
    @IBOutlet weak var emailUITextField: UITextField!
    @IBOutlet weak var userImageView: UIButton!
    
     let picker = UIImagePickerController()
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imagePickerButton(_ sender: Any) {
        showActionSheet()
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        
        if let fullname = fullNameUITextField.text, fullname.isEmpty
        {
            displayMessage(message: "Fullname Required")
        }
        
        if let country = countryUITextField.text, country.isEmpty
        {
            displayMessage(message: "Country Required")
        }
        
        if let city = cityUITextField.text, city.isEmpty
        {
            displayMessage(message: "City Required")
        }
        
        if let phone = phoneUITextField.text, phone.isEmpty
        {
            displayMessage(message: "Phone Required")
        }
        
        if let jobTitle = jobTitleUITextField.text, jobTitle.isEmpty
        {
            displayMessage(message: "Job Title Required")
        }
        
        if let email = emailUITextField.text, email.isEmpty
        {
            displayMessage(message: "Email Required")
        }
        saveData()
    }
    
    func saveData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let businessProfile = NSEntityDescription.insertNewObject(forEntityName: "BusinessProfile", into: context)
        
        businessProfile.setValue(cityUITextField.text, forKey: "city")
        businessProfile.setValue(countryUITextField.text, forKey: "country")
        businessProfile.setValue(fullNameUITextField.text, forKey: "fullname")
        businessProfile.setValue(jobTitleUITextField.text, forKey: "jobtitle")
        businessProfile.setValue(phoneUITextField.text, forKey: "phone")
        businessProfile.setValue(emailUITextField.text, forKey: "email")
        let imageData = UIImagePNGRepresentation((userImageView.imageView?.image)!)
        print ("Image Save : \(imageData)")
        businessProfile.setValue(imageData, forKey: "image")
        
        do
        {
            try context.save()
            self.dismiss(animated: true, completion: nil)
        }
        catch
        {}
    }
    
    func displayMessage(message: String)  {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func photoLibrary()
    {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        //picker.popoverPresentationController?.barButtonItem = sender
    }
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera()
    {
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        self.userImageView.setImage(chosenImage, for: .normal) //4
        self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2
        self.userImageView.layer.masksToBounds = true
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func populateData()
    {
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
                    cityUITextField.text  = (result.value(forKey: "city") as? String)!
                    countryUITextField.text  = (result.value(forKey: "country") as? String)!
                    fullNameUITextField.text = (result.value(forKey: "fullname") as? String)!
                    jobTitleUITextField.text  = (result.value(forKey: "jobtitle") as? String)!
                    phoneUITextField.text  = (result.value(forKey: "phone") as? String)!
                    emailUITextField.text  = (result.value(forKey: "email") as? String)!
                    
                    let imageData = result.value(forKey: "image") as? Data
                    print ("Image Get : \(imageData)")
                    let image : UIImage = UIImage(data: imageData! )!
                    self.userImageView.setImage(image, for: .normal)
                    self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2
                    self.userImageView.layer.masksToBounds = true
                }
            }
        }
        catch
        {
            print(error)
        }
    }
    
 
    
}
