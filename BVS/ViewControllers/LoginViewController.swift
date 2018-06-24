//
//  LoginViewController.swift
//  BVS
//
//  Created by Peter Slavich on 2/22/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LoginViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, LoginDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var buttonLogin: UIButton!
    
    var textFieldUsername: UITextField = UITextField(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0)))
    var textFieldPassword: UITextField  = UITextField(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0)))
    
    override func viewDidLoad() {
        textFieldUsername.delegate = self
        textFieldPassword.delegate = self
        
        textFieldUsername.autocapitalizationType = .none
        textFieldUsername.autocorrectionType = .no
        textFieldUsername.font = UIFont.systemFont(ofSize: 18)
        textFieldUsername.adjustsFontSizeToFitWidth = true
        
        textFieldPassword.autocapitalizationType = .none
        textFieldPassword.autocorrectionType = .no
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.font = UIFont.systemFont(ofSize: 18)
        textFieldPassword.adjustsFontSizeToFitWidth = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textFieldUsername.becomeFirstResponder()
    }
    
    func loginSuccessful() {
        activityIndicator.stopAnimating()
        buttonLogin.isEnabled = true
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func loginFailed(message: String) {


        let alert = UIAlertController(title:"Login Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert,animated: true) {
            self.activityIndicator.stopAnimating()
            self.buttonLogin.isEnabled = true
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        buttonLogin.isEnabled = false
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.webService?.login(username: textFieldUsername.text!, password: textFieldPassword.text!, loginDelegate: self)
        //appDelegate.webService?.login(username: "testpatient@fake.net", password: "12345678", loginDelegate: self)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        let alert = UIAlertController(title:"Don't Log In?", message: "Are you sure you don't want to log in? If you are not logged in, your data will not be sent to the server for analysis.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue Log In", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }))
        
        present(alert,animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "LoginCell")
        if cell == nil {
            cell = UITableViewCell(style:.subtitle, reuseIdentifier:"LoginCell")
        }
        cell?.selectionStyle = .none
        if (indexPath.section == 0) {
            cell?.contentView.addSubview(textFieldUsername)
            if let frame = cell?.contentView.frame {
                textFieldUsername.frame = CGRect(origin: CGPoint(x:10,y:10), size: CGSize(width: frame.size.width - 20, height: frame.size.height - 20))
            }
        }
        else {
            cell?.contentView.addSubview(textFieldPassword)
            if let frame = cell?.contentView.frame {
                textFieldPassword.frame = CGRect(origin: CGPoint(x:10,y:10), size: CGSize(width: frame.size.width - 20, height: frame.size.height - 20))
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "User Email"
        }
        return "Password"
    }
    
    //MARK: TextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldUsername {
            textFieldPassword.becomeFirstResponder()
        }
        else {
            if let text = textFieldUsername.text,
                text.count > 0 {
                loginPressed(self)
            }
            else {
                textFieldUsername.becomeFirstResponder()
            }
        }
        return true
    }
}
