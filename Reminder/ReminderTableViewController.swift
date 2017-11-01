//
//  ReminderTableViewController.swift
//  Reminder
//
//  Created by Ashutosh Singh on 27/07/17.
//  Copyright © 2017 Ashutosh Singh. All rights reserved.
//

import UIKit

class ReminderTableViewController: UITableViewController {

    var reminders = [Reminder]()
    let dateFormatter = DateFormatter()
    let locale = Locale.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
       
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        if let savedReminders = loadReminders(){
            reminders += savedReminders
        }
        tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminders.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)

        // Configure the cell...
        let reminder = reminders[indexPath.row]
        cell.textLabel?.text = reminder.name
        cell.detailTextLabel?.text = "Due " + dateFormatter.string(from: reminder.time as Date)
        
        // Make due date red if overdue
        if (Date() as NSDate).earlierDate(reminder.time as Date) == reminder.time as Date {
            cell.detailTextLabel?.textColor = UIColor.red
        }
        else {
            cell.detailTextLabel?.textColor = UIColor.blue
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _ = reminders.remove(at: indexPath.row)
           
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
           saveReminders()
            tableView.reloadData()
        }
    }
    @IBAction func unwindToReminderList(sender: UIStoryboardSegue){
        if let sourceView = sender.source as? AddReminderViewController,let reminder = sourceView.reminder{
            let newIndexPath = NSIndexPath(row: reminders.count, section: 0)
            reminders.append(reminder)
            tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
            saveReminders()
            tableView.reloadData()
        }
    }
  
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func saveReminders(){
        let isSucessfulSave = NSKeyedArchiver.archiveRootObject(reminders, toFile: Reminder.ArchiveURL.path)
        if (isSucessfulSave){ print("Saved Reminder Sucessfully")}
     
        else{print("Failed to save reminders")}
    }
    func loadReminders() -> [Reminder]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Reminder.ArchiveURL.path) as? [Reminder]
    }
}
