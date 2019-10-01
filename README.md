
## iOS User Authentication with Email/Facebook/Google

This is a template app that can be bootstrapped using your own backend resources created with Amplify CLI.

### What is it?
- AWS Amplify CLI version used: 3.9.0
- iOS 13
- Xcode 11
- SDKs Used: AWSMobileClient with HostedUI
- Backend services: AWS Cognito
- View layer: UIKit; programmatic views

### Completed Features
- Sign up using email (email as username), first name, last name, password, and phone number 
- Confirm the account using the code sent via email 
- Login using the email and password 
- Login with social providers (facebook and google) via HostedUI. This creates a user in the cognito userpool
- Logout 
- Forgot password using username (which is email) 
- Enter the code sent to the email and enter a new password 
- Fail to sign up with an email that has already been taken (broken for gmail accounts by adding periods in email) 

![](demo.gif)

### Backlog
- Facebook and Google buttons should conform to their respective designs
- Code clean up
- Display email as username for logged in federated users from the user attributess
- Other clean up

## Steps to get the app running

1. Install dependencies with `pod install`

2. Run `amplify init` and choose `ios` for the type of app you're building

3. Add auth `amplify add auth`

```
Using service: Cognito, provided by: awscloudformation
 
 The current configured provider is Amazon Cognito. 
 
 Do you want to use the default authentication and security configuration? Default configuration with Social Provider (Federation)
 Warning: you will not be able to edit these selections. 
 How do you want users to be able to sign in? Email
 Do you want to configure advanced settings? Yes, I want to make some additional changes.
 Warning: you will not be able to edit these selections. 
 What attributes are required for signing up? (Press <space> to select, <a> to toggle all, <i> to invert selection)Email
 Do you want to enable any of the following capabilities? (Press <space> to select, <a> to toggle all, <i> to invert selection)
 What domain name prefix you want us to create for you? amplifyuserauthentic88888888-88888888
 Enter your redirect signin URI: myapp://
? Do you want to add another redirect signin URI No
 Enter your redirect signout URI: myapp://
? Do you want to add another redirect signout URI No
 Select the social providers you want to configure for your user pool: Facebook, Google
  
 You've opted to allow users to authenticate via Facebook.  If you haven't already, you'll need to go to https://developers.facebook.com and create an App ID. 
 
 Enter your Facebook App ID for your OAuth flow:  xxxxxxxxxxxxxx
 Enter your Facebook App Secret for your OAuth flow:  xxxxxxxxxxxxxxxxxxxxxxxxxxxx
  
 You've opted to allow users to authenticate via Google.  If you haven't already, you'll need to go to https://developers.google.com/identity and create an App ID. 
 
 Enter your Google Web Client ID for your OAuth flow:  xxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com
 Enter your Google Web Client Secret for your OAuth flow:  xxxxxxxxxxxxxxxxxx
Successfully added resource amplifyuserauthentic88888888 locally
 
```

To get the Facebook App Id/Secret, follow https://aws-amplify.github.io/docs/ios/authentication#setting-up-oauth-with-facebook

To get Google Web Client ID/Secret, follow https://aws-amplify.github.io/docs/ios/authentication#setting-up-oauth-with-google

4. Run `amplify push`, wait a few minutes, and you should see `awsconfiguration.json` file populated and find your Hosted UI Endpoint at the end of the output

```
Hosted UI Endpoint: https://xxxxxxxxxxxxxxxxxxxxxxx-xxxxxxxx-devo.auth.us-east-1.amazoncognito.com/
Test Your Hosted UI Endpoint: https://xxxxxxxxxxxxxxxxxxxxxxx-xxxxxxxx-devo.auth.us-east-1.amazoncognito.com/login?response_type=code&client_id=moi39stkfecjithdddfcgl7kv&redirect_uri=myapp://
```

5. Take your hosted UI domain Endpoint and follow these steps

Facebook https://aws-amplify.github.io/docs/ios/authentication#setting-up-hosted-ui-domain-with-facebook

Google https://aws-amplify.github.io/docs/ios/authentication#setting-up-hosted-ui-domain-with-google

6. Open the workspace file with `open AmplifyUserAuthentication1.xcworkspace`

7. Build and run the project, sign in with Facebook/Google

8. Check out your users in AWS Console -> Cognito -> Manage user pools -> <your user pool> -> Users and Groups

Your userpool can be found in amplify/backend/amplify-meta.json, in "UserPoolName"

You can also check out the Attribute Mapping tab to see the mapping used for Facebook/Google to create a Cognito User after social sign-in

9. Sign up with email. note, phone number has to be in the format of "+12344321111", unless we do some client side work to prepend the "+1".

10. Login with incorrect password, the 'forgot password' button will appear and allow the user to trigger the verification code to be sent to the email. If the user enters the code, they will be prompt with entering a new password.

11. Other options can be updated using `amplify update auth` like the password requirements, etc.
