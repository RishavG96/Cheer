//
//  ViewController.swift
//  ContentApp
//
//  Created by Rishav Gupta on 16/07/21.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet weak var button: GIDSignInButton!
    
    var provider : OAuthProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let loginButton = FBLoginButton()
//        loginButton.center = view.center
//        loginButton.delegate = self
//        loginButton.permissions = ["public_profile", "email"]
//        view.addSubview(loginButton)
        
        
    }
    @IBAction func buttonClicked(_ sender: Any) {
        //Google
        //__________________________________________________________________________________________________________
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//        // Create Google Sign In configuration object.
//        let config = GIDConfiguration(clientID: clientID)
//
//        // Start the sign in flow!
//        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
//
//          if let error = error {
//            // ...
//            return
//          }
//
//          guard let authentication = user?.authentication, let idToken = authentication.idToken else {
//            return
//          }
//
//          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                         accessToken: authentication.accessToken)
//
//          // ...
//        }
        
        //__________________________________________________________________________________________________________

        //Twitter
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
                  // User is signed in.
                  // IdP data available in authResult.additionalUserInfo.profile.
                  // Twitter OAuth access token can also be retrieved by:
                  // authResult.credential.accessToken
                  // Twitter OAuth ID token can be retrieved by calling:
                  // authResult.credential.idToken
                  // Twitter OAuth secret can be retrieved by calling:
                  // authResult.credential.secret
                }
              }
            }


        //__________________________________________________________________________________________________________

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
    }

//https://contentapp-12626.firebaseapp.com/__/auth/handler
//https://contentapp-12626.firebaseapp.com/__/auth/handler
}

extension ViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)

    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logged out")
    }
    
}


extension ViewController: AuthUIDelegate {
    
}
