//
//  SettingViewController.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/5/12.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    @IBOutlet weak var accountCell: UITableViewCell!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        ///判断是否已经登录过
        if NSUserDefaults.standardUserDefaults().objectForKey("isLogin") == nil {
            ///没有登录过,要经过登录页
            self.accountCell!.textLabel!.text = "登录或注册"
            
        }else{
            ///登录过,下次直接进入帐号设置页
            self.accountCell.textLabel?.text = "帐号设置"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigatinBar()
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGrayColor()
        self.title = "设置"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userRefresh:", name: "refreshUserMsg", object: nil)
        }
    ///增加导航栏,并添加导航项
    func addNavigatinBar(){
        let backButton = UIButton()
        backButton.frame = CGRectMake(0, 0, 30, 30)
        backButton.addTarget(self, action: "backBtnClicked:", forControlEvents: UIControlEvents.TouchDown)
        backButton.setImage(UIImage(named: "back"), forState: .Normal)
        let leftButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    func backBtnClicked(sender:UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func userRefresh(notif:NSNotification){
        self.accountCell.textLabel?.text = "帐号设置"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            if self.accountCell.textLabel?.text == "登录或注册"{
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController")
            self.presentViewController(UINavigationController(rootViewController: vc!), animated: true, completion: nil)
            }else {
                ///帐号设置页
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AccountSettingController")
                self.presentViewController(UINavigationController(rootViewController: vc!), animated: true, completion: nil)
            }
        }else if indexPath.row == 3{
            ///清除缓存
            self.clearWebCache()
        }
    }
    func clearWebCache(){
        ///缓存文件个数
        let diskCount = SDImageCache.sharedImageCache().getDiskCount()
        ///获取缓存大小
        let cachSize = SDImageCache.sharedImageCache().getSize()
        let msg = "缓存文件数量:" + String(diskCount) + "缓存文件大小:" + String(cachSize/1024/1024) + "M"
        let alertController = UIAlertController(title: "清除缓存", message: msg, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
            alertController.dismissViewControllerAnimated(false, completion: nil)
        }
        alertController.addAction(cancel)
        let clear = UIAlertAction(title: "清除缓存", style: UIAlertActionStyle.Destructive) { (action:UIAlertAction) -> Void in
            SDImageCache.sharedImageCache().clearMemory()
            SDImageCache.sharedImageCache().clearDisk()
        }
        alertController.addAction(clear)
        self.presentViewController(alertController, animated: false, completion: nil)
    }
}
