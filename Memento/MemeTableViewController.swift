//
//  MemeTableViewController.swift
//  Memento
//
//  Created by Darren Leith on 05/02/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
	
	var memes: [Meme]!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
		memes = applicationDelegate.memes
		
		//edit button
		navigationItem.leftBarButtonItem = editButtonItem()
		
		//add button
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "createMeme")
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
		
		if (UIApplication.sharedApplication().delegate as! AppDelegate).memes.isEmpty {
			editButtonItem().enabled = false
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
		
		memeImage.image = meme.originalImage
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
		memes.removeAtIndex(indexPath.row)
		(UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
		tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
	}
	
}
