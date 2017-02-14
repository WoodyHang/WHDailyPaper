//
//  SearchViewController.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/5/4.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {
    struct Static {
        static var onceToken:dispatch_once_t = 0
    }

    var keyWord:String?
    var tableView:UITableView!
    var total_number:Int = 0
    var dataArray:[homeModel] = []
    var last_key:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBarOnNavigatinbarAndUI()
        self.view.backgroundColor = UIColor.whiteColor()
        //self.addRefresh()
        //createTableView()
    }
    ///创建tableview
    func createTableView(){
        self.tableView = UITableView(frame: CGRectMake(0,60,SCREENWIDTH,SCREENHEIGHT - 60.0))
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.tableView)
        self.tableView.separatorStyle = .None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        
    }
    ///添加导航栏
    func addSearchBarOnNavigatinbarAndUI(){
        let searchBar = UISearchBar(frame: CGRectMake(0,25,SCREENWIDTH,35))
        searchBar.delegate = self
        searchBar.placeholder = "搜索"
        searchBar.showsCancelButton = true
        
        ///view
        let backView = UIView(frame: CGRectMake(0,0,SCREENWIDTH,60))
        self.view.addSubview(backView)
        backView.backgroundColor = UIColor.darkGrayColor()
        backView.addSubview(searchBar)
        
        ///设置中文“取消”
        for obj in searchBar.subviews {
            if obj.isKindOfClass(UIView){
                for obj2 in obj.subviews {
                    if obj2.isKindOfClass(UIButton){
                        let button = obj2 as! UIButton
                        button.setTitle("取消", forState: UIControlState.Normal)
                    }
                }
            }
        }
    }
    ///添加上拉加载控件
    func addRefresh(){
        let footer = MJRefreshAutoGifFooter { () -> Void in
            self.requestDataToService(self.keyWord!, string: self.last_key)
            
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
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.keyWord = searchBar.text
        if self.dataArray.count > 0 {
            self.tableView.removeFromSuperview()
            self.dataArray.removeAll()
        }
        self.createTableView()
        self.addRefresh()
        requestDataToService(searchBar.text!,string: "0")
        searchBar.resignFirstResponder()
    }
    ///数据相关
    func requestDataToService(keyWord:String,string:String){
        ///拼接url
        let url = searchUrl + string
        //print(url + "&search=" + keyWord)
        netWorkingManager.requestData(url, par: ["search":keyWord]) { (dataSource) -> Void in
            var responseDict:[String:AnyObject] = [:]
            responseDict = dataSource["response"] as! Dictionary

//            dispatch_once(&Static.onceToken,{
//            //
//            })
            if string == "0"{
                self.total_number = responseDict["total_number"] as! Int
            }
            if responseDict["last_key"] != nil {
                self.last_key = String(responseDict["last_key"]!)
            }
            var searchesArray = []
            searchesArray = responseDict["searches"] as! NSArray
            if searchesArray.count == 0 {
                ///无数据
                self.tableView.removeFromSuperview()
                ///无数据
                let alert = UIAlertController(title: "提示", message: "抱歉，没有搜索到相关内容", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }else {
                for dict in searchesArray {
                    let model = homeModel.yy_modelWithDictionary(dict as! [NSObject : AnyObject])
                    self.dataArray.append(model!)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                    self.tableView.mj_footer.endRefreshing()
                })
            }
            
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count + 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell")
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Value2
                    , reuseIdentifier: "cell")
            }
            cell?.textLabel!.text = "文章"
            cell?.textLabel?.font = UIFont.systemFontOfSize(15)
            cell?.textLabel?.textColor = UIColor.blackColor()
            let detaiString = "(" + String(self.total_number) + "条搜索结果)"
            cell?.detailTextLabel!.text = detaiString
            cell?.detailTextLabel?.font = UIFont.systemFontOfSize(13)
            return cell!
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell") as! SearchCell
            cell.fillUIToCell(self.dataArray[indexPath.row - 1])
            return cell
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }else {
            return 150
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            return
        }else {
            let detaiVC = DetailViewController()
            let model = self.dataArray[indexPath.row - 1]
            detaiVC.htmlString = model.post["appview"] as! String
            self.presentViewController(detaiVC, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
}
