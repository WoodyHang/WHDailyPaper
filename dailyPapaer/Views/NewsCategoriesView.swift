//
//  NewsCategoriesView.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/4/28.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//
///新闻分类菜单
import UIKit

class NewsCategoriesView: UIScrollView {
    ///娱乐
    @IBAction func entertainmentBtn(sender: UIButton) {
        let baseVC = BaseViewController()
        baseVC.titleString = "娱乐"
        baseVC.id = "3"
        let vc = UIView.viewInViewController()
       // print("vc = \(vc)")
        vc.presentViewController(UINavigationController(rootViewController: baseVC), animated: true, completion: nil)

            }
    ///top15
    @IBAction func top15Btn(sender: UIButton) {
        let baseVC = BaseViewController()
        baseVC.titleString = "Top15"
        baseVC.id = "16"
        let vc = UIView.viewInViewController()
        vc.presentViewController(UINavigationController(rootViewController: baseVC), animated: true, completion: nil)
    }
    @IBAction func fashionBtn(sender: UIButton) {
        let baseVC = BaseViewController()
        baseVC.titleString = "时尚"
        baseVC.id = "19"
        let vc = UIView.viewInViewController()
        vc.presentViewController(UINavigationController(rootViewController: baseVC), animated: true, completion: nil)
    }
    @IBAction func longArticleBtn(sender: UIButton) {
        let baseVC = BaseViewController()
        baseVC.titleString = "长文章"
        baseVC.id = "1"
        let vc = UIView.viewInViewController()
        vc.presentViewController(UINavigationController(rootViewController: baseVC), animated: true, completion: nil)
    }
    @IBAction func designBtn(sender: UIButton) {
        let baseVC = BaseViewController()
        baseVC.titleString = "设计"
        baseVC.id = "17"
        let vc = UIView.viewInViewController()
        vc.presentViewController(UINavigationController(rootViewController: baseVC), animated: true, completion: nil)
    }
    @IBAction func intelligentBtn(sender: UIButton) {
        let baseVC = BaseViewController()
        baseVC.titleString = "智能"
        baseVC.id = "4"
        let vc = UIView.viewInViewController()
        vc.presentViewController(UINavigationController(rootViewController: baseVC), animated: true, completion: nil)
    }
    @IBAction func commercialBtn(sender: UIButton) {
        let baseVC = BaseViewController()
        baseVC.titleString = "商业"
        baseVC.id = "18"
        let vc = UIView.viewInViewController()
        vc.presentViewController(UINavigationController(rootViewController: baseVC), animated: true, completion: nil)
    }
    @IBAction func gameBtn(sender: UIButton) {
        let baseVC = BaseViewController()
        baseVC.titleString = "游戏"
        baseVC.id = "54"
        let vc = UIView.viewInViewController()
        vc.presentViewController(UINavigationController(rootViewController: baseVC), animated: true, completion: nil)
    }
    @IBAction func cityBtn(sender: UIButton) {
        let baseVC = BaseViewController()
        baseVC.titleString = "城市"
        baseVC.id = "5"
        let vc = UIView.viewInViewController()
        vc.presentViewController(UINavigationController(rootViewController: baseVC), animated: true, completion: nil)
    }
    @IBAction func headLinesBtn(sender: UIButton) {
        let baseVC = BaseViewController()
        baseVC.titleString = "大公司头条"
        baseVC.id = "63"
        let vc = UIView.viewInViewController()
        vc.presentViewController(UINavigationController(rootViewController: baseVC), animated: true, completion: nil)
    }
    @IBAction func pictureBtn(sender: UIButton) {
        let baseVC = BaseViewController()
        baseVC.titleString = "10个图"
        baseVC.id = "22"
        let vc = UIView.viewInViewController()
        vc.presentViewController(UINavigationController(rootViewController: baseVC), animated: true, completion: nil)
    }
    
    
    
}
