//
//  ConfirmCodeController.swift
//  AmplifyUserAuthentication1
//
//  Created by Law, Michael on 9/29/19.
//  Copyright © 2019 lawmicha. All rights reserved.
//

// TODO: if source is from forgotpassword, allow to dismiss pop view from navigation.

import UIKit
import AWSMobileClient

class ConfirmCodeController: UIViewController {
    var confirmCodeSource: ConfirmCodeSource?

    let codeInputField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Code"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)

        tf.addTarget(self, action: #selector(handleCodeInputChange), for: .editingChanged)
        return tf
    }()

   let sendCodeAgainButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("resend Code", for: .normal)


        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(LightColor, for: .normal)

        button.addTarget(self, action: #selector(handleSendCode), for: .touchUpInside)
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

    @objc func handleCodeInputChange() {
        print("handleCodeInputChange")

        guard let code = codeInputField.text else { return }

        let codeCount = codeInputField.text?.count ?? 0
        if codeCount != 6 {
            print("Code count is \(codeCount), continue at 6")
            return
        }

        guard let confirmCodeSource = confirmCodeSource else { return }

        switch confirmCodeSource {
        case .confirmSignUp(let username, let password):
            AWSMobileClient.default().confirmSignUp(username: username, confirmationCode: code) { (result, error) in
                if let error = error as? AWSMobileClientError {
                    print("error confirmSignUp: ", error)
                    DispatchQueue.main.async {
                        self.errorMessageLabel.text = "Error resendSignUpCode: \(error.message)"
                    }
                    return
                }

                print("confirmed sign up")
                AWSMobileClient.default().signIn(username: username, password: password) { (result, error) in
                    if let error = error as? AWSMobileClientError {
                        print("error signIn: ", error)
                        DispatchQueue.main.async {
                            self.errorMessageLabel.text = "Error signIn: \(error.message)"
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        guard let mainViewController = UIApplication.shared.keyWindow?.rootViewController as? MainViewController else { return }
                        mainViewController.setupViewController()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        case .forgotPassword(let username):

            let newPasswordController = NewPasswordController()
            newPasswordController.code = code
            newPasswordController.username = username

            self.navigationController?.pushViewController(newPasswordController, animated: true)
        }
    }

    @objc func handleSendCode() {
        print("handleSendCode")
        guard let confirmCodeSource = confirmCodeSource else { return }
        switch confirmCodeSource {
        case .confirmSignUp(let username, let password):
            AWSMobileClient.default().resendSignUpCode(username: username) { (result, error) in
                if let error = error as? AWSMobileClientError {
                    print("Error resendSignUpCode:", error)
                    DispatchQueue.main.async {
                        self.errorMessageLabel.text = "Error resendSignUpCode: \(error.message)"
                    }
                    return
                }
                print("sent!")
            }
        case .forgotPassword(let username):
            AWSMobileClient.default().forgotPassword(username: username) { (result, error) in
                if let error = error as? AWSMobileClientError {
                    print("Error forgotPassword: ", error)
                    DispatchQueue.main.async {
                        self.errorMessageLabel.text = "Error resendSignUpCode: \(error.message)"
                    }
                    return
                }

                print("Successfully forgot password")
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

        let stackView = UIStackView(arrangedSubviews: [codeInputField,
                                                       sendCodeAgainButton,
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
