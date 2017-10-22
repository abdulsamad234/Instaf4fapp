  //
//  HomeViewController.swift
//  Instagram Clone
//
//  Created by Abdulsamad Aliyu on 9/15/17.
//  Copyright © 2017 Hubtel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	
	var feedArray = [Feed]()
	var arrayOfUserIds = [String]()
	var postId: String!
	
	var refreshControl: UIRefreshControl!

	@IBOutlet weak var tableViewForPost: UITableView!
	@IBOutlet weak var homeView: UIView!
	let defaults = UserDefaults.standard
	let baseUrl = AppConfig.TargetApiEnvironment.getEnvironmentConfiguration().baseUrl
	let accessToken = AppConfig.getAccessToken()
    override func viewDidLoad() {
        super.viewDidLoad()
		let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
		tap.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tap)
		
		refreshControl = UIRefreshControl()
		refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
		refreshControl.addTarget(self, action: #selector(HomeViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
		tableViewForPost.addSubview(refreshControl)
		
		tableViewForPost.delegate = self
		tableViewForPost.dataSource = self
		
		loadFeed()
		
        // Do any additional setup after loading the view.
    }
	func handleRefresh(_ refreshControl: UIRefreshControl){
		feedArray = [Feed]()
		arrayOfUserIds.removeAll()
		print("feed array as is: ", feedArray)
		loadFeed()
		tableViewForPost.reloadData()
		refreshControl.endRefreshing()
	}
	func endEditing(){
		view.endEditing(true)
	}
	func displayToast(){
		self.showToast(message: "User has not liked")
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! FeedCell
		cell.setupCell(feed: feedArray[indexPath.row])
		return cell
		
//		print("could not dequeue reusable cell")
//		return UITableViewCell()
	}
	
	
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return feedArray.count
//		return 1
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
		
        // Dispose of any resources that can be recreated.
    }

	
	func loadFeed() {
		var ref: DatabaseReference
		ref = Database.database().reference()
		
		
		ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
			let values = snapshot.value as? NSDictionary
			for value in values!{
				if let user = value.value as? NSDictionary {
					if user["id"] as? String == UserDefaults.standard.string(forKey: "current_id") {
						print("Id's are the same")
					}
					else{
						if (user["points"] as! Int) < 2{
							print("User does not have enough points")
						}
						else{
							self.arrayOfUserIds.append(user["id"] as! String)
						}
						
					}
				}
			}
			self.arrayOfUserIds.shuffle()
			for userId in self.arrayOfUserIds{
				
				
				print("User id are not the same: \(userId)")
				
				if let url = URL(string: "\(self.baseUrl)/users/\(userId)/media/recent?count=5&access_token=\(self.accessToken!)"){
					let request = URLRequest(url: url)
					let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
						if error != nil {
							print("This was the error dumbass: \(error?.localizedDescription)")
						}
						else{
							
							if let data = data{
								do {
									guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
										return
									}
									let dataFull = json["data"] as! [AnyObject]
									for dataItem in dataFull {
										let idForPost = dataItem["id"]!
										let userWhoPosted = dataItem["user"] as! [String: AnyObject]
										let usernameOfUserWhoPosted = userWhoPosted["username"]!
										let profilePicOfPoster = userWhoPosted["profile_picture"]! as! String
										var profilePicImage: UIImage = UIImage()
										if let url = URL(string: profilePicOfPoster){
											let request = URLRequest(url: url)
											let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
												if error == nil {
													if let imageData = data {
														let image = UIImage(data: imageData)
														profilePicImage = image!
													}
													else{
														print("could not get image, it's a nil")
													}
												}
												else{
													print("could not download userImage")
												}
											})
											dataTask.resume()
										}
										var finalCaptionText = ""
										var imageForPost: UIImage = UIImage()
										if let imageBlock = dataItem["images"] as? [String: AnyObject]{
											if let standardImage = imageBlock["standard_resolution"] as? [String: AnyObject]{
												let imageURL = "\(standardImage["url"]!)"
												if let url = URL(string: imageURL){
													let request = URLRequest(url: url)
													let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
														if error != nil {
															print("could not download userImage")
														}
														else{
															if let imageData = data {
																let image = UIImage(data: imageData)
																imageForPost = image!
															}
															else{
																print("could not get image, it's a nil")
															}
														}
														self.feedArray.append(Feed(username: usernameOfUserWhoPosted as! String, postDescription: finalCaptionText, userImage: profilePicImage, postImage: imageForPost, idForPost: idForPost as! String))
														self.feedArray.shuffle()
														DispatchQueue.main.async {
															self.tableViewForPost.reloadData()
														}
													})
													dataTask.resume()
												}
											}
										}
										if let captionSection = dataItem["caption"] as? [String: AnyObject]{
											let fullCaptionText = captionSection["text"]!
											finalCaptionText = "\"\(fullCaptionText.substring(to: 30))...\""
										}
										
										
										
									}
								}
								catch{
									
								}
							}
							else{
								print("The data for the user could not be gotten")
							}
						}
					})
					dataTask.resume()
					
				}
			}
		}) { (error) in
			print("Error is: \(error.localizedDescription)")
		}
		
		print("array: : \(arrayOfUserIds)")
		
	}
	

}
