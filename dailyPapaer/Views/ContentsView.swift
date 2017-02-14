//
//  ContentsView.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/4/27.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//
///目录视图
import UIKit

class ContentsView: UIView,UITableViewDataSource,UITableViewDelegate {
    ///设置按钮
    @IBAction func setBtnPress(sender: UIButton) {
        let setVC = UIView.viewInViewController().storyboard?.instantiateViewControllerWithIdentifier("SettingViewController")
        UIView.viewInViewController().presentViewController(UINavigationController(rootViewController: setVC!), animated: true, completion: nil)
        
    }
    ///搜说按钮
    @IBAction func searchBtnClicked(sender: UIButton) {
        let currentVC = UIView.viewInViewController()
        ///跳转到搜索页面
        currentVC.presentViewController(SearchViewController(), animated: true, completion: nil)
    }
    @IBOutlet weak var backHomeBtn: UIButton!
    var dataArray:[NSDictionary] = []
    var newsCategoriesView:NewsCategoriesView!
    ///tablebiew frame
    var tableViewFrame:CGRect!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backToHomeBtn(sender: UIButton) {
        //self.removeFromSuperview()
        ///找到父视图
        if sender.currentImage == UIImage(named: "homeBackButton") {
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.tableView.frame.origin.x = 0
                self.newsCategoriesView.frame.origin.x = SCREENWIDTH
            })
            backHomeBtn.setImage(UIImage(named: "closeButton"), forState: .Normal)
        }else if sender.currentImage == UIImage(named: "closeButton") {
            let superView:UIVisualEffectView = self.superview as! UIVisualEffectView
            superView.removeFromSuperview()
        }
        
    }
    @IBOutlet weak var modelabel: UILabel!
    @IBAction func nightAndDayClicked(sender: UIButton) {
        nightAndDayBtn.selected = !nightAndDayBtn.selected
        if modelabel.text == "白天"{
            modelabel.text = "夜间"
            //            存储到本地数据库
            NSUserDefaults.standardUserDefaults().setObject("白天", forKey: "mode")
            ///注册通知
        }else {
            modelabel.text = "白天"
            NSUserDefaults.standardUserDefaults().setObject("夜间", forKey: "mode")
        }
        NSNotificationCenter.defaultCenter().postNotificationName("updateBackGroundColor", object: nil)
        let superView:UIVisualEffectView = self.superview as! UIVisualEffectView
        superView.removeFromSuperview()
        if newsCategoriesView.frame.origin.x == 0 {
            newsCategoriesView.frame.origin.x = SCREENWIDTH
        }
        
    }
    @IBOutlet weak var nightAndDayBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        createData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        self.tableView.backgroundColor = UIColor.clearColor()
        tableView.showsVerticalScrollIndicator = false
        tableViewFrame = tableView.frame
        ///创建新闻分类菜单view
        let nib = NSBundle.mainBundle().loadNibNamed("NewsCategoriesView", owner: self, options: nil)
        newsCategoriesView = nib[0] as! NewsCategoriesView
        self.clipsToBounds = false
        newsCategoriesView.frame = CGRect(x: SCREENWIDTH,y: tableViewFrame.origin.y,width: SCREENWIDTH,height: tableViewFrame.size.height)
        self.addSubview(newsCategoriesView)
    }
    //    override func drawRect(rect: CGRect) {
    //        createData()
    //
    //    }
    //    required init?(coder aDecoder: NSCoder) {
    //         super.init(coder: aDecoder)
    //    }
    ///创建数据
    func createData(){
        ///创建7个字典
        var dict1:[String:UIImage] = [:]
        dict1["关于我们"] = UIImage(named: "menu_about")
        self.dataArray.append(dict1)
        var dict2:[String:UIImage] = [:]
        dict2["新闻分类"] = UIImage(named: "menu_category")
        self.dataArray.append(dict2)
        var dict3:[String:UIImage] = [:]
        dict3["栏目中心"] = UIImage(named: "menu_column")
        self.dataArray.append(dict3)
        var dict4:[String:UIImage] = [:]
        dict4["好奇心研究所"] = UIImage(named: "menu_lab")
        self.dataArray.append(dict4)
//        var dict5:[String:UIImage] = [:]
//        dict5["我的消息"] = UIImage(named: "menu_noti")
//        self.dataArray.append(dict5)
        //var dict5:[String:UIImage] = [:]
//        dict6["个人中心"] = UIImage(named: "menu_user")
//        self.dataArray.append(dict6)
        var dict5:[String:UIImage] = [:]
        dict5["首页"] = UIImage(named: "menu_home")
        self.dataArray.append(dict5)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        if indexPath.row == 1 {
            cell?.accessoryType = .DisclosureIndicator
        }
        cell?.backgroundColor = UIColor.clearColor()
        cell?.textLabel?.text = self.dataArray[indexPath.row].allKeys[0] as? String
        cell?.textLabel?.font = UIFont.systemFontOfSize(16)
        cell?.imageView!.image = self.dataArray[indexPath.row].allValues[0] as? UIImage
        cell?.textLabel?.textColor = UIColor.whiteColor()
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 4 {
            ///跳转到首页
            let superView:UIVisualEffectView = self.superview as! UIVisualEffectView
            superView.removeFromSuperview()
            
        }
        if indexPath.row == 1 {
            ///进入新闻分类菜单
            ///先改变tableview的frame
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.tableView.frame.origin.x = -SCREENWIDTH
                ///在改变newscategoriesview的frame
                self.newsCategoriesView.frame.origin.x = 0
                ///改变下面按钮的图片
                self.backHomeBtn.setImage(UIImage(named: "homeBackButton"), forState: .Normal)
            })
        }
        ///好奇心研究所
        if indexPath.row == 3 {
            let currentVC = UIView.viewInViewController()
            currentVC.presentViewController(UINavigationController(rootViewController: OwnShareController()), animated: false, completion: nil)
        }
        ///栏目中心
        if indexPath.row == 2 {
            let currentVC = UIView.viewInViewController()
            currentVC.presentViewController(UINavigationController(rootViewController:  ColumnCenterController()), animated: false, completion: nil)
            
        }
    }
}
