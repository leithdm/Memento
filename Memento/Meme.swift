//
//  Meme.swift
//  Memento
//
//  Created by Darren Leith on 04/02/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Meme: NSManagedObject {
	
	//MARK: - properties
	@NSManaged var topText: String
	@NSManaged var bottomText: String
	@NSManaged var originalImage: NSData
	@NSManaged var memedImage: NSData
	
	override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
		super.init(entity: entity, insertIntoManagedObjectContext: context)
	}
	
	init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage, context: NSManagedObjectContext) {
		
		let entity = NSEntityDescription.entityForName("Meme", inManagedObjectContext: context)!
		super.init(entity: entity, insertIntoManagedObjectContext: context)
		
		self.topText = topText
		self.bottomText = bottomText
		self.originalImage = UIImageJPEGRepresentation(originalImage, 1.0)!
		self.memedImage = UIImageJPEGRepresentation(memedImage, 1.0)!
	}

}