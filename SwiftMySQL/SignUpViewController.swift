//
//  SignUpViewController.swift
//  SwiftMySQL
//
//  Created by John Murphy on 3/3/16.
//  Copyright © 2016 John Murphy. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userPasswordConfirmTextField: UITextField!
    @IBOutlet weak var userFirstNameTextField: UITextField!
    @IBOutlet weak var userLastNameTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func selectProfilePhotoButtonTapped(sender: AnyObject) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        
        
        //dismiss keyboard
        
        self.view.endEditing(true)
        
        let userEmail = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        let userPassConfirm = userPasswordConfirmTextField.text
        let userFirstName = userFirstNameTextField.text
        let userLastName = userLastNameTextField.text
        
        
        if (userEmail!.isEmpty || userPassword!.isEmpty || userPassConfirm!.isEmpty || userFirstName!.isEmpty || userLastName!.isEmpty) {
            
            let myAlert = UIAlertController(title: "Error", message: "All Fields Are Required", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
            
            return
        }
        
        
        if (userPassword != userPassConfirm) {
            
            
            let myAlert = UIAlertController(title: "Error", message: "Passwords Don't Match", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
            
            return
        }
        
        
        
        //send HTTP POST
        let myUrl = NSURL(string: "http://localhost/SwiftApp/scripts/registerUser.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let postString = "userEmail=\(userEmail!)&userFirstName=\(userFirstName!)&userLastName=\(userLastName!)&userPassword=\(userPassword!)"
        
        print(postString)
        //returns userEmail=bob@email.com&userFirstName=Bob&userLastName=smith&userPassword=1234
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            dispatch_async(dispatch_get_main_queue())
                {
                    
                    if error != nil {
                        self.displayMessage(error!.localizedDescription)
                        return
                    }
                    
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        
                        if let parseJSON = json {
                            
                            let userId = parseJSON["userId"] as? String
                            
                            if( userId != nil)
                            {
                                let myAlert = UIAlertController(title: "Alert", message: "Registration successful", preferredStyle: UIAlertControllerStyle.Alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){(action) in
                                    
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }
                                
                                myAlert.addAction(okAction)
                                self.presentViewController(myAlert, animated: true, completion: nil)
                            } else {
                                let errorMessage = parseJSON["message"] as? String
                                if(errorMessage != nil)
                                {
                                    self.displayMessage(errorMessage!)
                                }
                                
                            }
                        }
                    } catch{
                        print(error)
                    }
            }
        }).resume()
      
        
        
        
        //let userProfileImageData = UIImageJPEGRepresentation(profilePhotoImageView.image!, 1)
    }
    
    
    
    func displayMessage(userMessage:String) {
        
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    
    
}