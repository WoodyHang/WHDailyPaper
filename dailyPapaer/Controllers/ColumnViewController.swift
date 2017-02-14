//
//  ColumnViewController.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/5/10.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class ColumnViewController: SuperViewController,UITableViewDataSource,UITableViewDelegate {
    // 请求数据的参数
    var last_key:String?
    ///拉伸图片
    var imageString:String?
    ///URL参数id
    var id:String?
    var tableView:UITableView!
    var dataArray:[homeModel] = []
    var titleString:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigatinBar(true)
        self.title = self.titleString
        //self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.whiteColor()

        self.tableView = UITableView(frame: UIScreen.mainScreen().bounds)
        //self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        //self.navigationController?.navigationBar.hidden = true
        tableView.separatorStyle = .None
        addRefresh()
        SVProgressHUD.showWithStatus("数据正在加载中")
        self.requestData(self.id!, str2: "0.json?")
        //self.tableView.rowHeight = 300
        self.tableView.registerNib(UINib(nibName: "StretchCellCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.registerNib(UINib(nibName: "FeedsCell", bundle: nil), forCellReuseIdentifier: "FeedsCell")
        // Do any additional setup after loading the view.
    }
    func addRefresh(){
        let footer = MJRefreshAutoGifFooter { () -> Void in
            self.requestData(self.id!, str2: self.last_key! + ".json?")
            
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count + 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! StretchCellCell
            let imageData = NSData(contentsOfURL: NSURL(string: self.imageString!)!)
            let scaleView:ScaleView = self.tableView.addScaleImageViewWithImage(UIImage(data: imageData!))
            scaleView.frame.origin.y = cell.bigImageView.frame.origin.y
            cell.bigImageView.addSubview(scaleView)
            //cell.bigImageView.clipsToBounds = true
            scaleView.clipsToBounds = true
            cell.titleLable.text = self.titleString
            return cell

         }else{
            let model = self.dataArray[indexPath.row - 1]
            let cell = tableView.dequeueReusableCellWithIdentifier("FeedsCell") as! FeedsCell
            cell.model = model
            return cell
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        }else{
        return 120
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 0 {
        let detailVC = DetailViewController()
        let model = self.dataArray[indexPath.row - 1]
        detailVC.htmlString = model.post["appview"] as! String
        self.presentViewController(detailVC, animated: true, completion: nil)
        }
    }
    ///请求数据
    func requestData(str1:String,str2:String){
        let url = KTOPICURL + str1 + "/" + str2
        netWorkingManager.requestData(url, par: nil) { (dataSource) -> Void in
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
