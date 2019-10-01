//
//  User.swift
//  AmplifyUserAuthentication1
//
//  Created by Law, Michael on 9/29/19.
//  Copyright © 2019 lawmicha. All rights reserved.
//

struct User {
    let name: String
    let phoneNumber: String
    let email: String
    init(_ userAttributes: [String: String]) {
        self.email = userAttributes[EmailUserAttributeKey] ?? ""
        self.name = userAttributes[NameUserAttributeKey] ?? ""
        self.phoneNumber = userAttributes[PhoneNumberUserAttributeKey] ?? ""
    }
}
