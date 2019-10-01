//
//  LoginController.swift
//  AmplifyUserAuthentication1
//
//  Created by Law, Michael on 9/29/19.
//  Copyright © 2019 lawmicha. All rights reserved.
//

import UIKit
import AWSMobileClient

class LoginController: UIViewController {

    // MARK: UI Components
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)

        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)

        return tf
    }()

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

    let loginButton: UIButton = {
       let button = UIButton(type: .system)
       button.setTitle("Login", for: .normal)
       button.backgroundColor = LightColor

       button.layer.cornerRadius = 5
       button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
       button.setTitleColor(.white, for: .normal)

       button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)

       button.isEnabled = false

       return button
    }()

    let fbLoginButton: UIButton = {
       let button = UIButton(type: .system)
       button.setTitle("Facebook", for: .normal)
       button.backgroundColor = DarkColor

       button.layer.cornerRadius = 5
       button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
       button.setTitleColor(.white, for: .normal)

       button.addTarget(self, action: #selector(handleFacebookLogin), for: .touchUpInside)

       return button
    }()

    let googleLoginButton: UIButton = {
       let button = UIButton(type: .system)
       button.setTitle("Google", for: .normal)
       button.backgroundColor = DarkColor

       button.layer.cornerRadius = 5
       button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
       button.setTitleColor(.white, for: .normal)

       button.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)

       return button
    }()



    let forgotPassword: UIButton = {
        let button = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: "Forgot password? ",
                                                       attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                                    NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        attributedTitle.append(NSAttributedString(string: "Send confirmation code",
                                                 attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                                                              NSAttributedString.Key.foregroundColor: DarkColor]))

        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)

        button.isHidden = true
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

    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ",
                                                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                                     NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        attributedTitle.append(NSAttributedString(string: "Sign Up",
                                                  attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                                                               NSAttributedString.Key.foregroundColor: DarkColor]))

        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()

    let dummyBottomView: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: Handlers

    @objc func handleTextInputChange() {

        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0

        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = DarkColor

        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = LightColor
        }
    }

    @objc func handleLogin() {
        print("handleLogin")
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        AWSMobileClient.default().signIn(username: email, password: password) { (result, error) in
            if let error = error as? AWSMobileClientError {
                print("Error SignIn: ", error)

                DispatchQueue.main.async {
                    self.errorMessageLabel.text = "Error SignIn: \(error.message)"

                    if case .notAuthorized = error {
                        self.forgotPassword.isHidden = false
                    }
                }

                return
            }

            print("Signed in for \(email)")
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    guard let mainViewController = UIApplication.shared.keyWindow?.rootViewController as? MainViewController else { return }
                    mainViewController.setupViewController()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    @objc func handleFacebookLogin() {
        handleFederatedSignIn(identityProvider: "Facebook")
    }

    @objc func handleGoogleLogin() {
        handleFederatedSignIn(identityProvider: "Google")
    }

    func handleFederatedSignIn(identityProvider: String) {
        // Optionally override the scopes based on the usecase.
        let hostedUIOptions = HostedUIOptions(identityProvider: identityProvider)

        // Present the Hosted UI sign in.
        AWSMobileClient.default().showSignIn(navigationController: self.navigationController!, hostedUIOptions: hostedUIOptions) { (userState, error) in
            if let error = error as? AWSMobileClientError {
                print("Error ShowSignIn: ", error)

                DispatchQueue.main.async {
                    self.errorMessageLabel.text = "Error ShowSignIn: \(error.message)"
                }

                return
            }

            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    guard let mainViewController = UIApplication.shared.keyWindow?.rootViewController as? MainViewController else { return }
                    mainViewController.setupViewController()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }

    @objc func handleForgotPassword() {
        print("handleForgotPassword")

        guard let email = emailTextField.text else { return }
        
        AWSMobileClient.default().forgotPassword(username: email) { (result, error) in
            if let error = error as? AWSMobileClientError {
                print("Error forgotPassword: ", error)
                DispatchQueue.main.async {
                    self.errorMessageLabel.text = "Error forgotPassword: \(error.message)"
                }
                return
            }

            print("Successfully forgot password")
            DispatchQueue.main.async {
                let confirmCodeController = ConfirmCodeController()
                confirmCodeController.confirmCodeSource = ConfirmCodeSource.forgotPassword(username: email)
                self.navigationController?.pushViewController(confirmCodeController, animated: true)
            }
        }
    }

    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //GIDSignIn.sharedInstance()?.presentingViewController = self

        navigationController?.isNavigationBarHidden = true

        setupInputFields()
        view.addSubview(forgotPassword)
        forgotPassword.anchor(top: errorMessageLabel.bottomAnchor,
                              left: view.leftAnchor,
                              bottom: nil,
                              right: view.rightAnchor,
                              paddingTop: 0,
                              paddingLeft: 0,
                              paddingBottom: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 20)
        view.addSubview(dummyBottomView)
        dummyBottomView.anchor(top: nil,
                               left: view.leftAnchor,
                               bottom: view.bottomAnchor,
                               right: view.rightAnchor,
                               paddingTop: 0,
                               paddingLeft: 0,
                               paddingBottom: 0,
                               paddingRight: 0,
                               width: 0,
                               height: 20)

        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil,
                          left: view.leftAnchor,
                          bottom: dummyBottomView.topAnchor,
                          right: view.rightAnchor,
                          paddingTop: 0,
                          paddingLeft: 0,
                          paddingBottom: 0,
                          paddingRight: 0,
                          width: 0,
                          height: 60)
    }

    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField,
                                                       passwordTextField,
                                                       loginButton,
                                                       errorMessageLabel,
                                                       fbLoginButton,
                                                       googleLoginButton])

        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually

        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 300)
    }
}
