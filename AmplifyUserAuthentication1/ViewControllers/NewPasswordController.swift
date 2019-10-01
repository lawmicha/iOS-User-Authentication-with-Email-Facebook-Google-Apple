//
//  NewPasswordController.swift
//  AmplifyUserAuthentication1
//
//  Created by Law, Michael on 9/29/19.
//  Copyright © 2019 lawmicha. All rights reserved.
//

import Foundation
import AWSMobileClient

class NewPasswordController: UIViewController {
    var code: String?
    var username: String?

    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()

    let newPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update password", for: .normal)

        button.backgroundColor = LightColor

        let myColor = UIColor.red
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)

        button.addTarget(self, action: #selector(handleNewPassword), for: .touchUpInside)

        button.isEnabled = false
        return button
    }()

    let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .red
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    // MARK: Handlers

    @objc func handleTextInputChange() {

        let isFormValid = passwordTextField.text?.count ?? 0 > 0

        if isFormValid {
            newPasswordButton.isEnabled = true
            newPasswordButton.backgroundColor = DarkColor
        } else {
            newPasswordButton.isEnabled = false
            newPasswordButton.backgroundColor = LightColor
        }
    }

    @objc func handleNewPassword() {
        guard let code = code else { return }
        guard let username = username else { return }
        guard let password = passwordTextField.text, password.count  > 0 else { return }

        AWSMobileClient.default().confirmForgotPassword(username: username, newPassword: password, confirmationCode: code) { (result, error) in
            if let error = error as? AWSMobileClientError {
                print("Error confirmForgotPassword: ", error)
                DispatchQueue.main.async {
                    self.errorMessageLabel.text = "Error: \(error.message)"
                }
                return
            }

            AWSMobileClient.default().signIn(username: username, password: password) { (result, error) in
                if let error = error as? AWSMobileClientError {
                    print("Error SignIn: ", error)
                    DispatchQueue.main.async {
                        self.errorMessageLabel.text = "Error SignIn: \(error.message)"
                    }
                    return
                }

                print("Signed in for \(username)")
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        guard let mainViewController = UIApplication.shared.keyWindow?.rootViewController as? MainViewController else { return }
                        mainViewController.setupViewController()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }

    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupInputFields()
    }

    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [passwordTextField,
                                                       newPasswordButton,
                                                       errorMessageLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10

        view.addSubview(stackView)

        stackView.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         bottom: nil,
                         right: view.rightAnchor,
                         paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }

}
