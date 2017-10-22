//
//  LogoutViewController.swift
//  Instagram Clone
//
//  Created by Abdulsamad Aliyu on 10/18/17.
//  Copyright © 2017 Hubtel. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController, UIWebViewDelegate {

	@IBOutlet weak var webview: UIWebView!
	
	var activityIndicator: UIActivityIndicatorView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.webview.delegate = self
		self.activityIndicator = UIActivityIndicatorView()
		self.activityIndicator.center = self.view.center
		self.activityIndicator.hidesWhenStopped = true
		self.activityIndicator.activityIndicatorViewStyle = .gray
		
		let logoutUrl = "https://instagram.com/accounts/logout/"
		self.webview.loadRequest(URLRequest(url: URL(string: logoutUrl)!))

        // Do any additional setup after loading the view.
    }
	
	func webViewDidStartLoad(_ webView: UIWebView) {
		self.view.addSubview(self.activityIndicator)
		self.activityIndicator.startAnimating()
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		if(webview.isLoading){
			return
		}
		self.activityIndicator.stopAnimating()
		
		performSegue(withIdentifier: "toMainHome", sender: nil)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
