//
//  ViewController.swift
//  Memento
//
//  Created by Darren Leith on 03/02/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  
  let topTextFieldDelegate = TopTextFieldDelegate()
  let bottomTextFieldDelegate = BottomTextFieldDelegate()
  
  //meme text attributes
  let memeTextAttributes = [
    NSStrokeColorAttributeName: UIColor.blackColor(), //outline color
    NSForegroundColorAttributeName: UIColor.whiteColor(), //color of text during rendering
    NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName: -3.0
  ]
  
  //MARK: - lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
  
    setMemeAttributes()
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
  
  //MARK: - setMemeAttributes
  func setMemeAttributes() {
    
    //set meme default text attributes
    bottomTextField.defaultTextAttributes = memeTextAttributes
    topTextField.defaultTextAttributes = memeTextAttributes
    
    //set delegates
    self.topTextField.delegate = topTextFieldDelegate
    self.bottomTextField.delegate = bottomTextFieldDelegate
    
    //set placeholder text
    topTextField.text = "TOP"
    bottomTextField.text = "BOTTOM"
    
    //set alignment of text
    topTextField.textAlignment = .Center
    bottomTextField.textAlignment = .Center
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
  
  //get keyboard height
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
  
  //pick from photo album
  @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .PhotoLibrary
    self.presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  //pick from the camera
  @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .Camera
    self.presentViewController(imagePicker, animated: true, completion: nil)
  }
}

//MARK: - UIImagePickerControllerDelegate Extension
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      self.dismissViewControllerAnimated(true, completion: nil)
      self.imageView.image = image
    }
  }
}


