
## iOS User Authentication with Email/Facebook/Google - AWS Amplify CLI - AWSMobileClient - HostedUI - UIKit

This is a template app that can be bootstrapped using your own backend resources created with Amplify CLI.

### What is it?
- Amplify CLI version used: 3.9.0
- iOS 13
- Xcode 11
- SDKs Used: AWSMobileClient with HostedUI
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

### GIF

### Backlog

#### Setup Tutorial

1. Install dependencies with `pod install`

2. Run `amplify init` and choose `ios` for the type of app you're building

3. Add auth `amplify add auth`

```
What do you want to do? Apply default configuration with Social Provider (Federation)
 What domain name prefix you want us to create for you? amplifyuserauthentic98b7826f-98b7826f
 Enter your redirect signin URI: myapp://
? Do you want to add another redirect signin URI No
 Enter your redirect signout URI: myapp://
? Do you want to add another redirect signout URI No
 Select the identity providers you want to configure for your user pool: Facebook, Google
 
 You've opted to allow users to authenticate via Facebook.  If you haven't already, you'll need to go to https://developers.facebook.com and create an App ID. 
 
 Enter your Facebook App ID for your OAuth flow:  
 Enter your Facebook App Secret for your OAuth flow:  
  
 You've opted to allow users to authenticate via Google.  If you haven't already, you'll need to go to https://developers.google.com/identity and create an App ID. 
 
 Enter your Google Web Client ID for your OAuth flow:  
 Enter your Google Web Client Secret for your OAuth flow:  
 
```
Follow docs to get the App ID/App Secret/Web Client ID/Web Client Secret here : https://aws-amplify.github.io/docs/ios/authentication

4. Run `amplify push`, you should see the `awsconfiguration.json` file created

5. Now `amplify status` or previous output will show the user pool domain, use that back in the social providers app developer side


Steps 6 to 8 may be possible through Amplify CLI instead of manually mapping.

6. Go to AWS Console -> Cognito -> <your user pool> -> Attribute Mapping

7. Update Facebook's mapping to 

```
capture Facebook email as Email
capture Facebook name as name

```

8. Update Google's mapping to

5. Open the workspace file with `open AmplifyUserAuthentication1.xcworkspace`

6. Build and run the project

