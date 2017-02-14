//
//  timeManager.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/3/30.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class timeManager: NSObject {
    class func showTime(model:homeModel) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd HH:mm:ss  yyyy"
        //现在时间
        //                public init(localeIdentifier string: String)
        let nowDate = NSDate()
        //创建时间
        let publishNumber = model.post["publish_time"] as! NSNumber
//        print("2=\(publishStr)")
        let i:NSTimeInterval = publishNumber as NSTimeInterval
        let publishDate = NSDate(timeIntervalSince1970: i)
//        let publishTime = dateFormatter.dateFromString(publishStr)
//        print("3=\(publishTime)")
        let calender = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = [NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day,NSCalendarUnit.Hour,NSCalendarUnit.Minute,NSCalendarUnit.Second]
        let components = calender.components(unit, fromDate: publishDate, toDate: nowDate, options: .WrapComponents)
        let timeShowStr:String
        if components.year < 1 {
            //                今年
            if calender.isDateInToday(publishDate) {
                if components.hour >= 1 {
                    let hStr = "\(components.hour)小时前"
                    dateFormatter.dateFormat = hStr
                    
                }else {
                    let mStr = "\(components.minute)分钟前"
                    dateFormatter.dateFormat = mStr
                }
            }else if calender.isDateInYesterday(publishDate) {
                dateFormatter.dateFormat = "昨天"
            }else {
                dateFormatter.dateFormat = "MM月dd日"
            }
        }else {
            dateFormatter.dateFormat = "yyyy年MM月dd日"
        }
        timeShowStr = dateFormatter.stringFromDate(publishDate)
        return timeShowStr
    }
}

