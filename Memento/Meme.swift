//
//  Meme.swift
//  Memento
//
//  Created by Darren Leith on 04/02/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
  
  //MARK: - properties
  var topText: String
  var bottomText: String
  var originalImage: UIImage
  var memedImage: UIImage
  
  init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
    self.topText = topText
    self.bottomText = bottomText
    self.originalImage = originalImage
    self.memedImage = memedImage
  }

}