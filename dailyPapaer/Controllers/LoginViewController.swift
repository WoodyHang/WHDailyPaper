//
//  LoginViewController.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/5/17.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class LoginViewController: SuperViewController,UITextFieldDelegate {
    @IBAction func weiboLoginBtn(sender: UIButton) {
        ///微博登录
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("OAuthViewController") as! OAuthViewController
        self.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
   
    @IBAction func loginBtnPress(sender: UIButton) {
        sender.userInteractionEnabled = false
        SVProgressHUD.showWithStatus("登录中。。。。", maskType: SVProgressHUDMaskType.Black)
        BmobUser.loginWithUsernameInBackground(self.phoneNumberTF.text, password: self.pwdTF.text) { (user:BmobUser!, error:NSError!) -> Void in
            sender.userInteractionEnabled = true
            if ((user) != nil){
                SVProgressHUD.showSuccessWithStatus("登录成功")
                ///把手机号 密码存进本地,邮箱
//                let phoneNumber = self.phoneNumberTF.text
//                let password = self.pwdTF.text
                let isLogin = true
//                let userName = user.username
//                NSUserDefaults.standardUserDefaults().setObject(phoneNumber, forKey: "phoneNumber")
//                NSUserDefaults.standardUserDefaults().setObject(password, forKey: "passWord")
                NSUserDefaults.standardUserDefaults().setObject(isLogin, forKey: "isLogin")
//                NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "userName")
            NSNotificationCenter.defaultCenter().postNotificationName("refreshUserMsg", object: nil)
                ///更新栏目中心页面的section ＝＝ 0 的UI
                NSNotificationCenter.defaultCenter().postNotificationName("refreshMyFocus", object: nil)

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                    self.dismissViewControllerAnimated(false, completion: nil)
            })
            }else {
                SVProgressHUD.showErrorWithStatus("帐号或密码错误")
            }
        }
    }
    @IBOutlet weak var loginBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavigatinBar(false)
        loginBtn.layer.cornerRadius = 11
        self.title = "登录"
        self.phoneNumberTF.delegate = self
        self.pwdTF.delegate = self
        getNotification()
        checkTextFields()
        self.touchInViewHideKeyboard()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkTextFields", name: UITextFieldTextDidChangeNotification, object:phoneNumberTF)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkTextFields", name: UITextFieldTextDidChangeNotification, object: pwdTF)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

    }
///接收通知
    func getNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTextField:", name: "sendValue", object: nil)
    }
    func updateTextField(notif:NSNotification){
        self.loginBtn.enabled = true
//        let user:BmobUser = BmobUser()
        let user = BmobUser.getCurrentUser()
        self.phoneNumberTF.text = user.mobilePhoneNumber
        self.pwdTF.text = notif.userInfo!["password"] as? String
        ///邮箱
        NSUserDefaults.standardUserDefaults().setObject(notif.userInfo!["email"] as? String, forKey: "email")
    }
    func checkTextFields(){
        if (self.phoneNumberTF.text?.characters.count > 0&&self.pwdTF.text?.characters.count > 0){
            self.loginBtn.enabled = true
        }else {
            self.loginBtn.enabled = false
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
