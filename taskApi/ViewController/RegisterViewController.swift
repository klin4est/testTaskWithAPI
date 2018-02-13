//
//  RegisterViewController.swift
//  taskApi
//
//  Created by Stanislav Astakhov on 12.02.2018.
//  Copyright © 2018 Stanislav Astakhov. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    //MARK: Private Properties
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var nameView: UIView!
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet private weak var passwordView: UIView!

    private let nameTextFieldView = TextFieldView.instanceFromNib() 
    private let emailTextFieldView = TextFieldView.instanceFromNib()
    private let passwordTextFieldView = TextFieldView.instanceFromNib()

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    //MARK: Actions
    @IBAction func returnAction(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func postRegistration(_ sender: UIButton) {
        postRegInfo()
    }

    //MARK: Private Methods
    private func setupUI() {
        if let nameTextFieldView = nameTextFieldView {
            nameView.addSubview(nameTextFieldView)
            nameTextFieldView.setPlaceHolder(with: "First name")
        }
        if let emailTextFieldView = emailTextFieldView {
            emailView.addSubview(emailTextFieldView)
            emailTextFieldView.setPlaceHolder(with: "Email address")
        }
        if let passwordTextFieldView = passwordTextFieldView {
            passwordView.addSubview(passwordTextFieldView)
            passwordTextFieldView.setPlaceHolder(with: "Password")
            passwordTextFieldView.setSecureTextEnry(enable: true)
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginViewController.keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginViewController.keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    private func postRegInfo() {
        var paramsBody = [String: Any]()
        guard let name = nameTextFieldView?.returnText(),
            let email = emailTextFieldView?.returnText(),
            let password = passwordTextFieldView?.returnText()
            else { return }

        paramsBody["name"] = name
        paramsBody["email"] = email
        paramsBody["password"] = password

        let jsonData = try? JSONSerialization.data(withJSONObject: paramsBody, options: .prettyPrinted)

        guard let url = URL(string: "https://apiecho.cf/api/signup/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            if error != nil {
                let alert = UIAlertController(title: "error", message: "No data", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .destructive, handler: nil)
                alert.addAction(okButton)
                self?.present(alert, animated: true, completion: nil)

                return
            }

            if let data = data {
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let json = responseJSON as? [String: Any] {
                    if let errorDict = json["errors"] as? [[String: Any]] {
                        if errorDict.count > 0 {
                            if let firstError = errorDict[0]["message"] as? String {
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "error", message: firstError, preferredStyle: .alert)
                                    let okButton = UIAlertAction(title: "OK", style: .destructive, handler: nil)
                                    alert.addAction(okButton)
                                    self?.present(alert, animated: true, completion: nil)
                                    return
                                }
                            }
                        }
                    }
                    if let dataDict = json["data"] as? [String:Any] {
                        if let accessToken = dataDict["access_token"] as? String {
                            UserDefaults.standard.set(accessToken, forKey: "taskApiAccessToken")
                            UserDefaults.standard.set(email, forKey: "taskApiEmail")
                            UserDefaults.standard.set(password, forKey: "taskApiPassword")

                            DispatchQueue.main.async {
                                self?.dismiss(animated: false)
                            }
                        }
                    }
                }
            }
        })
        task.resume()
    }
}
