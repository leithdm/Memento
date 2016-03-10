//
//  MemeTableViewController.swift
//  Memento
//
//  Created by Darren Leith on 05/02/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit
import CoreData

class MemeTableViewController: UITableViewController {
	
	var memes: [Meme]!
	
	lazy var sharedContext: NSManagedObjectContext = {
		return CoreDataStackManager.sharedInstance().managedObjectContext
	}()
	
	//MARK: - lifecycle methods
	
	override func viewDidLoad() {
		super.viewDidLoad()

		//edit button
		navigationItem.leftBarButtonItem = editButtonItem()
		
		//add button
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "createMeme")
		
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		//fetch memes from database
		memes = fetchMemes()
		tableView.reloadData()

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
	
	func createMeme() {
		let memeNavController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeNavigationController") as! UINavigationController
		presentViewController(memeNavController, animated: true, completion: nil)
	}
	
	// MARK: - Table view methods
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return memes.count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let detailMemeView = storyboard!.instantiateViewControllerWithIdentifier("DetailMemeViewController") as! DetailMemeViewController
		detailMemeView.meme = memes[indexPath.row]
		navigationController?.pushViewController(detailMemeView, animated: true)
	}
	
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
		
		let meme = memes[indexPath.row]
		let memeImage = cell.viewWithTag(1) as! UIImageView
		let memeLabel = cell.viewWithTag(2) as! UILabel
		
		memeImage.image = UIImage(data: meme.originalImage)
		memeLabel.text = "\(meme.topText)...\(meme.bottomText)"
		return cell
	}
	
	
	// Override to support conditional editing of the table view.
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	// Override to support editing the table view.
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		// Delete the row from the data source.
		
		let memeToDelete = memes[indexPath.row]
		
		memes.removeAtIndex(indexPath.row)

		if (memes.isEmpty) {
			editButtonItem().enabled = false
		}
		tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		sharedContext.deleteObject(memeToDelete)
		CoreDataStackManager.sharedInstance().saveContext()
	}
	
}
