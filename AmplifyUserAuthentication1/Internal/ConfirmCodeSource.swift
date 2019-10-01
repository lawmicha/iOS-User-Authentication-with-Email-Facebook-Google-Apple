//
//  ConfirmCodeSource.swift
//  AmplifyUserAuthentication1
//
//  Created by Law, Michael on 9/29/19.
//  Copyright © 2019 lawmicha. All rights reserved.
//

import Foundation

enum ConfirmCodeSource {
    case forgotPassword(username: String)
    case confirmSignUp(username: String, password: String)
}
