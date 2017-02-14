//
//  AppDelegate.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/3/17.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        ///设置app默认模式：白天
        if NSUserDefaults.standardUserDefaults().objectForKey("mode") == nil
        {
        NSUserDefaults.standardUserDefaults().setObject("白天", forKey: "mode")
        }
       // UMSocialData.setAppKey("572ae3cce0f55a20590016c5")
        
///572ae3cce0f55a20590016c5
        //微博
//        UMSocialSinaSSOHandler.openNewSinaSSOWithAppKey("3823707035", secret: "92718ad1554a6c8e1a5fb58e3896d74d", redirectURL: "http://www.1000phone.com/")
        //微信
        UMSocialWechatHandler.setWXAppId("wx1849728edf16d338", appSecret: "c9ee870b14f4f373483c8cbbc4129c4c", url: "http://www.baidu.com")
        UMSocialConfig.hiddenNotInstallPlatforms([UMShareToWechatSession,UMShareToWechatTimeline])
        ///Bmob
        Bmob.registerWithAppKey("d7c99af8d62c3d3d348d983738ceb75b")
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 100
        return true
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

