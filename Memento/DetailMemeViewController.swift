//
//  DetailMemeViewController.swift
//  Memento
//
//  Created by Darren Leith on 05/02/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit

class DetailMemeViewController: UIViewController {

  var meme: Meme?
  @IBOutlet weak var memeImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editMeme")
    }
	
	override func viewWillAppear(animated: Bool) {
		if let meme = meme {
			memeImage.image = meme.memedImage
		}
	}


	func editMeme() {
		
		if let meme = meme {
		let memeNavController = storyboard!.instantiateViewControllerWithIdentifier("MemeNavigationController") as! UINavigationController
		let memeVC = memeNavController.viewControllers[0] as! MemeViewController
			
			//set the top and bottom text fields in the MemeViewController
			memeVC.topTextFieldString = meme.topText
			memeVC.bottomTextFieldString = meme.bottomText
			
			presentViewController(memeNavController, animated: true, completion: { _ in
			memeVC.imageView.image = meme.originalImage
			memeVC.shareIcon.enabled = true
			})
		}
	}
}
