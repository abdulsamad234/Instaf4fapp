//
//  LoginViewController.swift
//  Instagram Clone
//
//  Created by Abdulsamad Aliyu on 9/15/17.
//  Copyright © 2017 Hubtel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController, UIWebViewDelegate {
	
	let defaults = UserDefaults.standard

	var activityIndicator: UIActivityIndicatorView!
	var hasFinishedAuthorization = false
	let sharedSession = URLSession.shared
	
	let webView: UIWebView = {
		let webView = UIWebView()
		webView.translatesAutoresizingMaskIntoConstraints = false
		
		
		return webView
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.initializeViews()
		self.applyLayoutConstraints()
		self.loadInstagramLoginPage()
	
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func initializeViews(){
		self.webView.delegate = self
		
		self.activityIndicator = UIActivityIndicatorView()
		self.activityIndicator.center = self.view.center
		self.activityIndicator.hidesWhenStopped = true
		self.activityIndicator.activityIndicatorViewStyle = .gray
	}
	
	func applyLayoutConstraints(){
		self.view.addSubview(self.webView)
		
		self.webView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
	}
	
	func loadInstagramLoginPage(){
		let clientId = AppConfig.TargetApiEnvironment.getEnvironmentConfiguration().clientID
		let redirectUrl = AppConfig.TargetApiEnvironment.getEnvironmentConfiguration().redirectUrl
		
		let authenticationUrl = "https://api.instagram.com/oauth/authorize/?client_id=\(clientId)&redirect_uri=\(redirectUrl)&response_type=token&scope=basic+public_content+follower_list+comments+relationships+likes"
		self.webView.loadRequest(URLRequest(url: URL(string: authenticationUrl)!))
	}
	
	var count = 0
	
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		let urlString = request.url?.absoluteString
		var urlComponents = urlString?.components(separatedBy: "#")
		if (urlComponents?.count)! > 1 && count == 0{
			self.hasFinishedAuthorization = true
			let accessToken = urlComponents?[1].components(separatedBy: "=")[1]
			
			AppConfig.storeAccessToken(token: accessToken!)
			count += 1
		}
		
		
		return true
	}
	
	func webViewDidStartLoad(_ webView: UIWebView) {
		self.view.addSubview(self.activityIndicator)
		self.activityIndicator.startAnimating()
		//UIApplication.shared.beginIgnoringInteractionEvents()
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		if(webView.isLoading) {
			return
		}
		self.activityIndicator.stopAnimating()
		UIApplication.shared.endIgnoringInteractionEvents()
		
		if(self.hasFinishedAuthorization){
			let baseUrl = AppConfig.TargetApiEnvironment.getEnvironmentConfiguration().baseUrl
			let accessToken = AppConfig.getAccessToken()
			print("Acc: \(accessToken!)")
			if let url = URL(string: "\(baseUrl)/users/self?access_token=\(accessToken!)"){
				let request = URLRequest(url: url)
				let dataTask = self.sharedSession.dataTask(with: url, completionHandler: { (data, response, error) in
					
					if let data = data {
						do{
							guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else{
								return
							}
							let dataObject = json["data"] as! [String: AnyObject]

							print("ID: \(dataObject["id"]!)")
							let id = dataObject["id"]!
							self.defaults.set("\(id)", forKey: "current_id")
							var ref: DatabaseReference!
							ref = Database.database().reference()
							
							
							ref.child("users").child("\(id)").observeSingleEvent(of: .value, with: { (snapshot) in
								let value = snapshot.value as? NSDictionary
								print("no error here")
								if value == nil {
									
									//user doesn't exist
									print("user does not exist")
									ref.child("users").child("\(id)").setValue(["id": id])
									ref.child("users/\(id)").child("points").setValue(0)
									
								}
								else{
									//user already exists
									print("user already exists")
								}
								
							}) {(error) in
								print("error here")
								print(error.localizedDescription)
							}

						}
						catch{

						}
					}
					else{
						print("could not get data")
					}

				})
				dataTask.resume()
			}
//			self.present(UINavigationController(rootViewController: HomeViewController()), animated: true, completion: nil)
			performSegue(withIdentifier: "tohome", sender: self)
//			performSegue(withIdentifier: "toTest", sender: self)
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
