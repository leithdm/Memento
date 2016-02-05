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
		self.navigationItem.leftBarButtonItem = self.editButtonItem()
		
		//add button
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "createMeme")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func createMeme() {
			let memeVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeNavigationController") as! UINavigationController
			UIApplication.sharedApplication().windows.first?.rootViewController = memeVC
	}

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

		let meme = memes[indexPath.row]
		cell.imageView?.image = meme.originalImage
		cell.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

	
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			memes.removeAtIndex(indexPath.row)
        }
    }

}
