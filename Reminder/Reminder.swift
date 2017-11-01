//
//  Reminder.swift
//  Reminder
//
//  Created by Ashutosh Singh on 27/07/17.
//  Copyright © 2017 Ashutosh Singh. All rights reserved.
//

import Foundation
import UIKit


class Reminder: NSObject,NSCoding {
    var notification: UILocalNotification
    var name: String
    var time: NSDate
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory,in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("reminders")
    struct PropertyKey {
        static let namekey = "name"
        static let timekey = "time"
        static let notificationkey = "notification"
    }
    init(name: String, time: NSDate, notification: UILocalNotification){
        self.name = name
        self.time = time
        self.notification = notification
        super.init()
    }
    
    deinit {
        //cancel Notification
        UIApplication.shared.cancelLocalNotification(self.notification)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.namekey)
        aCoder.encode(time, forKey: PropertyKey.timekey)
        aCoder.encode(notification, forKey: PropertyKey.notificationkey)
    }
    required convenience init(coder aDecoder: NSCoder){
        let name = aDecoder.decodeObject(forKey: PropertyKey.namekey) as! String
        let time = aDecoder.decodeObject(forKey: PropertyKey.timekey) as! NSDate
        let notification = aDecoder.decodeObject(forKey: PropertyKey.notificationkey) as! UILocalNotification
        
        self.init(name: name, time: time, notification: notification)
    }
    


}
