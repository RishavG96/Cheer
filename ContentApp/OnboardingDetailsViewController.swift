//
//  OnboardingDetailsViewController.swift
//  ContentApp
//
//  Created by Rishav Gupta on 16/07/21.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import FirebaseDatabase

class OnboardingDetailsViewController: UIViewController {

    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var tictokTextField: UITextField!
    @IBOutlet weak var fbButton: FBLoginButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var provider : OAuthProvider?
    var contentPlatformsIcons = ["google", "facebook", "twitter", "tik-tok", "github", "medium", "spotify", "website"]
    var contentPlatformsNames = ["YouTube", "Instagram", "Twitter", "TikTok", "Github", "Medium", "Spotify", "Your Website"]
    var fbItem = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "USER DETAILS"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold), .foregroundColor: UIColor.black]
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = .black
        
        websiteTextField.delegate = self
        tictokTextField.delegate = self
        
        let websiteTextFieldAttribute = NSAttributedString(string: "Enter your Website", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        websiteTextField.attributedPlaceholder = websiteTextFieldAttribute
        
        let tictokTextFieldAttribute = NSAttributedString(string: "Enter your TikTok ID", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tictokTextField.attributedPlaceholder = tictokTextFieldAttribute
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
        
        fbButton.isHidden = true
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: view.frame.width/2 + 50, y: view.frame.width - 80, width: 100, height: 10)
        loginButton.delegate = self
        loginButton.permissions = ["public_profile", "email"]
        loginButton.alpha = 0.02
        view.addSubview(loginButton)
        
        
        titleLable.text = "Let’s connect with your social platforms"
        titleLable.font = UIFont(name: "HelveticaNeue-bold", size: 20)
        
        collectionView.register(UINib(nibName: "WebsiteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WebsiteCollectionViewCell")
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func fbButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func twitterButtonClicked(_ sender: Any) {
//        twitterButtonClick()
    }
    
    @IBAction func googleButtonClicked(_ sender: Any) {
//        googleButtonClick()
    }
    
    @IBAction func proceedButtonClicked(_ sender: Any) {
        Values.websiteLink = websiteTextField.text ?? ""
        Values.tiktokHandle = tictokTextField.text ?? ""
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("Creators").child((Auth.auth().currentUser?.uid)!).setValue([
            "name": Values.name,
            "email": Values.email,
            "phone": Values.phone,
            "password": Values.password,
            "websiteLink": Values.websiteLink,
            "tiktokLink": Values.tiktokHandle,
            "fbHandle": Values.fbHandle,
            "twitterHandle": Values.twitterHandle,
            "googleId": Values.googleId
        ])
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func googleButtonClick(item: Int) {
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
                Values.googleId = "\(authResult?.additionalUserInfo?.profile?["email"] ?? NSObject())"
                if let cell = collectionView.cellForItem(at: IndexPath(item: item, section: 0)) as? WebsiteCollectionViewCell {
//                    cell.shadowView.backgroundColor = UIColor(red: 255/255, green: 245/255, blue: 51/255, alpha: 1.0)
                    cell.shadowView.layer.borderWidth = 2
                    cell.shadowView.layer.borderColor = UIColor.black.cgColor
                    cell.checkBox.image = UIImage(named: "check")
                    cell.label.textColor = .black
                    cell.isUserInteractionEnabled = false
                    cell.label.font = UIFont.boldSystemFont(ofSize: 20)
                }
            }
//            self.googleButton.setTitle("Google Account Linked", for: .normal)
//            self.googleButton.isUserInteractionEnabled = false
            
        }
    }
    
    func twitterButtonClick(item: Int) {
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
                    Values.twitterHandle = "\(authResult?.additionalUserInfo?.profile?["screen_name"] ?? NSObject())"
                    // User is signed in.
                    // IdP data available in authResult.additionalUserInfo.profile.
                    // Twitter OAuth access token can also be retrieved by:
                    // authResult.credential.accessToken
                    // Twitter OAuth ID token can be retrieved by calling:
                    // authResult.credential.idToken
                    // Twitter OAuth secret can be retrieved by calling:
                    // authResult.credential.secret
//                    self.twitterButton.setTitle("Twitter Account Linked", for: .normal)
//                    self.twitterButton.isUserInteractionEnabled = false
                    if let cell = self.collectionView.cellForItem(at: IndexPath(item: item, section: 0)) as? WebsiteCollectionViewCell {
//                        cell.shadowView.backgroundColor = UIColor(red: 255/255, green: 245/255, blue: 51/255, alpha: 1.0)
                        cell.shadowView.layer.borderWidth = 2
                        cell.shadowView.layer.borderColor = UIColor.black.cgColor
                        cell.checkBox.image = UIImage(named: "check")
                        cell.label.textColor = .black
                        cell.isUserInteractionEnabled = false
                        cell.label.font = UIFont.boldSystemFont(ofSize: 20)
                    }
                }
            }
        }
    }
    
    func fbButtonClicked(item: Int) {
        
    }
}

extension OnboardingDetailsViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        if let current = AccessToken.current {
            let credential = FacebookAuthProvider.credential(withAccessToken: current.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                Values.fbHandle = "\(authResult?.additionalUserInfo?.profile?["id"] ?? NSObject())"
                if let cell = self.collectionView.cellForItem(at: IndexPath(item: self.fbItem, section: 0)) as? WebsiteCollectionViewCell {
//                    cell.shadowView.backgroundColor = UIColor(red: 255/255, green: 245/255, blue: 51/255, alpha: 1.0)
                    cell.shadowView.layer.borderWidth = 2
                    cell.shadowView.layer.borderColor = UIColor.black.cgColor
                    cell.checkBox.image = UIImage(named: "check")
                    cell.label.textColor = .black
                    cell.label.font = UIFont.boldSystemFont(ofSize: 20)
                    cell.isUserInteractionEnabled = false
                }
            }
        }
        
//        fbButton.setTitle("Facebook Account Linked", for: .normal)
//        fbButton.isUserInteractionEnabled = false
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logged out")
    }
    
}


extension OnboardingDetailsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension OnboardingDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentPlatformsIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WebsiteCollectionViewCell", for: indexPath) as? WebsiteCollectionViewCell {
            cell.image.image = UIImage(named: contentPlatformsIcons[indexPath.item])
            cell.label.text = contentPlatformsNames[indexPath.item]
            cell.label.font = UIFont.boldSystemFont(ofSize: 20)
//            if indexPath.item == 0 {
//                cell.shadowView.backgroundColor = .black
//                cell.label.textColor = .white
//            }
            cell.isUserInteractionEnabled = true
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width / 2) - 10
        return CGSize(width: width, height: 180)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            googleButtonClick(item: indexPath.item)
        case 1:
//            fbButtonClicked(item: indexPath.item)
            fbItem = indexPath.item
        case 2:
            twitterButtonClick(item: indexPath.item)
        default:
            break
        }
    }
}
