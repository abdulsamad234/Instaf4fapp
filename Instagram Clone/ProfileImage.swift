//
//  ProfileImage.swift
//  Instagram Clone
//
//  Created by Abdulsamad Aliyu on 9/25/17.
//  Copyright © 2017 Hubtel. All rights reserved.
//

import UIKit


class ProfileImage: UIImageView {


	override func awakeFromNib() {
		super.awakeFromNib()
		layer.borderWidth = 2.0
		layer.borderColor = UIColor.white.cgColor
		layer.cornerRadius = self.frame.width / 2
	}

}
