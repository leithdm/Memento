//
//  ViewController.swift
//  Memento
//
//  Created by Darren Leith on 03/02/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
  
  enum Notifications {
    static let keyboardWillShow = "UIKeyboardWillShowNotification"
    static let keyboardWillHide = "UIKeyboardWillHideNotification"
  }
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var toolBar: UIToolbar!
  
  //optional for currently edited textField
  var activeField: UITextField?
  var memedImage: UIImage?
  
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
    
    //assign view as delegate
    self.topTextField.delegate = self
    self.bottomTextField.delegate = self
    
    //share icon
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareMeme")
    //cancel icon
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelMeme")
    
  }
  
  override func viewWillAppear(animated: Bool) {
    cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    
    //keyboard notifications
    subscribeToKeyboardWillShowNotification()
    subscribeToKeyboardWillHideNotification()
    
    setBackgroundColor()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeFromKeyboardWillShowNotification()
    unsubscribeFromKeyboardWillHideNotification()
  }
  
  //MARK: - setMemeAttributes
  func setMemeAttributes() {
    
    //set meme default text attributes
    bottomTextField.defaultTextAttributes = memeTextAttributes
    topTextField.defaultTextAttributes = memeTextAttributes
    
    //set placeholder text
    topTextField.text = "TOP"
    bottomTextField.text = "BOTTOM"
    
    //set alignment of text
    topTextField.textAlignment = .Center
    bottomTextField.textAlignment = .Center
  }
  
  func setBackgroundColor() {
    let color = randomColor(hue: Hue.Random, luminosity: Luminosity.Light)
    view.backgroundColor = color
  }
  
  //MARK: - keyboard notifications
  
  func subscribeToKeyboardWillShowNotification() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: Notifications.keyboardWillShow, object: nil)
  }
  
  func subscribeToKeyboardWillHideNotification() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: Notifications.keyboardWillHide, object: nil)
  }
  
  func keyboardWillAppear(notification: NSNotification) {
    if let active = activeField {
      if active == bottomTextField {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
      }
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if let active = activeField {
      if active == bottomTextField {
        self.view.frame.origin.y += getKeyboardHeight(notification)
      }
    }
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
    imagePicker.allowsEditing = true
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
  
  //MARK: - generating Meme
  
  func generateMeme() -> UIImage {
    
    let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
    textStyle.alignment = NSTextAlignment.Center

    //different textSytyle and font-size compared to memeTextOneAttributes used previously
    let memeTextTwoAttributes = [
      NSStrokeColorAttributeName: UIColor.blackColor(), //outline color
      NSForegroundColorAttributeName: UIColor.whiteColor(), //color of text during rendering
      NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 60)!,
      NSStrokeWidthAttributeName: -3.0,
      NSParagraphStyleAttributeName: textStyle
    ]
    
    //setup image context using the passed image
    let imageToManipulate = imageView.image!
    UIGraphicsBeginImageContext(imageToManipulate.size)
    
    //put the image in a rectangle as large as the original image
    imageToManipulate.drawInRect(CGRectMake(0, 0, imageToManipulate.size.width, imageToManipulate.size.height))

    //create the points in the space that is as big as the image
    let rectOne: CGRect = CGRectMake(0, 50, imageToManipulate.size.width, imageToManipulate.size.height)
    let rectTwo: CGRect = CGRectMake(0, imageToManipulate.size.height - 150, imageToManipulate.size.width, imageToManipulate.size.height)
  
    //draw the text into the image
    (topTextField.text! as NSString).drawInRect(rectOne, withAttributes: memeTextTwoAttributes)
    (bottomTextField.text! as NSString).drawInRect(rectTwo, withAttributes: memeTextTwoAttributes)
    
    let mImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    memedImage = mImage
    return mImage
  }
  
  //save meme
  func saveMeme() {
    let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMeme())
    
    (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
  }
  
  //MARK: - share the meme
  
  func shareMeme() {
    generateMeme()
    
    let activityVC = UIActivityViewController(activityItems: [memedImage!], applicationActivities: .None)
    self.presentViewController(activityVC, animated: true, completion: { _ in
      self.saveMeme()
    })
  }
  
  //MARK: - cancel meme
  func cancelMeme() {
    imageView.image = nil
    topTextField.text = "TOP"
    bottomTextField.text = "BOTTOM"
    setBackgroundColor()
  }
}

//MARK: - UIImagePickerControllerDelegate Extension

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  //allow for editing of the image
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    var newImage: UIImage
    
    if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
      newImage = possibleImage
    } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      newImage = possibleImage
    } else {
      return
    }
    
    dismissViewControllerAnimated(true, completion: nil)
    self.imageView.image = newImage
  }
}

//MARK: - UITextFieldDelegate Extension

extension ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  //remove default meme text when edited
  func textFieldDidBeginEditing(textField: UITextField) {
    if textField.text == "TOP" {
      textField.text = ""
    } else if textField.text == "BOTTOM" {
      textField.text = ""
    }
    activeField = textField
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    activeField = nil
  }
  
}


