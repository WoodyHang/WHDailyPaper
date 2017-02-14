//
//  RegistViewController.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/5/17.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class RegistViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var back1ImageView: UIImageView!
    @IBOutlet weak var backImageView: UIView!
    @IBOutlet weak var codesTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBAction func sendMessagePress(sender: UIButton) {
        if (self.phoneNumberTF.text?.isEmpty) == true {
            SVProgressHUD.showErrorWithStatus("手机号不能为空")
        }else if self.phoneNumberTF.text?.characters.count != 11 {
            SVProgressHUD.showErrorWithStatus("手机号格式错误")
        }else {
            sender.enabled = false
            ///获取验证码
            BmobSMS.requestSMSCodeInBackgroundWithPhoneNumber(self.phoneNumberTF.text, andTemplate: "", resultBlock: { (number:Int32, error:NSError!) -> Void in
                if error != nil {
                    SVProgressHUD.showErrorWithStatus(error.localizedDescription)
                }else {
                    
                    ///请求成功
                    SVProgressHUD.showSuccessWithStatus("发送成功")
                    sender.enabled = true
                }
            })
        }
        
    }
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBAction func registBtnClicked(sender: UIButton) {
        //判断验证码是否正确
//        BmobSMS.verifySMSCodeInBackgroundWithPhoneNumber(self.phoneNumberTF.text, andSMSCode: self.codesTF.text) { (isSuccessful:Bool, error:NSError!) -> Void in
//            if isSuccessful == true {
                ///创建一个用户对象
                let user:BmobUser = BmobUser()
                ///设置用户的帐号和密码
                user.username = self.userNameTF.text
                user.password = self.pwdTF.text
                user.mobilePhoneNumber = self.phoneNumberTF.text
        user.updateInBackgroundWithResultBlock { (isSucessful:Bool, error:NSError!) -> Void in
            if isSucessful == false {
                SVProgressHUD.showErrorWithStatus(error.localizedDescription)
            }
        }
                if self.emailTF.text?.characters.count > 0 {
                    user.email = self.emailTF.text
//                    NSUserDefaults.standardUserDefaults().setObject(self.emailTF.text, forKey: "email")
                    
                }
                //如果填写有邮箱，会自动给油箱发送一条验证邮件
                user.signUpInBackgroundWithBlock { (isSuccessful:Bool, error:NSError!) -> Void in
                    if isSuccessful {
                        SVProgressHUD.showSuccessWithStatus("注册成功")
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                            var userInfo:[String:String] = [:]
                            userInfo["password"] = self.pwdTF.text!
                            userInfo["email"] = self.emailTF.text!
                            NSNotificationCenter.defaultCenter().postNotificationName("sendValue", object: nil, userInfo: userInfo)
                            self.dismissViewControllerAnimated(false, completion: nil)
                        })
                    }else {
                        SVProgressHUD.showErrorWithStatus(error.localizedDescription)
                    }
                    
//                }

//            }else {
//                SVProgressHUD.showErrorWithStatus(error.localizedDescription)
//            }
        }
    }
    @IBOutlet weak var registBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBAction func backBtn(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIWindow().backgroundColor = UIColor.whiteColor()
        registBtn.layer.cornerRadius = 11
        checkTextFields()
        self.userNameTF.delegate = self
        self.phoneNumberTF.delegate = self
        self.codesTF.delegate = self
        self.pwdTF.delegate = self
        self.emailTF.delegate = self
        //textFieldMoveWhileKeyboardAppearOrDismiss()
        self.touchInViewHideKeyboard()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkTextFields", name: UITextFieldTextDidChangeNotification, object: userNameTF)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkTextFields", name: UITextFieldTextDidChangeNotification, object: pwdTF)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkTextFields", name: UITextFieldTextDidChangeNotification, object: codesTF)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkTextFields", name: UITextFieldTextDidChangeNotification, object: phoneNumberTF)
        // Do any additional setup after loading the view.
    }
    func checkTextFields(){
        if (self.userNameTF.text?.characters.count > 0&&self.pwdTF.text?.characters.count > 0&&self.phoneNumberTF.text?.characters.count > 0&&self.codesTF.text?.characters.count > 0){
            self.registBtn.enabled = true
        }else {
            self.registBtn.enabled = false
        }
    }
    ///键盘弹出时上移，消失时回到原来位置
//    func textFieldMoveWhileKeyboardAppearOrDismiss(){
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showKeyboard:", name: UIKeyboardDidShowNotification, object: nil )
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideKeyboard:", name: UIKeyboardDidHideNotification, object:nil)
//        
//    }
//    ///键盘弹出，上移视图
//    func showKeyboard(notif:NSNotification){
//        ///获取键盘弹出的动画时间
//        let animationDuration = notif.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! CGFloat
//        UIView.animateWithDuration(NSTimeInterval(animationDuration)) { () -> Void in
//            var rect = self.view.frame
//            rect.origin.y  = -100
//            self.view.frame = rect
//        }
//    }
//    ///键盘消失，视图回到原地
//    func hideKeyboard(notif:NSNotification) {
//        ///获取键盘弹出的动画时间
//        let animationDuration = notif.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! CGFloat
//        UIView.animateWithDuration(NSTimeInterval(animationDuration)) { () -> Void in
//            var rect = self.view.frame
//            rect.origin.y  = 0
//            self.view.frame = rect
//                                }
//        
//    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
