//
//  ViewController.swift
//  MyWeather
//
//  Created by Игорь Моренко on 10.10.15.
//  Copyright © 2015 LionSoft LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, WeatherDataProtocol {
    
    @IBOutlet weak var nowTemp: UILabel!
    @IBOutlet weak var nowWeather: UILabel!
    @IBOutlet weak var nowWindSpeed: UILabel!
    @IBOutlet weak var nowPreasure: UILabel!
    @IBOutlet weak var morn: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var eve: UILabel!
    @IBOutlet weak var night: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    let weatherData = WeatherData()
    
    var city = 0 //"Moscow"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        weatherData.getData(city, controller: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refresh(sender: AnyObject) {
        weatherData.getData(city, controller: self)
    }

    func update() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            // UI Updating code here.
            self.navigationTitle.title = WeatherData.cityNames[self.city];
        
            self.nowTemp.text = self.weatherData.nowTemp
            self.nowWeather.text = self.weatherData.nowWeather
            self.nowWindSpeed.text = self.weatherData.nowWindSpeed
            self.nowPreasure.text = self.weatherData.nowPressure
        
            self.morn.text = self.weatherData.todayTemps["morn"]
            self.day.text = self.weatherData.todayTemps["day"]
            self.eve.text = self.weatherData.todayTemps["eve"]
            self.night.text = self.weatherData.todayTemps["night"]
        
            self.tableView.reloadData()
        });
    }

//    func getDayOfWeek(today:String)->Int {
//        
//        let formatter  = NSDateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let todayDate = formatter.dateFromString(today)!
//        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
//        let myComponents = myCalendar.components(NSCalendarUnit.Weekday, fromDate: todayDate)
//        let weekDay = myComponents.weekday
//        return weekDay
//    }

    func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        // Returns date formatted as 12 hour time.
        let dateFormatter  = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    func dayStringFromTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter  = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(date)
    }
    
    func getDayOfWeek(todayDate: NSDate)->String {
        let weekdayName = ["воскресенье", "понедельник", "вторник", "среда", "четверг", "пятница", "суббота"]
        
//        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myCalendar = NSCalendar.currentCalendar()
        let myComponents = myCalendar.components(NSCalendarUnit.Weekday, fromDate: todayDate)
        let weekDay = myComponents.weekday
        
        return weekdayName[weekDay - 1]
    }
    
    func getDayOfWeekTomorrow(offset: Int)->String {
//        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myCalendar = NSCalendar.currentCalendar()
        let today = NSDate()
        let tomorrow = myCalendar.dateByAddingUnit([.Day], value: offset, toDate: today, options: [])!
        return getDayOfWeek(tomorrow)
    }
    
    // MARK: - Table View Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.nextTemp.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = weatherData.nextTemp[indexPath.row]
        cell.detailTextLabel?.text = getDayOfWeekTomorrow(indexPath.row)
        
        return cell
    }

}

