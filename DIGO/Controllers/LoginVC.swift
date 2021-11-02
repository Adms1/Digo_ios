//
//  LoginVC.swift
//  DIGO
//
//  Created by ADMS on 21/10/21.
//

import UIKit
import MBProgressHUD
import Toaster
//import GoogleSignIn
//import FBSDKCoreKit
//import FBSDKLoginKit
//import Firebase
import Firebase
//import Firebase
import GoogleSignIn
//import FirebaseAuth
//import GoogleUtilities
import FacebookCore
import FBSDKCoreKit
import AuthenticationServices
import FBSDKLoginKit

class LoginVC: UITableViewController{

    // MARK: - IBOutlat
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var btnFLogin:UIButton!
    @IBOutlet weak var btnGLogin:UIButton!
    @IBOutlet weak var btnAllreadySign:UIButton!
    @IBOutlet weak var txtEmailMobile:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    var googleSignIn = GIDSignIn.sharedInstance

    var AccountType:String = ""
    var firstname:String = ""
    var lastname:String = ""

    var userData:GIDGoogleUser!

//    var fullName = ""
//    var givenName = ""
    var familyName = ""
    var email = ""

    var myString = ""
    var myMutableString = NSMutableAttributedString()

    override func viewDidLoad() {
        super.viewDidLoad()
//        btnAllreadySign.setAttributedTitle(NSLocalizedString("Digo_Login_member", comment: ""), for: .normal)
        self.txtEmailMobile.addTarget(nil, action:Selector("firstResponderAction:"), for:.editingDidEndOnExit)
        self.txtPassword.addTarget(nil, action:Selector("firstResponderAction:"), for:.editingDidEndOnExit)

        myString = NSLocalizedString("Digo_Login_member", comment: "")
        let str = NSLocalizedString("Digo_Diff_Login", comment: "")
        let str1 = NSLocalizedString("Digo_Diff1_Login", comment: "")

        let attrStri = NSMutableAttributedString.init(string:myString)
        let nsRange = NSString(string: myString).range(of: str, options: String.CompareOptions.caseInsensitive)

        let nsRange1 = NSString(string: myString).range(of: str1, options: String.CompareOptions.caseInsensitive)

        attrStri.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.init(name: "Georgia", size: 18.0) as Any], range: nsRange1)

        attrStri.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0) as Any], range: nsRange)


//        myMutableString = NSMutableAttributedString(
//                   string: myString,
//            attributes: [NSAttributedString.Key.font:
//                       UIFont(name: "Georgia", size: 18.0)!])
        btnAllreadySign.setTitleColor(.lightGray, for: .normal)
        btnAllreadySign.setAttributedTitle(attrStri, for: .normal)

        txtEmailMobile.addPadding(.left(10))
        txtPassword.addPadding(.left(10))

        btnLogin.layer.cornerRadius = btnLogin.layer.frame.height/2.0
        btnLogin.layer.masksToBounds = true

        btnFLogin.layer.cornerRadius = btnFLogin.layer.frame.height/2.0
        btnFLogin.layer.masksToBounds = true

        btnGLogin.layer.cornerRadius = btnGLogin.layer.frame.height/2.0
        btnGLogin.layer.masksToBounds = true

    }
    override func viewWillAppear(_ animated: Bool) {
        self.txtPassword.text = ""
        self.txtEmailMobile.text = ""
    }
    @objc func firstResponderAction()
    {
        self.view.endEditing(true)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height
    }
    // MARK: - @IBAction

    @IBAction func registerBtnClick(_ sender:UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerObj = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(registerObj, animated: true)
    }
    @IBAction func btnClickBack(_ sender:UIButton)
    {
//        self.navigationController?.popViewController(animated: false)
        exit(0);
    }
    @IBAction func btnClickLogin(_ sender:UIButton)
    {
        if validated() == true
        {
            loginApiCall()
        }
    }
    @IBAction func facebookLogin(){
        let fbLoginManager : LoginManager = LoginManager()

        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self)
        {
            (result, error) -> Void in
            if (error == nil)
            {
                //Bhargav Hide
                ////print(result,error)
                let fbloginresult : LoginManagerLoginResult = result!
                if result!.isCancelled
                {
                    return
                }

                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    //                self.getFBUserData()
                    self.fetchUserProfile()

                }
            }
        }
    }
    @IBAction func googleLogin()
    {
        self.googleAuthLogin()
    }
    func googleAuthLogin() {
        let googleConfig = GIDConfiguration(clientID: "380210908850-0c653qivjtf31e2bg16indq8unag4kk5.apps.googleusercontent.com")
        self.googleSignIn.signIn(with: googleConfig, presenting: self) { [self] user, error in
            if error == nil {
                guard let user = user else {
                    print("Uh oh. The user cancelled the Google login.")
                    return
                }
                userData = user

                let userId = user.userID ?? ""
                print("Google User ID: \(userId)")

                let userIdToken = user.authentication.idToken ?? ""
                print("Google ID Token: \(userIdToken)")

                let userFirstName = user.profile?.givenName ?? ""
                print("Google User First Name: \(userFirstName)")
                let userLastName = user.profile?.familyName ?? ""
                print("Google User Last Name: \(userLastName)")
                firstname = userFirstName

                let userEmail = user.profile?.email ?? ""
                print("Google User Email: \(userEmail)")

                let googleProfilePicURL = user.profile?.imageURL(withDimension: 150)?.absoluteString ?? ""
                print("Google Profile Avatar URL: \(googleProfilePicURL)")
                UserDefaults.standard.set(googleProfilePicURL, forKey: "ProfilePhoto")
                AccountType = "2"
                checkEmailDuplicateApiCall(userEmail:userEmail)
                

            }
        }
    }
    func fetchUserProfile()
    {
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id,name,email,first_name,last_name"])
        //        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET")

        graphRequest.start(completionHandler: { (connection, result, error) -> Void in

            if ((error) != nil)
            {
                //Bhargav Hide
                ////print("Error took place: \(error ?? "" as! Error)")
            }
            else
            {
                let json = result as! NSDictionary//JSON(result)

                //Bhargav Hide
                print("Print entire fetched result: \(result ?? 0)",json)

                let userId : NSString = json.value(forKey: "id") as! NSString

              //  self.fetchPost(userId: String(userId))
                //Bhargav Hide
                ////print("User ID is: \(userId)")


//                if let userName = json.value(forKey: "name") as? String
//                {
//                    self.firstname = userName
//                }
                if let userfirst_name = json.value(forKey: "first_name") as? String,let userlast_name = json.value(forKey: "last_name") as? String
                {
                    self.firstname = userfirst_name 
                }
//                if let userlast_name = json.value(forKey: "last_name") as? String
//                {
//                    self.familyName = userlast_name
//                }
                if let useremail = json.value(forKey: "email") as? String
                {
                    self.email = useremail
                }
//                if let user_mobile_phone = json.value(forKey: "user_mobile_phone") as? String
//                {
////                    email = useremail
//                    print("user_mobile_phone: ",user_mobile_phone)
//                }
                print("\(self.firstname) \n\(self.email)");

                if self.email != ""
                {
                UserDefaults.standard.set("http://graph.facebook.com/\(userId)/picture?type=large", forKey: "ProfilePhoto")
                    self.AccountType = "3"
                    self.checkEmailDuplicateApiCall(userEmail:self.email)
                }
            }
        })
    }
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }


}
extension LoginVC
{
    func validated() -> Bool
    {
        var valid: Bool = true

        let EmailMobile = txtEmailMobile.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Password =  txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)


        if EmailMobile == ""
        {
          //  self.view.makeToast(NSLocalizedString("Digo_error_msg1", comment: ""))
            let toast =  Toast(text: (NSLocalizedString("Digo_error_msg1", comment: "")), duration: 3.0)
            toast.show()


            valid = false
        }else if Password == ""
        {
            let toast =  Toast(text: (NSLocalizedString("Digo_error_msg2", comment: "")), duration: 3.0)
            toast.show()

          //  self.view.makeToast(NSLocalizedString("Digo_error_msg2", comment: ""))
            valid = false
        }
        return valid
    }
}
// MARK: - ApiCalling
extension LoginVC{
    func loginApiCall()
    {

        MBProgressHUD.showAdded(to: self.view, animated: true)

        guard let emailMobile = txtEmailMobile.text, let password = txtPassword.text  else {
            return
        }
        var params = [String : Any]()
        params = ["EmailID":emailMobile,"Password":password]

        ApiHttpUtility.sharedUHttp.callPostHttpUtility(urlString: API.UserLogin, params: params) { (responceJson) in
            if(responceJson["status"] == "true")
            {
                MBProgressHUD.hide(for: self.view, animated: true)

                print("user login status",responceJson["status"])
                print("user login responce",responceJson["data"])
//                UserDefaults.standard.set(responceJson, forKey: "userLogin")
                let jsonArray = responceJson["data"].dictionaryObject!
                UserDefaults.standard.set(jsonArray, forKey: "logindata")
                UserDefaults.standard.set("1", forKey: "isLogin")

                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.PushTLoginViewController()


                let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController

        //                    let rootVC = storyboard.instantiateViewController(withIdentifier: select_CV) as UIViewController


                let frontNavigationController = UINavigationController(rootViewController: rootVC)
                appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                appDelegate.window?.rootViewController = frontNavigationController
                appDelegate.window?.makeKeyAndVisible()

            }else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        } errorComplition: { (errorMessage) in
            MBProgressHUD.hide(for: self.view, animated: true)
          //  self.view.makeToast(errorMessage, duration: 3.0, position: .bottom)
            let toast =  Toast(text: errorMessage, duration: 3.0)
            toast.show()

        }
    }
    func checkEmailDuplicateApiCall(userEmail:String)
    {
//        guard let email = txtEmail.text else {
//            return
//        }
        var params = [String : Any]()
        params = ["EmailID":userEmail]

        ApiHttpUtility.sharedUHttp.callApiEmailCheckPostHttpUtility(urlString: API.CheckEmailDuplicate, params: params) { [self] (responceJson) in
            if(responceJson["status"] == "true")
            {
                MBProgressHUD.hide(for: self.view, animated: true)

                print("checkEmail is duplicate or not",responceJson["status"])


                print("user login status",responceJson["status"])
                print("user login responce",responceJson["data"])
//                UserDefaults.standard.set(responceJson, forKey: "userLogin")
                let jsonArray = responceJson["data"].dictionaryObject!
                UserDefaults.standard.set(jsonArray, forKey: "logindata")
                UserDefaults.standard.set("1", forKey: "isLogin")

                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.PushTLoginViewController()


                let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController

        //                    let rootVC = storyboard.instantiateViewController(withIdentifier: select_CV) as UIViewController


                let frontNavigationController = UINavigationController(rootViewController: rootVC)
                appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                appDelegate.window?.rootViewController = frontNavigationController
                appDelegate.window?.makeKeyAndVisible()


//                self.view.makeToast("email is already registered", duration: 3.0, position: .bottom)
            }else
            {
//                MBProgressHUD.hide(for: self.view, animated: true)
                self.registerApiCall(AccountType: AccountType, userEmail: userEmail)
            }
        } errorComplition: { (errorMessage) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(errorMessage, duration: 3.0, position: .bottom)
        }
    }
    func registerApiCall(AccountType:String,userEmail:String)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)

//        guard let first = firstname, let mobile = random(digits: 10) ,let email = userEmail,let password = "" else {
//            return
//        }
        var params = [String : Any]()
        params = ["FirstName":firstname,"LastName":"","Mobile":random(digits: 10),"EmailID":userEmail,"Password":"","AccountType":AccountType,"IsActive":"true"]

        ApiHttpUtility.sharedUHttp.callPostHttpUtility(urlString: API.AddCustomer, params: params) { (responceJson) in
            if(responceJson["status"] == "true") {
                MBProgressHUD.hide(for: self.view, animated: true)

//                print("register user status",responceJson["status"])
//                self.navigationController?.popViewController(animated: true)

//                print("user login status",responceJson["status"])
//                print("user login responce",responceJson["data"])
//                UserDefaults.standard.set(responceJson, forKey: "userLogin")
//                let jsonArray = responceJson["data"].dictionaryObject!

                var userLoginData = [String:Any]()

                userLoginData["FirstName"] = self.firstname 
                userLoginData["Email"] = userEmail
                userLoginData["AccountTypeID"] = AccountType
                userLoginData["CustomerID"] = "\(responceJson["data"])"
                userLoginData["Mobile"] = ""
                userLoginData["IsActive"] = "true"


                UserDefaults.standard.set(userLoginData, forKey: "logindata")
                UserDefaults.standard.set("1", forKey: "isLogin")

                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.PushTLoginViewController()


                let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController

        //                    let rootVC = storyboard.instantiateViewController(withIdentifier: select_CV) as UIViewController


                let frontNavigationController = UINavigationController(rootViewController: rootVC)
                appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                appDelegate.window?.rootViewController = frontNavigationController
                appDelegate.window?.backgroundColor = UIColor.white
                appDelegate.window?.makeKeyAndVisible()

            }else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        } errorComplition: { (errorMessage) in
            MBProgressHUD.hide(for: self.view, animated: true)
            let toast =  Toast(text: errorMessage, duration: 3.0)
          //  ToastView.appearance().font = .boldSystemFont(ofSize: 18)
            toast.show()
           // self.view.makeToast(errorMessage, duration: 3.0, position: .bottom)
        }
    }
}
