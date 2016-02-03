//
//  ViewController.swift
//  Memento
//
//  Created by Darren Leith on 03/02/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  
  let topTextFieldDelegate = TopTextFieldDelegate()
  let bottomTextFieldDelegate = BottomTextFieldDelegate()
  
  //MARK: - meme text attributes
  let memeTextAttributes = [
    NSStrokeColorAttributeName: UIColor.blackColor(), //outline color
    NSForegroundColorAttributeName: UIColor.whiteColor(), //color of text during rendering
    NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName: -3.0
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()

    //set meme attributes
    bottomTextField.defaultTextAttributes = memeTextAttributes
    topTextField.defaultTextAttributes = memeTextAttributes
    
    //set delegates
    self.topTextField.delegate = topTextFieldDelegate
    self.bottomTextField.delegate = bottomTextFieldDelegate
    
    //set text
    topTextField.text = "TOP"
    bottomTextField.text = "BOTTOM"
    
    topTextField.textAlignment = .Center
    bottomTextField.textAlignment = .Center
    
  }
  
  override func viewWillAppear(animated: Bool) {
    cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)

    //keyboard notifications
    subscribeToKeyboardWillShowNotification()
    subscribeToKeyboardWillHideNotification()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeFromKeyboardWillShowNotification()
    unsubscribeFromKeyboardWillHideNotification()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: - keyboard notification methods
  func subscribeToKeyboardWillShowNotification() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
  }
  
  func subscribeToKeyboardWillHideNotification() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func keyboardWillAppear(notification: NSNotification) {
    self.view.frame.origin.y -= getKeyboardHeight(notification)
  }
  
  func keyboardWillHide(notification: NSNotification) {
    self.view.frame.origin.y += getKeyboardHeight(notification)
  }
  
  func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue //of CGRect
    return keyboardSize.CGRectValue().height
  }
  
  func unsubscribeFromKeyboardWillShowNotification() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
  }
  
  func unsubscribeFromKeyboardWillHideNotification() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }

  
  //MARK: - picking an image
  @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .PhotoLibrary
    self.presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .Camera
    self.presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      self.dismissViewControllerAnimated(true, completion: nil)
      self.image.image = image
    }
  }
  
}

