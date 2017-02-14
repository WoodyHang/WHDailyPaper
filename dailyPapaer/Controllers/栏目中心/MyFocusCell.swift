//
//  MyFocusCell.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/6/17.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//
///collectionviewcell上放一个tableview
import UIKit
import SnapKit
class MyFocusCell: UICollectionViewCell {
    var tableView:UITableView?
    var loginButton:UIButton?
    func addUI(){
        ///判断当前登录状态，添加微登录状态的UI
        if (NSUserDefaults.standardUserDefaults().objectForKey("isLogin") as? Bool == false || NSUserDefaults.standardUserDefaults().objectForKey("isLogin") == nil){
            loginButton = UIButton(frame: CGRectMake(0,0,100,100))
            loginButton!.center = CGPointMake(self.frame.size.width,self.frame.size.height / 2)
            self.contentView.addSubview(loginButton!)
            loginButton!.setImage(UIImage(named: "columnCenterNotLogin"), forState: UIControlState.Normal)
            let label = UILabel()
            label.text = "登录后你关注的内容会在这里"
            label.font = UIFont.systemFontOfSize(14)
            self.contentView.addSubview(label)
            label.snp_makeConstraints { (make) -> Void in
                make.centerX.equalTo(self.contentView.snp_centerX)
                make.top.equalTo(loginButton!.snp_bottom).offset(20)
            }
        }else {
            ///已经登录，显示tableview
            tableView = UITableView(frame: CGRectMake(89,-89,self.frame.size.height,SCREENWIDTH))
            tableView!.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
            //print(tableView.frame)
            tableView!.separatorStyle = .None
            tableView!.rowHeight = 150
            tableView!.registerNib(UINib(nibName: "MyFocusTableViewCell", bundle: nil), forCellReuseIdentifier: "MyFocusTableViewCell")
            tableView!.showsHorizontalScrollIndicator = false
            tableView!.showsVerticalScrollIndicator = false
            self.clipsToBounds = false
            ///改变cell的width
            var rect = self.frame
            rect.size.width = SCREENWIDTH
            self.frame = rect
            //var rect = self.tableView.frame
            //        rect.size.width =
            //(0.0, 50.0, 375.0, 197.0)
            
            //        print("self.frame = \(self.frame)")
            self.contentView.addSubview(tableView!)
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
