//
//  OwnShareController.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/5/9.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class OwnShareController: SuperViewController,UITableViewDataSource,UITableViewDelegate {
    
    // 请求数据的参数
    var last_key:String?
    
    var dataArray:[homeModel] = []
    var tableView:UITableView!
    ///标题
    var titleString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigatinBar(true)
        if self.titleString?.isEmpty == false {
            self.title = self.titleString
            
        }else {
            self.title = "好奇心研究所"
        }
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGrayColor()
        self.tableView = UITableView(frame: UIScreen.mainScreen().bounds)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        addRefresh()
        SVProgressHUD.showWithStatus("数据正在加载中")
        self.requestData("0.json?")
        self.tableView.registerNib(UINib(nibName: "ECell", bundle: nil), forCellReuseIdentifier: "ECell")
        self.tableView.rowHeight = 300
        // Do any additional setup after loading the view.
    }
    ///添加上拉加载控件
    func addRefresh(){
        let footer = MJRefreshAutoGifFooter { () -> Void in
            self.requestData(self.last_key!)
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
    func requestData(str:String){
        let url = curiosityUrl + str
        netWorkingManager.requestData(url, par: nil) { (dataSource) -> Void in
            //SVProgressHUD.showWithStatus("数据加载中")
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
                    self.tableView.mj_footer.endRefreshing()
            })
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ECell") as! ECell
        //        for  view in cell.backView!.subviews{
        //            view.removeFromSuperview()
        //        }
        let model = self.dataArray[indexPath.row]
        cell.toCellFillData(model)
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
