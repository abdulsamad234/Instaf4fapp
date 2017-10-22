//
//  UIVideoFeedItemViewCell.swift
//  Instagram Clone
//
//  Created by Edward Pie on 27/01/2017.
//  Copyright © 2017 Hubtel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FeedCell: UITableViewCell {
	
	
	@IBOutlet weak var commentView: UIView!
	@IBOutlet weak var commentField: UITextField!
	@IBOutlet weak var postDescriptionLabel: UILabel!
	@IBOutlet weak var postImageView: UIImageView!
	@IBOutlet weak var userProfileImage: ProfileImage!
	@IBOutlet weak var userUsername: UILabel!
	
	var userIdGlobal = ""
	
	@IBOutlet weak var profileButton: UIButton!
	@IBOutlet weak var infoLabel: UILabel!
	var idForPost = ""
	let baseUrl = AppConfig.TargetApiEnvironment.getEnvironmentConfiguration().baseUrl
	let accessToken = AppConfig.getAccessToken()
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		// Initialization code
	}
	func setupCell(feed: Feed){
		
		userUsername.text = feed.username
		postDescriptionLabel.text = feed.postDescription
		
		userProfileImage.image = feed.userImage
		postImageView.image = feed.postImage
		
		idForPost = feed.idForPost
		getUserId()
		
		
	}
	
	func getUserId(){
		var userId = ""
		if let url = URL(string: "\(self.baseUrl)/media/\(idForPost)/?access_token=\(self.accessToken!)"){
			let request = URLRequest(url: url)
			let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
				if error != nil {
					print("There was an error getting the media")
				}
				else{
					if let data = data{
						do{
							guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else{
								return
							}
							let dataNew = (json["data"] as? [String: Any])
							let user = dataNew!["user"] as? [String: Any]
							DispatchQueue.main.async {
								userId = user!["id"] as! String
								self.userIdGlobal = userId
							}
							
						}
						catch{
							
						}
					}
				}
			})
			dataTask.resume()
			
//			let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
//				if error != nil {
//					print("there was an error getting the media")
//				}
//				else{
//					if let data = data {
//						do{
//							guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else{
//								return
//							}
//							let dataNew = (json["data"] as? [String: Any])
//							let user = dataNew!["user"] as? [String: Any]
//							let userId = user!["id"] as! String
//							return userId
//						}
//					}
//				}
//			})
//			dataTask.resume()
		}
	}
	
	@IBAction func followUser(_ sender: Any) {
		if let url = URL(string: "\(self.baseUrl)/media/\(idForPost)/?access_token=\(self.accessToken!)"){
			var request = URLRequest(url: url)
			let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
				
				if error != nil {
					print("there was an error getting the media")
				}
				else{
					if let data = data {
						do{
							guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else{
								return
							}
							let dataNew = (json["data"] as? [String: Any])
							let user = dataNew!["user"] as? [String: Any]
							let userId = user!["id"] as! String
							
							if let isFollowingURL = URL(string: "\(self.baseUrl)/users/\(userId)/relationship/?access_token=\(self.accessToken!)"){
								let isFollowingRequest = URLRequest(url: isFollowingURL)
								let isFollowingTask = URLSession.shared.dataTask(with: isFollowingRequest, completionHandler: { (data, response, error) in
									if error != nil {
										print("there was an error trying to get the relationship between users")
									}
									else{
										if let data = data {
											do {
												guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else{
													return
												}
												let dataForIsFollowing = json["data"] as! [String: Any]
												let follows = dataForIsFollowing["outgoing_status"] as! String
												if follows == "follows"{
													DispatchQueue.main.async {
														self.showAlert(message: "You are already following this user")
													}
												}
												else{
													if let followURL = URL(string: "\(self.baseUrl)/users/\(userId)/relationship/"){
														print("url: ", followURL)
														var followRequest = URLRequest(url: followURL)
														followRequest.httpMethod = "post"
														let followString = "action=follow&access_token=\(self.accessToken!)"
														
														followRequest.httpBody = followString.data(using: .utf8)
														let followTask = URLSession.shared.dataTask(with: followRequest, completionHandler: { (data, response, error) in
															if error != nil {
																print("There was an error following the user")
															}
															else{
																if let data = data{
																	do{
																		guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else{
																			return
																		}
																		print("Data from follow: ", json)
																		print("Method: \(followRequest.httpBody)")
																	}
																	catch{
																		
																	}
																}
																var ref:DatabaseReference!
																ref = Database.database().reference()
																let currentUserId = UserDefaults.standard.string(forKey: "current_id")!

																ref.child("users").child("\(currentUserId)").observeSingleEvent(of: .value, with: { (snapshot) in
																	let value = snapshot.value as? NSDictionary
																	if value == nil {
																		print("Error: user has not registered with this app")
																	}
																	else{
																		if let points = value!["points"] as? Int{
																			let newPoint = points + 5
																			ref.child("users/\(currentUserId)").child("points").setValue(newPoint)
																			DispatchQueue.main.async {
																				self.showAlert(message: "Successfully followed, you have gained 5 points")
																			}
																		}
																	}
																}, withCancel: { (error) in
																	print("error trying to get the user's data from firebase: ", error.localizedDescription)
																})
																
																ref.child("users").child("\(self.userIdGlobal)").observeSingleEvent(of: .value, with: { (snapshot) in
																	let value = snapshot.value as? NSDictionary
																	if value == nil {
																		print("Error: user has not registered for this app ")
																	}
																	else{
																		if let points = value!["points"] as? Int{
																			let newPoint = points - 3
																			ref.child("users/\(self.userIdGlobal)").child("points").setValue(newPoint)
																		}
																	}
																}, withCancel: { (error) in
																	print("error trying to get the user's data from firebase: ", error.localizedDescription)
																})
																
															}
														})
														followTask.resume()
													}
												}
											}
											catch{
												
											}
										}
									}
								})
								isFollowingTask.resume()
							}
						}
						catch{
						
						}
					}
				}
				
			})
			dataTask.resume()
		}
	}
	func showAlert(message: String){
		infoLabel.text = message
		infoLabel.isHidden = false
		
		Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
	}
	
	func dismissAlert(){
		infoLabel.isHidden = true
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	@IBAction func like(_ sender: Any) {
		if idForPost == "" {
			print("Post id cannot be empty")
		}
		else{
			print("It's not even empty")
			if let url = URL(string: "\(self.baseUrl)/media/\(idForPost)/?count=1&access_token=\(self.accessToken!)"){
				let request = URLRequest(url: url)
				let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
					if error == nil {
						if let data = data {
							do {
								guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
									return
								}
								let dataFull = json["data"] as! [String: AnyObject]
								let hasUserLiked = dataFull["user_has_liked"]! as! Bool
								
								if hasUserLiked{
									//user has liked
									DispatchQueue.main.async {
										self.showAlert(message: "You have already liked this post")
									}
									
								}
								else{
									//user has not liked
									if let likeURL = URL(string: "\(self.baseUrl)/media/\(self.idForPost)/likes"){
										var request = URLRequest(url: likeURL)
										request.httpMethod = "POST"
										let postString = "access_token=\(self.accessToken!)"
										request.httpBody = postString.data(using: .utf8)
										let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
											if error != nil {
												print("unluckily for you, there was an error that you couldn't catch")
											}
											else{
												print("response from like: ", response)
												if let dataNew = data{
													do{
														guard let json = try JSONSerialization.jsonObject(with: dataNew, options: []) as? [String: Any] else {
															return
														}
														let code = (json["meta"]! as! [String: AnyObject])["code"]!
														if code as? Int != 200 {
															print("There was an error when you tried to like the picture")
														}
														else{
															//picture successfully liked, now, add one to the count of points the current user has.
															var ref:DatabaseReference!
															ref = Database.database().reference()
															let currentUserId = UserDefaults.standard.string(forKey: "current_id")!
															
															ref.child("users").child("\(currentUserId)").observeSingleEvent(of: .value, with: { (snapshot) in
																let value = snapshot.value as? NSDictionary
																if value == nil {
																	print("Error: user has not registered with this app")
																}
																else{
																	if let points = value!["points"] as? Int{
																		let newPoint = points + 1
																		ref.child("users/\(currentUserId)").child("points").setValue(newPoint)
																		DispatchQueue.main.async {
																			self.showAlert(message: "Liked, you have gained 1 point")
																		}
																	}
																}
															}, withCancel: { (error) in
																print("error trying to get the user's data from firebase: ", error.localizedDescription)
															})
															
															ref.child("users").child("\(self.userIdGlobal)").observeSingleEvent(of: .value, with: { (snapshot) in
																let value = snapshot.value as? NSDictionary
																if value == nil {
																	print("Error: user has not registered for this app ")
																}
																else{
																	if let points = value!["points"] as? Int{
																		let newPoint = points - 1
																		ref.child("users/\(self.userIdGlobal)").child("points").setValue(newPoint)
																	}
																}
															}, withCancel: { (error) in
																print("error trying to get the user's data from firebase: ", error.localizedDescription)
															})
															
														}
														
													}
													catch{
														print("There was an error to be avoided dumbass")
													}
												}
											}
										})
										task.resume()
									}
									
									print("The user has not liked")
								}
							}
							catch{
								
							}
						}
					}
					else{
						print("There was an error getting the post: ", error)
					}
				})
				dataTask.resume()
			}
			
		}
	}
	
	
	@IBAction func comment(_ sender: Any) {
		commentView.isHidden = false
	}
	@IBAction func sendComment(_ sender: Any) {
		if commentField.text != "" {
			//isn't empty
			let commentText = "\(commentField.text!) (posted from the instaf4f app)"
			if let commentURL = URL(string: "\(self.baseUrl)/media/\(self.idForPost)/comments"){
				var commentRequest = URLRequest(url: commentURL)
				commentRequest.httpMethod = "POST"
				let postString = "access_token=\(self.accessToken!)&text=\(commentText)"
				commentRequest.httpBody = postString.data(using: .utf8)
				let task = URLSession.shared.dataTask(with: commentRequest, completionHandler: { (data, response , error) in
					if error != nil{
						print("There was an error trying to comment on this post", error?.localizedDescription)
					}
					else{
						if let dataNew = data{
							do{
								guard let json = try JSONSerialization.jsonObject(with: dataNew, options: []) as? [String: Any] else {
									return
								}
								let code = (json["meta"]! as! [String: AnyObject])["code"]!
								if code as? Int != 200 {
									print("There was an error when trying to comment on the picture")
								}
								else{
									//picture was successfully commented on, now we're adding 3 to the points of the current user
									var ref: DatabaseReference!
									ref = Database.database().reference()
									let currentUserId = UserDefaults.standard.string(forKey: "current_id")!
									
									ref.child("users").child("\(currentUserId)").observeSingleEvent(of: .value, with: { (snapshot) in
										let value = snapshot.value as? NSDictionary
										if value == nil {
											print("Error: user has not registered with this app")
										}
										else{
											if let points = value!["points"] as? Int {
												let newPoint = points + 3
												ref.child("users/\(currentUserId)").child("points").setValue(newPoint)
												DispatchQueue.main.async {
													self.showAlert(message: "Commented, you have gained 3 points")
													self.commentView.isHidden = true
												}
											}
										}
									}, withCancel: { (error) in
										print("Error trying to get the user's data from firebase: ", error.localizedDescription)
									})
									
									ref.child("users").child("\(self.userIdGlobal)").observeSingleEvent(of: .value, with: { (snapshot) in
										let value = snapshot.value as? NSDictionary
										if value == nil {
											print("Error: user has not registered for this app ")
										}
										else{
											if let points = value!["points"] as? Int{
												let newPoint = points - 3
												ref.child("users/\(self.userIdGlobal)").child("points").setValue(newPoint)
											}
										}
									}, withCancel: { (error) in
										print("error trying to get the user's data from firebase: ", error.localizedDescription)
									})
								}
							}
							catch{
								print("There was an error trying to converting to json form")
							}
						}
					}
				})
				task.resume()
			}
		}
		else{
			//this says that it's empty
			commentView.isHidden = true
		}
		
		
	}
}

