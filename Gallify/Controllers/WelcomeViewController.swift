//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Tejvir Mann on 2/16/21.
//
// Resources:
// https://www.youtube.com/watch?v=ife5YK-Keng&list=LL&index=3&t=986s
// Google Sign In:  https://www.youtube.com/watch?v=20Qlho0G3YQ
//
//
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {

    //login
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Log in"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    //email field
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "Email Address"
        emailField.layer.borderWidth = 1
        emailField.autocapitalizationType = .none
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.backgroundColor = .white
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y:0, width: 5, height: 0))
        return emailField
    }()
    
    //password field
    private let passField: UITextField = {
        let passField = UITextField()
        passField.placeholder = "Password"
        passField.layer.borderWidth = 1
        passField.isSecureTextEntry = true
        passField.layer.borderColor = UIColor.black.cgColor
        passField.backgroundColor = .white
        passField.leftViewMode = .always
        passField.leftView = UIView(frame: CGRect(x: 0, y:0, width: 5, height: 0))
        return passField
    }()
    
    //login
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Continue", for: .normal)
        return button
    }()
    
    //logout
    private let out_button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log Out", for: .normal)
        return button
    }()
    
    
    //the main view method for login
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fity"
        view.backgroundColor = .systemPink
        
        //login info calls.
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(passField)
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(didTapeButton), for: .touchUpInside)
        
        //sign in check
        if FirebaseAuth.Auth.auth().currentUser != nil{
            label.isHidden = true
            button.isHidden = true
            emailField.isHidden = true
            passField.isHidden = true
            
            print("Logged in.")
            
            
//            //adds a log out button. Uncomment this, and comment out the 2 handle sign in calls.
//            view.addSubview((out_button))
//            out_button.frame = CGRect(x: 20, y: 150, width: view.frame.size.width-40, height:50)
//            out_button.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)

        }
        
        
    }
    
    @objc private func logOutTapped(){
        do{ //sign out check
            try FirebaseAuth.Auth.auth().signOut()
            
            label.isHidden = false
            button.isHidden = false
            emailField.isHidden = false
            passField.isHidden = false
            
            out_button.removeFromSuperview()
            
        }
        catch{
            print("Sign Out Error Occured")
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 0, y: 100, width: view.width, height: 80)
        
        emailField.frame = CGRect(x: 20,
                                  y: label.frame.origin.y+label.frame.size.height+10,
                                  width: view.frame.size.width-40,
                                  height: 50)
        
        passField.frame = CGRect(x: 20,
                                 y: emailField.frame.origin.y+emailField.frame.size.height+10,
                                 width: view.frame.size.width-40,
                                 height: 50)
        
        button.frame = CGRect(x: 20,
                              y: passField.frame.origin.y+passField.frame.size.height+30,
                              width: view.frame.size.width-40,
                              height: 50)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil{
            emailField.becomeFirstResponder()
        }
    }
    
    
    @objc private func didTapeButton(){
        print("Continue button tapped")
        guard let email = emailField.text, !email.isEmpty,
              let password = passField.text, !password.isEmpty else{
                    print("Missing field data")
                    return
        }
        
        //get auth instance
        //attempt sign in
        //if fail, present alert to create account
        //if user continue, create account
        
        //check sign in on app launch
        //allow user to sign out with button
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else{
                return
            }
            
            guard error == nil else{
                //show account creation
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            
            print("You have signed in")
            strongSelf.label.isHidden = true
            strongSelf.emailField.isHidden = true
            strongSelf.passField.isHidden = true
            strongSelf.button.isHidden = true
            
            strongSelf.emailField.resignFirstResponder()
            strongSelf.passField.resignFirstResponder()
            
            //right here you should add sign out.
            //h e r e
            //self.show()
            //AuthManager.shared.isSignedIn(true)
            self?.handleSignIn()
            
            
        })
    }
    
    private func handleSignIn(){
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
    
    func showCreateAccount(email: String, password: String){
        let alert = UIAlertController(title: "Create Account",
                                      message: "Would you like to create an acount",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: {_ in
                                        //create user
                                        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self]result, error in
                                            guard let strongSelf = self else{
                                                return
                                            }
                                            
                                            guard error == nil else{
                                                //show account creation
                                                print("Account Creation Failed")
                                                return
                                            }
                                            
                                            print("You have signed in")
                                            strongSelf.label.isHidden = true
                                            strongSelf.emailField.isHidden = true
                                            strongSelf.passField.isHidden = true
                                            strongSelf.button.isHidden = true
                                            
                                            strongSelf.emailField.resignFirstResponder()
                                            strongSelf.passField.resignFirstResponder()
                                            
                                            //right here you should add log out.
                                            
                                            //HERE: At this point the user is signed in, and you can redirect them to tab bar.
                                            //Also, make sure that Auth Manager if satisfied.
                                            //h e r e
                                            self?.handleSignIn()
                                            
                                            
                                            
                                            
                                            
                                            
                                        })
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: {_ in
        }))
        
        present(alert, animated: true)
    }

}
