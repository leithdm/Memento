//
//  MemeCollectionViewController.swift
//  Memento
//
//  Created by Darren Leith on 05/02/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "MemeCollectionViewCell"

class MemeCollectionViewController: UICollectionViewController  {
	
	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
	var memes: [Meme]!
	
	lazy var sharedContext: NSManagedObjectContext = {
		return CoreDataStackManager.sharedInstance().managedObjectContext
	}()
	
	//MARK: - Lifecycle methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//flowLayout
		let space: CGFloat = 3.0
		let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
		flowLayout.minimumInteritemSpacing = space
		flowLayout.minimumLineSpacing = space
		flowLayout.itemSize = CGSizeMake(dimension, dimension)
		
		//add button
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "createMeme")
	}
	
	//MARK: - fetch memes from database
	
	func fetchMemes() -> [Meme] {
		let fetchRequest = NSFetchRequest(entityName: "Meme")
		
		do {
			return try sharedContext.executeFetchRequest(fetchRequest) as! [Meme]
		} catch {
			return [Meme]()
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		//fetch memes from database
		memes = fetchMemes()
		collectionView!.reloadData()
	}
	
	//MARK: - create a new meme
	func createMeme() {
		let memeNavController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeNavigationController") as! UINavigationController
		presentViewController(memeNavController, animated: true, completion: nil)
	}
	
	// MARK: UICollectionViewDataSource / Delegate
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return memes.count
	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let detailMemeView = storyboard!.instantiateViewControllerWithIdentifier("DetailMemeViewController") as! DetailMemeViewController
		detailMemeView.meme = memes[indexPath.row]
		navigationController?.pushViewController(detailMemeView, animated: true)
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
		let meme = memes[indexPath.row]
		
		cell.memeImage.image = UIImage(data: meme.originalImage)
		cell.memeTopText!.text = meme.topText
		cell.memeBottomText!.text = meme.bottomText
		
		return cell
	}
}
