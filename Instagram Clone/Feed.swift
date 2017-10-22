//
//  Feed.swift
//  Instagram Clone
//
//  Created by Abdulsamad Aliyu on 9/27/17.
//  Copyright © 2017 Hubtel. All rights reserved.
//

import UIKit

class Feed {
	var username: String
	var postDescription: String
	var userImage: UIImage
	var postImage: UIImage
	var idForPost: String
	init(username: String, postDescription: String, userImage: UIImage, postImage: UIImage, idForPost: String) {
		
		self.username = username
		self.postDescription = postDescription
		self.userImage = userImage
		self.postImage = postImage
		self.idForPost = idForPost
	}
}
