//
//  MainViewController.swift
//  Instagram-Clone-Swift
//
//  Created by Jiapei Liang on 3/7/17.
//  Copyright © 2017 Jiapei Liang. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class ComposeViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var captionTextView: UITextView!
    
    @IBOutlet weak var captionPlaceholder: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    
    var isKeyboardHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        captionTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if isKeyboardHidden {
                self.view.frame.origin.y -= keyboardSize.height
                isKeyboardHidden = false
            }

        }
        
    }
    
    func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if !isKeyboardHidden {
                self.view.frame.origin.y += keyboardSize.height
                isKeyboardHidden = true
            }
            
        }
    }

    @IBAction func onLogoutButton(_ sender: Any) {
        
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User successfully logged out")
                
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                
                self.present(loginViewController, animated: true, completion: nil)
            }
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.characters.count != 0 {
            self.captionPlaceholder.isHidden = true
        } else {
            self.captionPlaceholder.isHidden = false
        }
        
    }
    
    
    @IBAction func onTapImage(_ sender: UITapGestureRecognizer) {
        
        print("tap image")
        
        let optionMenu = UIAlertController(title: nil, message: "Where do you want to get your photo?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action: UIAlertAction) in
            
            let vc = UIImagePickerController()
            vc.delegate = self
            
            vc.sourceType = UIImagePickerControllerSourceType.camera
            
            self.present(vc, animated: true, completion: nil)
            
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action: UIAlertAction) in
            
            let vc = UIImagePickerController()
            vc.delegate = self
            
            vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            self.present(vc, animated: true, completion: nil)
            
        }
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(photoLibraryAction)
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        postImageView.image = originalImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func onPostButton(_ sender: Any) {
        
        view.endEditing(true)
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Post.postUserImage(image: postImageView.image, withCaption: captionTextView.text) { (success: Bool, error:Error?) in
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if success {
                print("success make a post")
            } else {
                print(error?.localizedDescription)
            }
            
        }
        
    }
    
    
    
    @IBAction func onTapView(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
