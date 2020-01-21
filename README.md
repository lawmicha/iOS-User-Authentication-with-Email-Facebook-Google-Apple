
## iOS User Authentication with Email/Facebook/Google/Apple

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
- Add Amazon sign in button
- Add Apple sign in button
- Display email as username for logged in federated users from the user attributess
- Code clean up (move color constant over to UIColor extension, and others)
- Replace views with SwiftUI components
- Allow configuraiton/customizable to change color, hide unused buttons, etc.

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
```

Next question asks you what is your redirect signin URI, this is the namespace for your app and will have to match `info.plist` values later inside the app to be able to successfully redirect back into the app after signing in or out with the hosted UI social providers.
```
 Enter your redirect signin URI: myapp://
? Do you want to add another redirect signin URI No
 Enter your redirect signout URI: myapp://
? Do you want to add another redirect signout URI No
 Select the social providers you want to configure for your user pool: Facebook, Google
```


You will now see this:
```  
 You've opted to allow users to authenticate via Facebook.  If you haven't already, you'll need to go to https://developers.facebook.com and create an App ID. 

 Enter your Facebook App ID for your OAuth flow:  xxxxxxxxxxxxxx
 Enter your Facebook App Secret for your OAuth flow:  xxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
To get the Facebook App Id/Secret, follow https://aws-amplify.github.io/docs/ios/authentication#setting-up-oauth-with-facebook

After creating a new App, get the AppID and Secret and go back to the CLI to enter them. Keep the page open for later steps.


After entering the facebook AppID/secret, you'll see the prompt for Google's.

```
 You've opted to allow users to authenticate via Google.  If you haven't already, you'll need to go to https://developers.google.com/identity and create an App ID. 
 
 Enter your Google Web Client ID for your OAuth flow:  xxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com
 Enter your Google Web Client Secret for your OAuth flow:  xxxxxxxxxxxxxxxxxx

 
```
To get Google Web Client ID/Secret, follow https://aws-amplify.github.io/docs/ios/authentication#setting-up-oauth-with-google

Once you have created the new Credentials, enter the ID and Secret. Keep the page open for later steps. Then you will see:
```
Successfully added resource amplifyuserauthentic88888888 locally
```

4. Run `amplify push`, wait a few minutes, and you should see `awsconfiguration.json` file populated and find your Hosted UI Endpoint at the end of the output

```
Hosted UI Endpoint: https://xxxxxxxxxxxxxxxxxxxxxxx-xxxxxxxx-devo.auth.us-east-1.amazoncognito.com/
Test Your Hosted UI Endpoint: https://xxxxxxxxxxxxxxxxxxxxxxx-xxxxxxxx-devo.auth.us-east-1.amazoncognito.com/login?response_type=code&client_id=moi39stkfecjithdddfcgl7kv&redirect_uri=myapp://
```


5. Take your hosted UI domain Endpoint and follow these steps for Facebook.

Facebook https://aws-amplify.github.io/docs/ios/authentication#setting-up-hosted-ui-domain-with-facebook

- Go back to the Facebook App, Add a new platform "Website", add the Site URL to be the Hosted UI Endpoint + `/oauth2/idpresponse`. Save changes.
- Near the top, type in your Hosted UI Endpoint under `App Domains` and Save
- Then on the left side, choose `Products`, `Facebook login`, then skip the Quick Start and click on Settings on the left, underneath Facebook Login. Then under `Valid OAuth Redirect URIs` type in the Site URL again (hosted UI Endpoint  + `/oauth2/idpresponse`). Save.

6. Follow these steps for Google https://aws-amplify.github.io/docs/ios/authentication#setting-up-hosted-ui-domain-with-google

- It should link you to https://developers.google.com/identity/sign-in/web/sign-in and click `Configure a project`, type in a new project name, product name, and select `Web Browser` from the drop down.
- Go back to `https://console.developers.google.com/apis/credentials` and select the `OAuth 2.0 client IDs` that you created in the very first step, and click edit. Under `Authorized Javascript origins` click `ADD URI`, under URIs add the Hosted UI Endpoint (just the domain). Under `Authorized redirect URIs` add the Hosted UI Endpoint + `/oauth2/idpresponse`.


7. Open the workspace file with `open AmplifyUserAuthentication1.xcworkspace`. Navigate to `info.plist` and update the value under `URL types/Item 0/URL Schemes/Item 0` to the redirect SignIn/SignOut URI. 
- `awsconfiguration.json` has configuration information such as the Cognito Identity/UserPool/OAuth, etc.

8. Build and run the project, sign in with Google.

9. Run `amplify console auth` to open your user pools. In Cognito User Pools -> Manage user pools -> <your user pool> -> Users and Groups -> You will see one user that is authenticated with Google.

10. Click Logout and Sign in with Facebook. Now refresh the AWS Console to see the second user created.


## Apple Sign in

Follow the steps here:
https://aws.amazon.com/blogs/security/how-to-set-up-sign-in-with-apple-for-amazon-cognito/

After you are done, go back to the app, and click on Sign in With Apple


## Normal Login Email Stuff
11. Sign up with email. note, phone number has to be in the format of "+12344321111", unless we do some client side work to prepend the "+1".

12. Login with incorrect password, the 'forgot password' button will appear and allow the user to trigger the verification code to be sent to the email. If the user enters the code, they will be prompt with entering a new password.

13. Other options can be updated using `amplify update auth` like the password requirements, etc.
