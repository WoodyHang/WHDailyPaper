//
//  ColumnCenterController.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/6/17.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit
import SnapKit
class ColumnCenterController: SuperViewController,UICollectionViewDelegate ,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout,UITableViewDataSource,UITableViewDelegate{
    var indexpathArray:[Int] = []
    ///删除tableviewcell，对应的collectionviewcell在数据源中的位置
    var indexpathRow:Int? = 50
    ///当tableview的数据源数组为空时，创建imageview和label
    var warningImageView:UIImageView?
    var warningLable:UILabel?
    ///存储点击过的cell的indexpath.row
    var indexPathRowArray:[Int] = []
    ///我关注的栏目cell
    var cell:MyFocusCell!
    var collectionView:UICollectionView!
    ///collectionView的数据源数组
    var collectionViewDataArray:[AnyObject] = []
    ///tableview的数据源数组
    var tableViewDataArray:[AnyObject] = []
    var last_key:String?
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        ///页面出现时更新一下UI
//        cell.addUI()
        //接受更新UI的通知
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "upateUI:", name: "refreshMyFocus", object: nil)
        self.tableViewDataArray = DataBaseManager.shareInstance.getAllCollection()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigatinBar(false)
        self.title = "栏目中心"
        
        //self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGrayColor()
        self.view.backgroundColor = UIColor.whiteColor()
        //createUI()
        requestDataToService(AllColumns, string2: "0.json?")
        
        setupCollectionView()
        addLoadMoreData()
        
        
        
        // Do any additional setup after loading the view.
    }
    //MARK: - CollectionView UI Setup
    func setupCollectionView(){
        
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        collectionView = UICollectionView(frame: CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(MyFocusCell.self, forCellWithReuseIdentifier: "MyFocusCell")
        collectionView.registerNib(UINib(nibName: "AllContentCell", bundle: nil), forCellWithReuseIdentifier: "AllContentCell")
        collectionView.registerNib(UINib(nibName: "CustomerHeaderView", bundle: nil), forSupplementaryViewOfKind: CHTCollectionElementKindSectionHeader, withReuseIdentifier: "CustomerHeaderView")
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        // Collection view attributes
        self.collectionView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.collectionView.alwaysBounceVertical = true
        layout.headerHeight = 50
    }
    ///当tableview的数据源数组个数为0时，在tableview上加一个view
    func addViewWhenTableViewDataSourceIsNil(){
        if warningImageView == nil {
            warningImageView = UIImageView(frame: CGRectMake(0,0,100,100))
            warningImageView!.center = CGPointMake(SCREENWIDTH / 2,cell.frame.size.height / 2)
            cell.contentView.addSubview(warningImageView!)
            warningImageView?.image = UIImage(named: "columnCenterLogin")
            
        }
        if warningLable == nil {
            warningLable = UILabel()
            warningLable!.text = "一个栏目都没有添加，试试从下面的列表中添加"
            warningLable!.font = UIFont.systemFontOfSize(14)
            cell.contentView.addSubview(warningLable!)
            warningLable!.snp_makeConstraints { (make) -> Void in
                make.centerX.equalTo(cell.contentView.snp_centerX)
                make.top.equalTo(warningImageView!.snp_bottom).offset(20)
            }
            
        }
        
    }
    ///加载跟多
    func addLoadMoreData(){
        let footer = MJRefreshAutoGifFooter { () -> Void in
            self.requestDataToService(AllColumns, string2: self.last_key! + ".json")
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
        self.collectionView.mj_footer = footer
        
    }
    /**   UICollectionViewDelegateFlowLayout ***/
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSizeMake(SCREENWIDTH, 400)
        }else {
            if indexPath.row == 0{
                return CGSizeMake(SCREENWIDTH / 2, 220)
                
            }else {
                return CGSizeMake(SCREENWIDTH / 2, 250)
            }
        }
    }
    
    /** UICollectionViewDelegate,UICollectionViewDataDelegate **/
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            //print(self.collectionViewDataArray.count)
            return self.collectionViewDataArray.count
            
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("MyFocusCell", forIndexPath: indexPath) as! MyFocusCell
            ///为cell添加一个tag值
            ///改变cell的width
            var rect = cell.frame
            rect.size.width = SCREENWIDTH
            cell.frame = rect
            ///当tableview存在时
            if (cell.tableView != nil) {
                cell.tableView!.delegate = self
                cell.tableView!.dataSource = self
                
            }
            ///当未登录时，为登录按钮创建点击事件
            if (cell.loginButton != nil) {
                cell.loginButton?.addTarget(self, action: "loginBtnClicked:", forControlEvents: UIControlEvents.TouchDown)
            }
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AllContentCell", forIndexPath: indexPath) as! AllContentCell
            cell.fillToData(self.collectionViewDataArray[indexPath.row] as! homeModel)
            if self.indexPathRowArray.contains(indexPath.row){
                cell.addBtn.selected = true
            }else {
                cell.addBtn.selected = false
            }

            for model in self.tableViewDataArray {
                if (model as!homeModel).name! == (self.collectionViewDataArray[indexPath.row] as! homeModel).name{
                    cell.addBtn.selected = true
                }else {
                    //cell.addBtn.selected = false
                }
            }
////            if self.indexpathArray.contains(indexPath.row){
//                cell.addBtn.selected = false
//            }            ///
//            if indexPath.row == self.indexpathRow! {
//                cell.addBtn.selected = false
//            }
//            if self.indexpathRow == indexPath.row {
//                cell.addBtn.selected = false
//            }//            if self.indexpathRow != nil {
//                let changeIndexPath:NSIndexPath = NSIndexPath(forRow: self.indexpathRow!, inSection: 1)
//                let changeCell = collectionView.cellForItemAtIndexPath(changeIndexPath) as? AllContentCell
//                if changeCell != nil {
//                    changeCell!.addBtn.selected = false
//                    
//                }
//        }
            ///为cell上面的button添加tag值
            cell.addBtn.tag = indexPath.row
//            if indexPath.row == self.indexpathRow! {
//                print("=====\(self.indexpathRow!)")
//                cell.addBtn.selected = false
//            }else {
//                cell.addBtn.selected = true
//            }

            ///订阅栏目
            cell.addBtn.addTarget(self, action: "subscribecolumns:", forControlEvents: UIControlEvents.TouchDown)
            return cell
        }
    }
    
    ///组头
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(CHTCollectionElementKindSectionHeader, withReuseIdentifier: "CustomerHeaderView", forIndexPath: indexPath) as! CustomerHeaderView
        
        if indexPath.section == 0 {
            headerView.label.text = "我关注的内容"
        }else {
            headerView.label.text = "全部内容"
        }
        return headerView
    }
    ///点击cell查看详情
    func watchDetailMessageWhenClickedCells(model:homeModel,isShareButton:Bool){
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
        if isShareButton == true {
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
        }else {

        }
        if model.show_type == 1 || model.show_type == 5{
            self.presentViewController(UINavigationController(rootViewController: vc), animated: false, completion: nil)
        }else if model.show_type == 2 {
            self.presentViewController(UINavigationController(rootViewController: vc1), animated: false, completion: nil)
        }
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        ///跳转到专栏或者专题页面
        if indexPath.section == 1 {
            let model = self.collectionViewDataArray[indexPath.row] as! homeModel
            watchDetailMessageWhenClickedCells(model,isShareButton: true)
        }
    }
    /**UITableViewDelegate   **/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("======\(self.tableViewDataArray.count),\(self.tableViewDataArray)")
         if self.tableViewDataArray.count == 0  {
            addViewWhenTableViewDataSourceIsNil()
            warningLable?.hidden = false
            warningImageView?.hidden = false
            return 0
        }else {
            ///隐藏视图
            warningImageView!.hidden = true
            warningLable!.hidden = true
            return self.tableViewDataArray.count
        }
        
        
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyFocusTableViewCell") as! MyFocusTableViewCell
        cell.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        cell.selectionStyle = .None
        cell.fillToData(self.tableViewDataArray[indexPath.row] as! homeModel)
//        cell.addBtn.addTarget(self, action: "removeFocus:", forControlEvents: .TouchDown)
        // cell.addBtn.tag = indexPath.row
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.tableViewDataArray[indexPath.row]
        watchDetailMessageWhenClickedCells(model as! homeModel,isShareButton: false)
    }
    ///MARK -- 按钮点击事件
    func subscribecolumns(sender:UIButton){
        if (NSUserDefaults.standardUserDefaults().objectForKey("isLogin") as? Bool == false || NSUserDefaults.standardUserDefaults().objectForKey("isLogin") == nil){
            ///没有登录，点击添加按钮，跳转到登录页面
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
            self.presentViewController(UINavigationController(rootViewController: vc), animated: false, completion: nil)
        }else {
            ///已经登录
            
            sender.selected = !sender.selected
            
            ///获取到选中的model
            let selectedModel = self.collectionViewDataArray[sender.tag] as! homeModel
            
            if sender.selected == true{
                self.indexPathRowArray.append(sender.tag)
                ///添加栏目
                //selectedModel.index = sender.tag
                
                self.tableViewDataArray.append(selectedModel)
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
                for var i = 0 ;i < self.tableViewDataArray.count; i++ {
                    if (self.tableViewDataArray[i] as! homeModel).name == selectedModel.name{
                        
                     DataBaseManager.shareInstance.deleteColletionTableModel(self.tableViewDataArray[i] as! homeModel)
                        self.tableViewDataArray.removeAtIndex(i)

                        //self.collectionView.reloadData()
                        break
                    }
                }
                
            }
            cell.tableView!.reloadData()
        }
    }
    ///登录按钮
    func loginBtnClicked(sender:UIButton){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(UINavigationController(rootViewController: vc), animated: false, completion: nil)
    }
    ///移除tableviewcell里的单元
//    func removeFocus(sender:UIButton){
//        let model = self.tableViewDataArray[sender.tag] as! homeModel
//        self.tableViewDataArray.removeAtIndex(sender.tag)
//        ///找到collectionview数据源对应的model,改变按钮状态
//        for var i = 0;i < self.collectionViewDataArray.count;i++ {
//            if model.name == (self.collectionViewDataArray[i] as! homeModel).name{
//                self.indexpathRow = i
//                //let changeIndexPath:NSIndexPath = NSIndexPath(forRow: i, inSection: 1)
////                let changeCell = collectionView.cellForItemAtIndexPath(changeIndexPath) as? AllContentCell
////                if changeCell != nil {
////                    changeCell?.addBtn.selected = false
////                }
////                self.collectionView.reloadItemsAtIndexPaths([changeIndexPath])
////                self.indexpathArray.append(i)
//                break
//            }
//            
//        }
//
//        cell.tableView!.reloadData()
//        
//        
//    }
    ///MARK -- 通知响应事件
    func upateUI(notif:NSNotification){
        for views in cell.contentView.subviews {
            views.removeFromSuperview()
        }
        
        cell.addUI()
        cell.tableView!.delegate = self
        cell.tableView!.dataSource = self
        cell.tableView!.reloadData()
    }
    ///MARK -- 数据相关
    func requestDataToService(string1:String,string2:String){
        netWorkingManager.requestData(string1 + string2, par: nil) { (dataSource) -> Void in
            //SVProgressHUD.showWithStatus("数据加载中")
            var responseDict = [:]
            responseDict = dataSource["response"] as! [String:AnyObject]
            self.last_key = String(responseDict["last_key"]!)
            print(self.last_key)
            var columns = []
            columns = (responseDict["columns"] as? [AnyObject])!
            for dict:[String:AnyObject] in columns as! [Dictionary] {
                let model = homeModel.yy_modelWithDictionary(dict)
                self.collectionViewDataArray.append(model!)
            }
            dispatch_async(dispatch_get_main_queue()
                , { () -> Void in
                    SVProgressHUD.dismiss()
                    self.collectionView.reloadData()
                    self.collectionView.mj_footer.endRefreshing()
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
