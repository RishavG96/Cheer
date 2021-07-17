//
//  OTPViewController.swift
//  ContentApp
//
//  Created by Rishav Gupta on 16/07/21.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "SIGN UP"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold), .foregroundColor: UIColor.black]
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = .black
        
        otpTextField.delegate = self
        
        otpTextField.keyboardType = .numberPad
        
        headingLabel.text = "We have sent you an OTP to " + Values.phone
        headingLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        
        let otpTextFieldAttribute = NSAttributedString(string: "Enter OTP", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        otpTextField.attributedPlaceholder = otpTextFieldAttribute
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        titleLabel.text = "Let’s verify you"
        titleLabel.font = UIFont(name: "HelveticaNeue-bold", size: 20)
        
        otpTextField.layer.borderColor = UIColor.black.cgColor
        otpTextField.layer.borderWidth = 2
        otpTextField.layer.cornerRadius = 8
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func proceedButtonClicked(_ sender: Any) {
        if otpTextField.text?.count == 6 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OnboardingDetailsViewController") as? OnboardingDetailsViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            errorLabel.text = "Please enter correct OTP"
        }
    }
}

extension OTPViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorLabel.text = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
