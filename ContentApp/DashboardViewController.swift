//
//  DashboardViewController.swift
//  ContentApp
//
//  Created by Rishav Gupta on 16/07/21.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var yourLastPayment: UILabel!
    @IBOutlet weak var yourLastPaymentValue: UILabel!
    @IBOutlet weak var totalEarnings: UILabel!
    @IBOutlet weak var totalEarningsValue: UILabel!
    @IBOutlet weak var earningsTillDate: UILabel!
    @IBOutlet weak var earningsTillDateValue: UILabel!
    @IBOutlet weak var viewAllDonationsLabel: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var normalTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "DASHBOARD"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold), .foregroundColor: UIColor.black]
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = .black
        
        navigationController?.setNavigationBarHidden(true, animated: true)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
        titleLable.text = "Welcome to your \nAccount"
        titleLable.font = UIFont(name: "HelveticaNeue-bold", size: 24)
        sideView.backgroundColor = UIColor(red: 255/255, green: 245/255, blue: 51/255, alpha: 1.0)
        
        profileImage.image = UIImage(named: "rishav")
        profileImage.layer.cornerRadius = 10
        profileName.text = "Rishav Gupta"//"Ashank Bharti"
        profileName.font = UIFont(name: "HelveticaNeue-bold", size: 16)
        status.text = "Active"
        status.font = UIFont(name: "HelveticaNeue", size: 16)
        status.textColor = .gray
        
        yourLastPayment.text = "Your last Cheer was"
        yourLastPayment.font = UIFont(name: "HelveticaNeue", size: 18)
        yourLastPayment.textColor = .gray
        yourLastPaymentValue.text = ""//"₹100"
        yourLastPaymentValue.font = UIFont(name: "HelveticaNeue-bold", size: 24)
        yourLastPaymentValue.textColor = .black
        normalTextLabel.text = "No cheers until now"
        normalTextLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        normalTextLabel.textColor = .black
        
        
        totalEarnings.text = "Total Cheers"
        totalEarnings.font = UIFont(name: "HelveticaNeue", size: 18)
        totalEarnings.textColor = .gray
        totalEarningsValue.text = "0"//29"
        totalEarningsValue.font = UIFont(name: "HelveticaNeue-bold", size: 24)
        totalEarningsValue.textColor = .black
        
        earningsTillDate.text = "Support till date"
        earningsTillDate.font = UIFont(name: "HelveticaNeue", size: 18)
        earningsTillDate.textColor = .gray
        earningsTillDateValue.text = "₹0"//"₹750"
        earningsTillDateValue.font = UIFont(name: "HelveticaNeue-bold", size: 24)
        earningsTillDateValue.textColor = .black
        
        viewAllDonationsLabel.text = "View All Cheers"
        viewAllDonationsLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        viewAllDonationsLabel.font = UIFont(name: "HelveticaNeue-bold", size: 18)
        viewAllDonationsLabel.frame.size.width = 200
        
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceedButtonClicked(_ sender: Any) {
        
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
