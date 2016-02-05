//
//  ViewController.swift
//  Memento
//
//  Created by Darren Leith on 03/02/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit


class MemeViewController: UIViewController {
	
	enum Notifications {
		static let keyboardWillShow = "UIKeyboardWillShowNotification"
		static let keyboardWillHide = "UIKeyboardWillHideNotification"
	}
	
	//MARK: - properties
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	@IBOutlet weak var toolBar: UIToolbar!
	@IBOutlet weak var shareIcon: UIBarButtonItem!
	
	var activeField: UITextField?
	var memedImage: UIImage?
	var keyboardUp: Bool = false
	typealias UIActivityViewControllerCompletionWithItemsHandler = (String!, Bool, [AnyObject]!, NSError!) -> Void
	
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
		topTextField.delegate = self
		bottomTextField.delegate = self
		
		//cancel icon
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelMeme")
		
		//shareButton icon disabled
		shareIcon.enabled = false
	}
	
	override func viewWillAppear(animated: Bool) {
		cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
		
		//keyboard notifications
		subscribeToKeyboardWillShowNotification()
		subscribeToKeyboardWillHideNotification()
		
		setBackgroundColor()
		loadAnimations()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		unsubscribeFromKeyboardWillShowNotification()
		unsubscribeFromKeyboardWillHideNotification()
	}
	
	//MARK: - loadAnimations
	func loadAnimations() {
		//Moving elements off-screen prior to being shown
		topTextField.center.x += view.bounds.width
		bottomTextField.center.y += view.bounds.height
		//Banner at top of view
		UIView.animateWithDuration(0.6, delay: 0, options: [.CurveEaseOut], animations: { () -> Void in
			self.topTextField.center.x -= self.view.bounds.width
			self.bottomTextField.center.y -= self.view.bounds.height
			}, completion: nil)
	}
	
	//MARK: - setMemeAttributes
	func setMemeAttributes() {
		
		//set meme default text attributes
		bottomTextField.defaultTextAttributes = memeTextAttributes
		topTextField.defaultTextAttributes = memeTextAttributes
		
		//set alignment of text
		topTextField.textAlignment = .Center
		bottomTextField.textAlignment = .Center
	}
	
	//set placeholder text
	func setPlaceholderText() {
		topTextField.text = "TOP"
		bottomTextField.text = "BOTTOM"
		
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
		if let active = activeField where !keyboardUp {
			if active == bottomTextField {
				view.frame.origin.y -= getKeyboardHeight(notification)
				keyboardUp = true
			}
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		if let active = activeField {
			if active == bottomTextField {
				view.frame.origin.y += getKeyboardHeight(notification)
				keyboardUp = false
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
	
	//import picture
	@IBAction func importPicture(sender: UIBarButtonItem) {
		let imagePicker = UIImagePickerController()
		imagePicker.allowsEditing = true
		imagePicker.delegate = self
		
		if sender.tag == 0 {
			imagePicker.sourceType = .Camera
		} else {
			imagePicker.sourceType = .PhotoLibrary
		}
		presentViewController(imagePicker, animated: true, completion: nil)
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
	
	@IBAction func shareMeme(sender: UIBarButtonItem) {
		generateMeme()
		
		let activityVC = UIActivityViewController(activityItems: [memedImage!], applicationActivities: .None)
		presentViewController(activityVC, animated: true, completion: nil)
		
		activityVC.completionWithItemsHandler = { activityVC, success, items, error in
			if !success {
				return
			}
			//save the meme
			self.saveMeme()
			//navigate to the TabBarController
			let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
			UIApplication.sharedApplication().windows.first?.rootViewController = tabBarController
		}
	}
	
	//MARK: - cancel meme
	func cancelMeme() {
		imageView.image = nil
		setPlaceholderText()
		shareIcon.enabled = false
		setBackgroundColor()
	}
}

//MARK: - UIImagePickerControllerDelegate Extension

extension MemeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
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
		imageView.image = newImage
		shareIcon.enabled = true
	}
}

//MARK: - UITextFieldDelegate Extension

extension MemeViewController: UITextFieldDelegate {
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


