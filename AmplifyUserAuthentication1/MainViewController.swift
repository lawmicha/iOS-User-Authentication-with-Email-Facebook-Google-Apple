//
//  ViewController.swift
//  AmplifyUserAuthentication1
//
//  Created by Law, Michael on 9/29/19.
//  Copyright © 2019 lawmicha. All rights reserved.
//

import UIKit
import AWSMobileClient

class MainViewController: UIViewController {

    // MARK: UI Components

    let stateLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let identityIdLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.backgroundColor = LightColor

        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)

        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)

        button.isEnabled = false

        return button
    }()

    

    let updateEmail: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update Email", for: .normal)
        button.backgroundColor = LightColor

        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)

        button.addTarget(self, action: #selector(handleUpdateEmail), for: .touchUpInside)

        button.isEnabled = false

        // TODO: are we able to update the username?
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

    let showLoginOrSignUpButton: UIButton = {
        let button = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: "Login or Sign up?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        attributedTitle.append(NSAttributedString(string: "Click here", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: DarkColor
            ]))

        button.setAttributedTitle(attributedTitle, for: .normal)

        button.addTarget(self, action: #selector(handleShowLoginOrSignUpButton), for: .touchUpInside)
        return button
    }()
    
    let dummyBottomView: UIView = {
        let view = UIView()
        return view
    }()

    
    // MARK: Handlers

    @objc func handleLogout() {
        print("handleLogout")
        //AWSMobileClient.default().signOut()

        AWSMobileClient.default().signOut(options: SignOutOptions(invalidateTokens: true)) { (error) in
            if let error = error {
                print("Error signOut: \(error.localizedDescription)")
                return
            }

            print("Completed signout")
            DispatchQueue.main.async {
                self.setupViewController()
            }
            
        }

    }

    @objc func handleShowLoginOrSignUpButton() {
        let loginController = LoginController()
        let navController = UINavigationController(rootViewController: loginController)
        self.present(navController, animated: true, completion: nil)
    }

    

    @objc func handleUpdateEmail() {
        guard let username = AWSMobileClient.default().username else { return }

        //
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
        view.addSubview(showLoginOrSignUpButton)
        showLoginOrSignUpButton.anchor(top: nil,
                                       left: view.leftAnchor,
                                       bottom: dummyBottomView.topAnchor,
                                       right: view.rightAnchor,
                                       paddingTop: 0,
                                       paddingLeft: 0,
                                       paddingBottom: 0,
                                       paddingRight: 0,
                                       width: 0,
                                       height: 60)

        AWSMobileClient.default().initialize { (userState, error) in
            guard error == nil else {
                print("Error initializing AWSMobileClient. Error: \(error!.localizedDescription)")
                return
            }
            guard let userState = userState else {
                print("userState is unexpectedly empty initializing AWSMobileClient")
                return
            }

            print("AWSMobileClient initialized")
            DispatchQueue.main.async {
                if userState == UserState.signedOut || userState == UserState.guest {

                    DispatchQueue.main.async {
                        let loginController = LoginController()
                        let navController = UINavigationController(rootViewController: loginController)

                        self.present(navController, animated: true, completion: nil)
                    }
                }

                self.setupViewController()
            }
        }

    }

    fileprivate func setupInputFields() {

        let stackView = UIStackView(arrangedSubviews: [stateLabel,
                                                       identityIdLabel,
                                                       logoutButton,
                                                       updateEmail,
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

    func setupViewController() {
        print("UserState is \(AWSMobileClient.default().currentUserState)")
        self.errorMessageLabel.text = ""
        self.stateLabel.text = "UserState is \(AWSMobileClient.default().currentUserState)"
        setIdentityIdLabel()

        checkifSignedIn()
    }

    func setUpStateLabel() {

    }

    func setIdentityIdLabel() {
        AWSMobileClient.default().getIdentityId().continueWith { (task) -> Any? in
            if let error = task.error {
                print("Error getIdentityId: ", error)
                DispatchQueue.main.async {
                    self.errorMessageLabel.text = "Error getIdentityId: \(error.localizedDescription)"
                }
                return nil
            }

            guard let identityId = task.result else {
                print("Could not unwrap identityId")
                DispatchQueue.main.async {
                    self.errorMessageLabel.text = "Could not unwrap identityId"
                }
                return nil
            }


            DispatchQueue.main.async {
                print("IdentityId: \(identityId)")
                self.identityIdLabel.text = "IdentityId: \(identityId)"
            }

            return nil
        }
    }

    func checkifSignedIn() {
        toggleInputs(isSignedIn: AWSMobileClient.default().isSignedIn)

        if AWSMobileClient.default().isSignedIn {

            AWSMobileClient.default().getUserAttributes { (userAttributes, error) in
                if let error = error {
                    print("Failed to get user attributes:", error)
                    DispatchQueue.main.async {
                        self.errorMessageLabel.text = "Failed to get user attributes: \(error.localizedDescription)"
                    }
                    return
                }

                guard let userAttr = userAttributes else {
                    print("Could not unwrap user attributes")
                    DispatchQueue.main.async {
                        self.errorMessageLabel.text = "Could not unwrap user attributes"
                    }
                    return
                }

                print(userAttr)
                let user = User(userAttr)

                DispatchQueue.main.async {
                    self.stateLabel.text = "Hello, \(user.name)! "
                }
            }
        }
    }


    func toggleInputs(isSignedIn: Bool) {
        if isSignedIn {
            logoutButton.isEnabled = true
            logoutButton.backgroundColor = DarkColor
            updateEmail.isEnabled = true
            updateEmail.backgroundColor = DarkColor
        } else {
            logoutButton.isEnabled = false
            logoutButton.backgroundColor = LightColor
            updateEmail.isEnabled = false
            updateEmail.backgroundColor = LightColor
        }
    }
}
