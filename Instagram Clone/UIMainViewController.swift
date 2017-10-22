//
//  ViewController.swift
//  Instagram Clone
//
//  Created by Edward Pie on 26/01/2017.
//  Copyright © 2017 Hubtel. All rights reserved.
//

import UIKit

class UIMainViewController: UIViewController {
    var backgroundGradientLayer: CAGradientLayer!
    
    let logoImageView: UITextView = {
		let imageView = UITextView()
		imageView.text = "Instagramf4f"
		imageView.font = UIFont(name: "Yellowtail-Regular", size: 60.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
		imageView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return imageView
    }()
    
    let introLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Log in to start getting more likes and comments on your posts."
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        return label
    }()
    
    let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#9844A4FF")
        
        view.layer.shadowColor = UIColor(hexString: "#9844A4FF")?.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize.zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("SIGN UP", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOG IN", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeViews()
        self.applyLayoutConstraints()
        self.registerEventHandlers()
    }
    
    func initializeViews(){
        self.backgroundGradientLayer = CAGradientLayer()
        self.backgroundGradientLayer.frame = self.view.bounds
        self.backgroundGradientLayer.colors = [
            UIColor(red: 151/255, green: 48/255, blue: 123/255, alpha: 1).cgColor,
            UIColor(red: 129/255, green: 63/255, blue: 153/255, alpha: 1).cgColor]
        self.backgroundGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        self.backgroundGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        self.view.layer.addSublayer(self.backgroundGradientLayer)
    }
    
    func applyLayoutConstraints(){
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.introLabel)
        self.view.addSubview(self.footerView)
        self.footerView.addSubview(self.signUpButton)
        self.footerView.addSubview(self.loginButton)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.logoImageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.logoImageView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 190.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.logoImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.logoImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 150.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.introLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.introLabel, attribute: .top, relatedBy: .equal, toItem: self.logoImageView, attribute: .bottom, multiplier: 1.0, constant: -30.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.introLabel, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: -5.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.introLabel, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 5.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.footerView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.footerView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.footerView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.footerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60.0))
        
        self.footerView.addConstraint(NSLayoutConstraint(item: self.signUpButton, attribute: .centerY, relatedBy: .equal, toItem: self.footerView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.signUpButton, attribute: .left, relatedBy: .equal, toItem: self.footerView, attribute: .left, multiplier: 1.0, constant: 5.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.signUpButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.signUpButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0))
        
        self.footerView.addConstraint(NSLayoutConstraint(item: self.loginButton, attribute: .centerY, relatedBy: .equal, toItem: self.footerView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.loginButton, attribute: .right, relatedBy: .equal, toItem: self.footerView, attribute: .right, multiplier: 1.0, constant: -5.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0))
        
    }
    
    func registerEventHandlers(){
        self.signUpButton.addTarget(self, action: #selector(self.onSignUpButtonTapped), for: .touchUpInside)
        self.loginButton.addTarget(self, action: #selector(self.onLoginButtonTapped), for: .touchUpInside)
        
    }
    
    func onLoginButtonTapped(){
//        let loginViewController = LoginViewController()
//        self.present(loginViewController, animated: true, completion: nil)
		performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    func onSignUpButtonTapped(){
        let url = URL(string: "https://www.instagram.com/accounts/login/")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }else{
            UIApplication.shared.open(url!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

