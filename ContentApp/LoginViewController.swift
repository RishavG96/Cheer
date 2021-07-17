//
//  LoginViewController.swift
//  ContentApp
//
//  Created by Rishav Gupta on 16/07/21.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var proceedTextField: UITextField!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var button1: GIDSignInButton! // google
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var button2: UIButton! // fb
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var button3: UIButton! // twitter
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var proceedImage: UIImageView!
    @IBOutlet weak var proceedButton: UIButton!
    
    var provider : OAuthProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "LOG IN"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold), .foregroundColor: UIColor.black]
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        emailTextFeild.textColor = .black
        
        emailTextFeild.delegate = self
        proceedTextField.delegate = self
        
        emailTextFeild.keyboardType = .emailAddress
        
        let emailAttribute = NSAttributedString(string: "Enter your email...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        emailTextFeild.attributedPlaceholder = emailAttribute
        
        let passwordAttribute = NSAttributedString(string: "Enter your password...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        proceedTextField.attributedPlaceholder = passwordAttribute
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        emailTextFeild.layer.borderColor = UIColor.black.cgColor
        emailTextFeild.layer.borderWidth = 2
        emailTextFeild.layer.cornerRadius = 8
        
        proceedTextField.layer.borderColor = UIColor.black.cgColor
        proceedTextField.layer.borderWidth = 2
        proceedTextField.layer.cornerRadius = 8
        
        let loginButton = FBLoginButton()
//        loginButton.center = CGPoint(x: view.frame.width/2, y: view.frame.width)
        loginButton.frame = CGRect(x: view.frame.width/2 - 30, y: view.frame.width - 30, width: 50, height: 50)
        loginButton.delegate = self
        loginButton.permissions = ["public_profile", "email"]
        loginButton.alpha = 0.02
        view.addSubview(loginButton)
        
        titleLabel.text = "LOG IN"
        titleLabel.font = UIFont(name: "HelveticaNeue-bold", size: 20)
    }
    

    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func button1Click(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
            if let error = error {
                // ...
                return
            }
            
            guard let authentication = user?.authentication, let idToken = authentication.idToken else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                Values.googleId = "\(authResult?.additionalUserInfo?.profile?["email"])"
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
        }
    }
    
    @IBAction func button2Click(_ sender: Any) {
        
    }
    
    @IBAction func button3Click(_ sender: Any) {
        provider = OAuthProvider(providerID: "twitter.com")
        provider?.customParameters = ["lang": "en"]
        provider?.getCredentialWith(nil) { credential, error in
            if error != nil {
                // Handle error.
            }
            if let credential = credential {
                Auth.auth().signIn(with: credential) { authResult, error in
                    if error != nil {
                        // Handle error.
                    }
                    Values.twitterHandle = "\(authResult?.additionalUserInfo?.profile?["screen_name"])"
                    // User is signed in.
                    // IdP data available in authResult.additionalUserInfo.profile.
                    // Twitter OAuth access token can also be retrieved by:
                    // authResult.credential.accessToken
                    // Twitter OAuth ID token can be retrieved by calling:
                    // authResult.credential.idToken
                    // Twitter OAuth secret can be retrieved by calling:
                    // authResult.credential.secret
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func proceedClicked(_ sender: Any) {
        if emailTextFeild.text == "ashank.bharti@gmail.com" && proceedTextField.text == "ashankrocks" {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            errorLabel.text = "Please enter valid credentials"
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorLabel.text = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        if let current = AccessToken.current {
            let credential = FacebookAuthProvider.credential(withAccessToken: current.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                Values.fbHandle = "\(authResult?.additionalUserInfo?.profile?["id"])"
            }
        }
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logged out")
    }
    
}
