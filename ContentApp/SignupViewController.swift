//
//  SignupViewController.swift
//  ContentApp
//
//  Created by Rishav Gupta on 16/07/21.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import FirebaseDatabase

protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}

enum ValidatorType {
    case email
}

struct Values {
    static var name = ""
    static var email = ""
    static var phone = ""
    static var password = ""
    static var websiteLink = ""
    static var twitterHandle = ""
    static var fbHandle = ""
    static var googleId = ""
    static var tiktokHandle = ""
}

class SignupViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var RePasswordTextField: UITextField!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    static var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "SIGN UP"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold), .foregroundColor: UIColor.black]
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = .black
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        nameTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        RePasswordTextField.delegate = self
        
        phoneTextField.keyboardType = .numberPad
        emailTextField.keyboardType = .emailAddress
        
        let nameTextFieldAttribute = NSAttributedString(string: "Enter your name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        nameTextField.attributedPlaceholder = nameTextFieldAttribute
        
        let phoneTextFieldAttribute = NSAttributedString(string: "Enter your phone", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        phoneTextField.attributedPlaceholder = phoneTextFieldAttribute
        
        let emailTextFieldAttribute = NSAttributedString(string: "Enter your email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        emailTextField.attributedPlaceholder = emailTextFieldAttribute
        
        let passwordTextFieldAttribute = NSAttributedString(string: "Enter your password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTextField.attributedPlaceholder = passwordTextFieldAttribute
        
        let RePasswordTextFieldAttribute = NSAttributedString(string: "Re-Enter your password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        RePasswordTextField.attributedPlaceholder = RePasswordTextFieldAttribute
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        titleLabel.text = "Sign Up your Account"
        titleLabel.font = UIFont(name: "HelveticaNeue-bold", size: 20)
        
        phoneTextField.layer.borderColor = UIColor.black.cgColor
        phoneTextField.layer.borderWidth = 2
        phoneTextField.layer.cornerRadius = 8
        
        emailTextField.layer.borderColor = UIColor.black.cgColor
        emailTextField.layer.borderWidth = 2
        emailTextField.layer.cornerRadius = 8
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func validateEmailId(stringToValidate: String) -> Bool{
        do {
           let value = try stringToValidate.validatedText(validationType: ValidatorType.email)
            return value != ""
        } catch(let _) {
            return false
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceedButtonClicked(_ sender: Any) {
        if phoneTextField.text?.count == 10 && self.validateEmailId(stringToValidate: emailTextField.text ?? "") {
            
            Values.email = emailTextField.text ?? ""
            Values.phone = phoneTextField.text ?? ""

            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            errorLabel.text = "Please enter proper credentialss"
        }
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorLabel.text = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        SignupViewController.email = emailTextField.text ?? ""
    }
}

extension String {
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return try validator.validated(self)
    }
}

enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .email: return EmailValidator()
        }
    }
}
struct EmailValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Invalid Email ID")
            }
        } catch {
            throw ValidationError("Invalid Email ID")
        }
        return value
    }
}

class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}
