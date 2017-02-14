//
//  HomeViewControllersViewController.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/3/17.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit
import SnapKit
class HomeViewControllersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    //记录被选中的cell所在数据源数组的位置
    var indexPathRowArray:[Int] = []
    var tableView:UITableView!
    var button:UIButton!
    var contentView:ContentsView!
    //    刷新控件
    var header:MJRefreshGifHeader!
    //gifImage
    var gifImageView:UIImageView!
    // 请求数据的参数
    var last_key:String?
    //    请求一次数据数据源数组有多少个model
    var dataArrayCount:Int = 0
    ///数据源数组
    lazy var dataArray:[AnyObject]? = {
        return []
    }()
    var dataSmallArray:[AnyObject]? = {
        return []
    }()
    ///滚动视图数组
    lazy var bannersArray:[homeModel] = {
        return []
    }()
    ///普通数组
    lazy var feedsArray:[homeModel] = {
        return []
    }()
    ///广告数组
    lazy var adArray:[homeModel] = {
        return []
    }()
    ///专题数组
    lazy var topicArray:[homeModel] = {
        return []
    }()
    var id:Int!
    var a:Int = 0
    var dataDict:[Int:AnyObject] = [:]
    var urlArray:[String] = []
    ///定义3个偏移量
    var contentOffsetY:CGFloat!
    var newContentOffsetY:CGFloat!
    var oldContentOffsetY:CGFloat!
    ///遮盖view
    var backGroundView:UIView!
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        requstdata("0.json?")
        setUpRefresh()
        self.tableView.separatorStyle = .None
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateColor:", name:"updateBackGroundColor", object: nil)
        if NSUserDefaults.standardUserDefaults().objectForKey("mode") as? String == "夜间" {
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
    
    //        self.tableView.mj_header.beginRefreshing()
    // Do any additional setup after loading the view.
    func createUI(){
        ///加载xib
        let nib = NSBundle.mainBundle().loadNibNamed("ContentViews", owner: self, options: nil)
        contentView = nib[0] as! ContentsView
        contentView.frame = CGRectMake(0,0,SCREENWIDTH,SCREENHEIGHT)
        
        if NSUserDefaults.standardUserDefaults().objectForKey("mode") as? String == "夜间" {
            contentView.modelabel.text = "白天"
            contentView.nightAndDayBtn.setImage(UIImage(named: "sidebar_switchNight_night"), forState: .Normal)
        }
        else {
            contentView.modelabel.text = "夜间"
            contentView.nightAndDayBtn.setImage(UIImage(named: "sidebar_switchNight"),forState:.Normal)
        }
        tableView = UITableView(frame: CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT))
        tableView.separatorStyle = .SingleLine
        tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "ScrollerTableViewCell", bundle: nil), forCellReuseIdentifier: "ScrollerTableViewCell")
        self.tableView.registerNib(UINib(nibName: "FeedsCell", bundle: nil), forCellReuseIdentifier: "FeedsCell")
        self.tableView.registerNib(UINib(nibName: "ACell", bundle: nil), forCellReuseIdentifier: "ACell")
        self.tableView.registerNib(UINib(nibName: "BCell", bundle: nil), forCellReuseIdentifier: "BCell")
        self.tableView.registerNib(UINib(nibName: "CCell", bundle: nil), forCellReuseIdentifier: "CCell")
        tableView.dataSource = self
        self.view.addSubview(tableView)
        button = UIButton()
        button.backgroundColor = UIColor.blackColor()
        self.view.addSubview(button)
        button.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.view.snp_left).offset(10)
            make.bottom.equalTo(self.view.snp_bottom).offset(-20)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        button.setImage(UIImage(named: "Home@iPadPro_Yellow"), forState: .Normal)
        button.layer.cornerRadius = 30
        
    }
    //    创建刷新和加载更多控件
    func setUpRefresh() {
        header = MJRefreshGifHeader { () -> Void in
            if self.dataArray?.count > 0 {
                self.dataArray?.removeAll()
            }
            self.requstdata("0.json?")
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
            self.requstdata(self.last_key! + ".json?")
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
    func buttonClicked(sender:UIButton){
        ///加入模糊效果
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let effecview = UIVisualEffectView(effect: blur)
        effecview.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)
        self.view.addSubview(effecview)
        ///设置转场动画
        let transition = CATransition()
        transition.duration = NSTimeInterval(2)
        transition.type = "reveal"
        transition.subtype = "fromRight";
        /////cameraIris    相机
        //cube          立方体
        //fade          淡入
        //moveIn        移入
        //oglFilp       翻转
        //pageCurl      翻去一页
        //pageUnCurl    添上一页
        //push          平移
        //reveal        移走
        //rippleEffect
        //suckEffect
        effecview.layer.addAnimation(transition, forKey: nil)
        effecview.addSubview(contentView )
    }
    ///UIScrollerViewdDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        newContentOffsetY = scrollView.contentOffset.y
        if newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY {
            button.hidden = true
            
        }else {
            button.hidden = false
            if self.tableView.contentOffset.y < 0 {
                UIView.animateWithDuration(1, animations: { () -> Void in
                    self.gifImageView.frame.origin.y = -30
                })
            }
        }
        
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        contentOffsetY = scrollView.contentOffset.y
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        oldContentOffsetY = scrollView.contentOffset.y
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return (self.dataArray?.count)!
        }else {
            //print(self.dataSmallArray?.count)
            return (self.dataSmallArray?.count)!
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            if indexPath.row == 0{
                let ScrollerCell:ScrollerTableViewCell = tableView.dequeueReusableCellWithIdentifier("ScrollerTableViewCell") as! ScrollerTableViewCell
                ScrollerCell.ScrollerArray = self.bannersArray
                return ScrollerCell
            }else {
                let model:homeModel = self.dataArray![indexPath.row] as! homeModel
                if model.type == 1 {
                    let feedsCell = tableView.dequeueReusableCellWithIdentifier("FeedsCell") as! FeedsCell
                    feedsCell.model = model
                    //                UITableViewCell.switchDayModeAndNightMode(feedsCell)
                    return feedsCell
                }else if model.type == 2 {
                    let acell = tableView.dequeueReusableCellWithIdentifier("ACell") as! ACell
                    acell.toCellFillData(model)
                    return acell
                }else if model.type == 0&&model.post.count != 0{
                    let Bcell = tableView.dequeueReusableCellWithIdentifier("BCell") as! BCell
                    Bcell.toCellFillData(model)
                    return Bcell
                }else {
                    let ccell = tableView.dequeueReusableCellWithIdentifier("CCell") as! CCell
                    ccell.tableView.dataSource = self
                    ccell.tableView.delegate = self
                    ccell.tableView.reloadData()
                    ccell.nameLabel.text = model.name
                    ccell.iconImageView.sd_setImageWithURL(NSURL(string:model.icon!))
                    ccell.addBtn.addTarget(self, action: "addBtnClicked:", forControlEvents: .TouchUpInside)
                    ///为cel.addbtn设置tag值
                    ccell.addBtn.tag = indexPath.row
                    if self.indexPathRowArray.contains(indexPath.row){
                        ccell.addBtn.selected = true
                    }else {
                        ccell.addBtn.selected = false
                    }

                    for model in DataBaseManager.shareInstance.getAllCollection() {
                        if model.name! == (self.dataArray![indexPath.row] as! homeModel).name{
                            ccell.addBtn.selected = true
                        }else {
                            //cell.addBtn.selected = false
                        }
                    }

                    ///设置分享图片和文字
                    let str1 = model.share["title"]! as String
                    let str2 = model.share["text"]! as String
                    ccell.urlString =  model.share["url"]! as String
                    ccell.shareText = str1 + "\n" + str2 + "\n" + ccell.urlString!
                    ccell.shareTextToWeChat = str1 + "\n" + str2 + "\n"
                    let str3 = model.share["image"]! as String
                    ccell.shareImageString = str3
                    let imageData = NSData(contentsOfURL: NSURL(string: str3)!)
                    ccell.shareImage = UIImage(data: imageData!)

                    self.a = model.id
                    let urlString = KTOPICURL + "\(self.a)/0.json?"
                    
                    //                if self.urlArray.contains(urlString) == false {
                    self.urlArray.append(urlString)
                    netWorkingManager.requestData(urlString, par:nil) { (dataSource) -> Void in var responseDict:[String:AnyObject] = [:]
                        responseDict = dataSource["response"] as! [String:AnyObject]
                        var feedArray = []
                        feedArray = responseDict["feeds"] as! [AnyObject]
                        if self.dataSmallArray?.count > 0 {
                            self.dataSmallArray?.removeAll()
                        }
                        for dic:[String:AnyObject] in feedArray as! [Dictionary]  {
                            let model = homeModel.yy_modelWithDictionary(dic)
                            self.dataSmallArray?.append(model!)
                        }
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            ccell.tableView.reloadData()
                        })
                    }
                    
                    return ccell
                }
            }
        }else {
            let model = self.dataSmallArray![indexPath.row] as! homeModel
            let cell = tableView.dequeueReusableCellWithIdentifier("DCell") as! DCell
            
            cell.toCellFillData(model )
            cell.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            return cell
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == self.tableView {
            if indexPath.row == 0 {
                return 250
            } else {
                let model:homeModel = self.dataArray![indexPath.row] as! homeModel
                if model.type == 1 {
                    return 120
                } else if model.type == 2 {
                    return 360
                }else if model.type == 0&&model.post.count != 0{
                    return 340
                }else {
                    return 340
                }
            }
        }else {
            return 300
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detaiVC = DetailViewController()
        //detaiVC.modalTransitionStyle = .PartialCurl
        //        使用转场动画会为webview添加一个手势
        if tableView == self.tableView {
            let model = self.dataArray![indexPath.row] as! homeModel
            if model.type == 1 {
                detaiVC.htmlString = model.post["appview"] as! String
            }else if model.type == 2 {
                detaiVC.htmlString = model.post["appview"] as! String
            }else if model.type == 0&&model.post.count != 0 {
                //            http://www.qdaily.com/papers/911.html
                let string = model.post["id"]?.stringValue
                if model.post["category"]!["title"]as! String == "投票" {
                    detaiVC.htmlString = "http://www.qdaily.com/papers/" + string! + ".html"
                }else {
                    detaiVC.htmlString = "http://www.qdaily.com/mobs/" + string! + ".html"
                }
            }else {
                //detaiVC.htmlString = model.share["url"]! as String
                let vc = ColumnViewController()
                let vc1 = CollectionViewController()
                vc.titleString = model.name!
                vc1.titleString = model.name
                ///传递id
                vc.id = String(model.id)
                vc1.id = String(model.id)
                ///传递可拉伸的图片
                vc.imageString = model.image!
                vc1.imageString = model.image!
                let str1 = model.share["title"]
                let str2 = model.share["text"]
                vc.urlString =  model.share["url"]
                vc1.urlString = model.share["url"]
                vc.shareText = str1! + "\n" + str2! + "\n" + vc.urlString!
                vc1.shareText = str1! + "\n" + str2! + "\n" + vc.urlString!
                vc.shareTextToWeChat = str1! + "\n" + str2! + "\n"
                vc1.shareTextToWeChat = str1! + "\n" + str2! + "\n"

                let str3 = model.share["image"]
                vc.shareImageString = str3
                vc1.shareImageString = str3

                let imageData = NSData(contentsOfURL: NSURL(string: str3!)!)
                vc.shareImage = UIImage(data: imageData!)
                vc1.shareImage = UIImage(data: imageData!)

                if model.show_type == 2 {
                    ///跳转到collectionviewcell
                self.presentViewController(UINavigationController(rootViewController: vc1), animated: true, completion: nil)
                                }else{
                self.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
                }
                
                return
            }
        }else {
            let model1 = self.dataSmallArray![indexPath.row]
            detaiVC.htmlString = model1.post["appview"] as! String
        }
        self.presentViewController(detaiVC, animated: true, completion: nil)
        
    }
    ///数据相关
    func requstdata(urlString:String){
        //rSVProgressHUD.showWithStatus("数据加载中")
        netWorkingManager.requestData(KHOMEURL + urlString, par: nil) { (dataSource) -> Void in
            var responseDict = [:]
            responseDict = (dataSource["response"] as? [String:AnyObject])!
            self.last_key = responseDict["last_key"] as? String
            var banners = []
            banners = (responseDict["banners"] as? [AnyObject]!)!
            if banners.count > 0{
                for  dict1:[String:AnyObject] in banners as! [Dictionary]{
                    let model = homeModel.yy_modelWithDictionary(dict1)
                    self.bannersArray.append(model!)
                }
                self.dataArray?.append(self.bannersArray)
            }
            var feeds = []
            feeds = (responseDict["feeds"] as?[AnyObject]!)!
            if feeds.count > 0 {
                for  dict2:[String:AnyObject] in feeds as![Dictionary] {
                    let model = homeModel.yy_modelWithDictionary(dict2)
                    self.dataArray?.append(model!)
                }
            }
            var ad = []
            ad = (responseDict["feeds_ad"] as![AnyObject]!)!
            if ad.count > 0 {
                for dict3:[String:AnyObject] in ad as![Dictionary] {
                    let model = homeModel.yy_modelWithDictionary(dict3)
                    //                产生随机数储存广告model
                    let count = self.dataArray?.count
                    if banners.count > 0 {
                        let randomNumber = arc4random()%UInt32(count!)+1
                        //                print("randomNumber==\(randomNumber)")
                        self.dataArray?.insert(model!, atIndex: Int(randomNumber))
                    }else {
                        let randomNumber = arc4random()%UInt32(count! - self.dataArrayCount)
                        let randomNum:Int = Int(randomNumber) + self.dataArrayCount
                        self.dataArray?.insert(model!, atIndex: randomNum)
                    }
                }
            }
            var topic = []
            topic = (responseDict["columns"] as![AnyObject]!)!
            if topic.count > 0 {
                //            for dict4:[String:AnyObject] in topic as![Dictionary] {
                //                let model = homeModel.yy_modelWithDictionary(dict4)
                ////                print(model.name)
                //                //产生随机数储存广告model
                //                let count = self.dataArray?.count
                //                if banners.count > 0 {
                //                let randomNumber = (arc4random()%UInt32(count!)+1)
                ////                print("randomNumber==\(randomNumber)")
                //                self.dataArray?.insert(model, atIndex: Int(randomNumber))
                //                }else {
                //                    let randomNumber = (arc4random()%UInt32(count! - self.dataArrayCount))
                //                    let randomNum:Int = Int(randomNumber) + self.dataArrayCount
                //                    self.dataArray?.insert(model, atIndex: randomNum)
                //                }
                for var index = 0;index < topic.count;index++ {
                    let model = homeModel.yy_modelWithDictionary(topic[index] as! Dictionary)
                    if banners.count > 0 {
                        self.dataArray?.insert(model!, atIndex: (index+1) * 6)
                    }else {
                        // print((index+1) * 5 + self.dataArrayCount)
                        self.dataArray?.insert(model!, atIndex: (index+1) * 6 + self.dataArrayCount)
                    }
                }
            }
            self.dataArrayCount = (self.dataArray?.count)!
            //纪录请求一次数据时数据源数组有多少个model
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                }
            )
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
    ///栏目添加点击事件
    func addBtnClicked(sender:UIButton){
        sender.selected = !sender.selected
        ///获取到选中的model
        let selectedModel = self.dataArray![sender.tag] as! homeModel
        
        if sender.selected == true{
            self.indexPathRowArray.append(sender.tag)
            ///添加栏目
            //selectedModel.index = sender.tag
            DataBaseManager.shareInstance.insertCollectionTableModel(selectedModel)
            
            
        } else if sender.selected == false{
            //self.indexPathRowArray.removeAtIndex(sender.tag)
            ///删除栏目，同时删除标记的cell的坐标
            for var i = 0;i < self.indexPathRowArray.count;i++ {
                if sender.tag == self.indexPathRowArray[i]{
                    self.indexPathRowArray.removeAtIndex(i)
                }
            }
            ///删除栏目
            ///首先先找到点击的是那个item
            ///再寻找对应的tableviewcell，删除
            let allArray = DataBaseManager.shareInstance.getAllCollection()
            for var i = 0 ;i < allArray.count; i++ {
                if (allArray[i] ).name == selectedModel.name{
                    
                    DataBaseManager.shareInstance.deleteColletionTableModel(allArray[i])
                    
                    //self.collectionView.reloadData()
                    break
                }
            }
            
        }
        self.tableView!.reloadData()
    }
}


