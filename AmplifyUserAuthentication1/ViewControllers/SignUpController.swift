//
//  SignUpController.swift
//  AmplifyUserAuthentication1
//
//  Created by Law, Michael on 9/29/19.
//  Copyright © 2019 lawmicha. All rights reserved.
//

import UIKit
import AWSMobileClient

class SignUpController: UIViewController {

    // MARK: UIComponents

    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)

        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()

    let firstNameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "First Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)

        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()

    let lastNameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last Name"
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

    let phoneNumberField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phone Number"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)

        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)

        button.backgroundColor = LightColor

        let myColor = UIColor.red
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)

        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)

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


    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: DarkColor
            ]))

        button.setAttributedTitle(attributedTitle, for: .normal)

        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()

    let dummyBottomView: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: Handlers

    @objc func handleTextInputChange() {

        let isFormValid = emailTextField.text?.count ?? 0 > 0
            && firstNameField.text?.count ?? 0 > 0
            && lastNameField.text?.count ?? 0 > 0
            && phoneNumberField.text?.count ?? 0 > 0
            && passwordTextField.text?.count ?? 0 > 0

        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = DarkColor

        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = LightColor
        }

    }

    @objc func handleSignUp() {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let firstName = firstNameField.text, firstName.count > 0 else { return }
        guard let lastName = lastNameField.text, lastName.count > 0 else { return }
        guard let phoneNumber = phoneNumberField.text, phoneNumber.count > 0 else { return }
        guard let password = passwordTextField.text, password.count  > 0 else { return }
        errorMessageLabel.text = ""

        let userAttributes = [EmailUserAttributeKey: email,
                              NameUserAttributeKey: firstName + " " + lastName,
                              PhoneNumberUserAttributeKey: phoneNumber]
        AWSMobileClient.default().signUp(username: email,
                                         password: password,
                                         userAttributes: userAttributes) { (signUpResult, error) in

            if let error = error as? AWSMobileClientError {
                print(error)
                DispatchQueue.main.async {
                    self.errorMessageLabel.text = error.message
                }
                return
            }

            if let signUpResult = signUpResult {
                switch(signUpResult.signUpConfirmationState) {
                case .confirmed:
                    print("User is signed up and confirmed.")
                case .unconfirmed:
                    print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")

                    DispatchQueue.main.async {
                        let confirmCodeController = ConfirmCodeController()
                        confirmCodeController.confirmCodeSource = ConfirmCodeSource.confirmSignUp(username: email,
                                                                                                  password: password)
                        self.navigationController?.pushViewController(confirmCodeController, animated: true)
                    }

                case .unknown:
                    print("Unexpected case")
                }
            }
        }
    }

    @objc func handleAlreadyHaveAccount() {
        print("handleAlreadyHaveAccount")
        _ = navigationController?.popViewController(animated: true)
    }

    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupInputFields()

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

        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil,
                                        left: view.leftAnchor,
                                        bottom: dummyBottomView.topAnchor,
                                        right: view.rightAnchor,
                                        paddingTop: 0,
                                        paddingLeft: 0,
                                        paddingBottom: 0,
                                        paddingRight: 0, width: 0, height: 80)
    }

    fileprivate func setupInputFields() {

        let stackView = UIStackView(arrangedSubviews: [emailTextField,
                                                       firstNameField,
                                                       lastNameField,
                                                       passwordTextField,
                                                       phoneNumberField,
                                                       signUpButton,
                                                       errorMessageLabel])

        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10

        view.addSubview(stackView)

        stackView.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         bottom: nil,
                         right: view.rightAnchor,
                         paddingTop: 50, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 400)
    }

}



