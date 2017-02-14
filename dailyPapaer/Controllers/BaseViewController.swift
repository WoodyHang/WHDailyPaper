//
//  BaseViewController.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/4/29.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit
///新闻分类
class BaseViewController: UITableViewController {
    // 请求数据的参数
    var last_key:String?
    //title
    var titleString:String!
    //    刷新控件
    var header:MJRefreshGifHeader!
    //gifImage
    var gifImageView:UIImageView!
    ///
    var dataArray:[homeModel] = []
    var id:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRefresh(id)
        self.tableView.mj_header.beginRefreshing()
        self.tableView.registerNib(UINib(nibName: "FeedsCell", bundle: nil), forCellReuseIdentifier: "FeedsCell")
        self.tableView.registerNib(UINib(nibName: "ACell", bundle: nil), forCellReuseIdentifier: "ACell")
        addNavigatinBar()
        self.title = titleString
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGrayColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateColor:", name:"updateBackGroundColor", object: nil)
        if NSUserDefaults.standardUserDefaults().objectForKey("mode") as! String == "夜间" {
            self.tableView.backgroundColor = UIColor.darkGrayColor()
        }else {
            self.tableView.backgroundColor = UIColor.whiteColor()
            
        }
        
    }
    
    ///通知响应方法
    func updateColor(notif:NSNotification){
        if NSUserDefaults.standardUserDefaults().objectForKey("mode") as! String == "夜间" {
            self.tableView.backgroundColor = UIColor.darkGrayColor()
        }else {
            self.tableView.backgroundColor = UIColor.whiteColor()
        }
        
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
    //添加下拉刷新和上拉加载
    func setUpRefresh( str1:String){
        let str = newsCategoriesUrl + str1 + "/"
        header = MJRefreshGifHeader { () -> Void in
            if self.dataArray.count > 0 {
                self.dataArray.removeAll()
            }
            self.requestData(str, string2: "0.json?")
            self.updateGifPicture()
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.gifImageView!.frame.origin.y = 30
            })
        }
        self.updateGifPicture()
        header.stateLabel?.hidden = true
        //header.lastUpdatedTimeLabel?.hidden = true
        header.placeSubviews()
        self.tableView.mj_header = header
        //加载更多
        let footer:MJRefreshAutoGifFooter = MJRefreshAutoGifFooter { () -> Void in
            
            //self.requstData(self.last_key! + ".json?")
            let string = self.last_key! + ".json?"
            self.requestData(str, string2: string)
        }
        footer.automaticallyHidden = false
        footer.automaticallyRefresh = false
        var imageArr:[AnyObject] = []
        for var index = 1;index <= 21;index++ {
            let imageName = UIImage(named:"list_loading_\(index)" )
            imageArr.append(imageName!)
        }
        footer.setImages(imageArr, duration:1, forState:.Refreshing)
        footer.refreshingTitleHidden = true
        footer.stateLabel?.hidden = true
        footer.placeSubviews()
        self.tableView.mj_footer = footer
        
    }
    ///数据相关
    func requestData(string1:String,string2:String){
        netWorkingManager.requestData(string1 + string2, par: nil) { (dataSource) -> Void in
            SVProgressHUD.showWithStatus("数据加载中")
            var responseDict = [:]
            responseDict = dataSource["response"] as! [String:AnyObject]
            self.last_key = responseDict["last_key"] as? String
            var feeds = []
            feeds = (responseDict["feeds"] as? [AnyObject])!
            for dict:[String:AnyObject] in feeds as! [Dictionary] {
                let model = homeModel.yy_modelWithDictionary(dict)
                self.dataArray.append(model!)
            }
            dispatch_async(dispatch_get_main_queue()
                , { () -> Void in
                    SVProgressHUD.dismiss()
                    self.tableView.reloadData()
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
            })
        }
        
    }
    //判断当前时间,更换刷新控件的图片
    func updateGifPicture() {
        //        判断当前时间是否为19:00
        let nowDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH"
        let nowDateString = dateFormatter.stringFromDate(nowDate)
        print(nowDateString)
        let nowTime:Int = Int(nowDateString)!
        if nowTime < 19&&nowTime > 6{
            //白天
            let image = UIImage(named: "reveal_refresh_foreground")
            header.mj_h = (image?.size.height)!
            header.backgroundColor = UIColor(patternImage:image!)
            gifImageView = header.gifView
            gifImageView.contentMode = UIViewContentMode.Center
            gifImageView!.image = UIImage(named: "reveal_refresh_sun")
        }
        else {
            let image = UIImage(named: "reveal_refresh_foreground_night")
            header.mj_h = (image?.size.height)!
            header.backgroundColor = UIColor(patternImage:image!)
            gifImageView = header.gifView
            gifImageView.contentMode = UIViewContentMode.Center
            gifImageView.image = UIImage(named: "reveal_refresh_moon")
        }
        
    }
    func backBtnClicked(sender:UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model = self.dataArray[indexPath.row]
        if model.type == 1 {
            let feedsCell = tableView.dequeueReusableCellWithIdentifier("FeedsCell") as! FeedsCell
            feedsCell.model = model
            return feedsCell
        }else {
            let acell = tableView.dequeueReusableCellWithIdentifier("ACell") as! ACell
            acell.toCellFillData(model)
            return acell
            
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let model:homeModel = self.dataArray[indexPath.row]
        if model.type == 1 {
            return 120
        } else  {
            return 360
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detaiVC = DetailViewController()
        let model = self.dataArray[indexPath.row]
        detaiVC.htmlString = model.post["appview"] as! String
        self.presentViewController(detaiVC, animated: true, completion: nil)
        
    }
    
    
    
}
