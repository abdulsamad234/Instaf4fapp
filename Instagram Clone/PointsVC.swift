//
//  PointsVC.swift
//  Instagram Clone
//
//  Created by Abdulsamad Aliyu on 10/11/17.
//  Copyright © 2017 Hubtel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PointsVC: UIViewController {

	@IBOutlet weak var profileImageView: ProfileImage!
	@IBOutlet weak var pointsLabel: UILabel!
	@IBOutlet weak var followersLabel: UILabel!
	@IBOutlet weak var followingLabel: UILabel!
	let defaults = UserDefaults.standard
	let baseUrl = AppConfig.TargetApiEnvironment.getEnvironmentConfiguration().baseUrl
	let accessToken = AppConfig.getAccessToken()
	override func viewDidLoad() {
        super.viewDidLoad()
		setUpViews()

        // Do any additional setup after loading the view.
    }
	override func viewDidAppear(_ animated: Bool) {
		setUpViews()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setUpViews(){
		if let url = URL(string: "\(self.baseUrl)/users/self?access_token=\(self.accessToken!)"){
			let request = URLRequest(url: url)
			let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
				if error != nil{
					print("There was an error getting the user's info")
				}
				else{
					if let data = data{
						do{
							guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else{
								return
							}
							var followersCount = 0
							var followingCount = 0
							if let datas = json["data"] as? [String: Any]{
								if let counts = datas["counts"] as? [String: Any]{
									followingCount = counts["follows"] as! Int
									followersCount = counts["followed_by"] as! Int
									
									
								}
								let profilePictureURL = datas["profile_picture"] as! String
								var profilePictureImage = UIImage()
								
								
								if let url = URL(string: profilePictureURL){
									let request = URLRequest(url: url)
									let tasking = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
										if error == nil {
											if let imageData = data{
												
												let image = UIImage(data: imageData)
												profilePictureImage = image!
											}
											else{
												print("could not get image, it's a nil")
											}
										}
										DispatchQueue.main.async {
											self.profileImageView.image = profilePictureImage
										}
									})
									tasking.resume()
								}
								DispatchQueue.main.async {
									self.followersLabel.text = "\(followersCount)"
									self.followingLabel.text = "\(followingCount)"
									
								}
							}
						}
						catch{
							
						}
					}
				}
			})
			task.resume()
			var ref: DatabaseReference!
			ref = Database.database().reference()
			let currentUserId = UserDefaults.standard.string(forKey: "current_id")!
			ref.child("users").child("\(currentUserId)").observeSingleEvent(of: .value, with: { (snapshot) in
				let value = snapshot.value as? NSDictionary
				if value == nil {
					print("Error: user has not registered with this app")
				}
				else{
					if let points = value!["points"] as? Int{
						DispatchQueue.main.async {
							self.pointsLabel.text = "\(points)"
						}
					}
				}
			}, withCancel: { (error) in
				print("There was an error getting the points")
			})
		}
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
