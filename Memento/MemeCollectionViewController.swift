//
//  MemeCollectionViewController.swift
//  Memento
//
//  Created by Darren Leith on 05/02/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCollectionViewCell"

class MemeCollectionViewController: UICollectionViewController  {
	
	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
	var memes: [Meme]!
	

	override func viewDidLoad() {
		super.viewDidLoad()
		
		//shared Meme data model
		let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
		memes = applicationDelegate.memes
		
		//flowLayout
		let space: CGFloat = 3.0
		let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
		flowLayout.minimumInteritemSpacing = space
		flowLayout.minimumLineSpacing = space
		flowLayout.itemSize = CGSizeMake(dimension, dimension)
		
		//add button
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "createMeme")
	}
	
	// MARK: UICollectionViewDataSource
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return memes.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
		let meme = memes[indexPath.row]
		
		cell.memeImage.image = meme.originalImage
		cell.memeTopText!.text = meme.topText
		cell.memeBottomText!.text = meme.bottomText
		
		return cell
	}
	
	func createMeme() {
		let memeNavController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeNavigationController") as! UINavigationController
		presentViewController(memeNavController, animated: true, completion: nil)
	}
}
