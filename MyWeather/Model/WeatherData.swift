//
//  WeatherData.swift
//  MyWeather
//
//  Created by Игорь Моренко on 10.10.15.
//  Copyright © 2015 LionSoft LLC. All rights reserved.
//

import UIKit

class WeatherData: NSObject {

    var nowTemp = "-1"
    var nowWeather = "-0-"
    var nowWindSpeed = "30"
    var nowPressure = "780"
    
    var todayTemps = ["morn": "-1", "day": "3", "eve": "0", "night": "-5"]
    
    var nextTemp = ["+1", "+2", "+3", "+4", "+5", "+6"]
    var nextWeather = ["-1-", "-2-", "-3-", "-4-", "-5-", "-6-"]

    static let cities = ["Moscow", "Tula"]
    static let cityNames = ["Москва", "Тула"]
    
    let urlPath = NSURL(string: "http://api.openweathermap.org/data/2.5/")
    
   func getData(city: Int, controller: WeatherDataProtocol) {
        
        let session = NSURLSession.sharedSession()

        let weatherUrl = NSURL(string: "weather?q=\(WeatherData.cities[city])&mode=json&units=metric&APPID=d1c9745179e1566578438f0f6fd39399", relativeToURL: urlPath)
        let task1 = session.dataTaskWithURL(weatherUrl!, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            print(response)
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            if data != nil {
                let jsonData = JSON(data: data!)
                
                if let nowTemp = jsonData["main"]["temp"].double {
                    self.nowTemp = "\(Int( round(nowTemp) ))"
                }

                if let nowWindSpeed = jsonData["wind"]["speed"].int {
                    
                    let convert = round( Double(nowWindSpeed) * 3.6 )
                    self.nowWindSpeed = "\(Int(convert))"
                }
                
                if let nowPressure = jsonData["main"]["pressure"].int {
                    self.nowPressure = "\(nowPressure)"
                }
                
                self.nowWeather = jsonData["weather"][0]["main"].string ?? "?"
            
                print("update data")
                controller.update();
            }
        })
        task1.resume()
        
        let forecastDailyUrl = NSURL(string: "forecast/daily?q=\(WeatherData.cities[city])&mode=json&units=metric&cnt=6&APPID=d1c9745179e1566578438f0f6fd39399", relativeToURL: urlPath)
        let task2 = session.dataTaskWithURL(forecastDailyUrl!, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            print(response)
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            if data != nil {
                let jsonData = JSON(data: data!)
            
                func convertToRoundInt(d: Double?) -> Int {
                    return Int( round(d ?? 777.0) )
                }
                
                let night = convertToRoundInt(jsonData["list"][0]["temp"]["night"].double)
                let morn = convertToRoundInt(jsonData["list"][0]["temp"]["morn"].double)
                let day = convertToRoundInt(jsonData["list"][0]["temp"]["day"].double)
                let eve = convertToRoundInt(jsonData["list"][0]["temp"]["eve"].double)
            
                self.todayTemps["night"] = "\(night)"
                self.todayTemps["morn"] = "\(morn)"
                self.todayTemps["day"] = "\(day)"
                self.todayTemps["eve"] = "\(eve)"
            
                let count = jsonData["cnt"].int ?? 0
                for i in 0..<count {
                
                    var nextTemp = [Double]()
                
                    if let night = jsonData["list"][i]["temp"]["night"].double {
                        nextTemp.append(night)
                    }
                
                    if let morn = jsonData["list"][i]["temp"]["morn"].double {
                        nextTemp.append(morn)
                    }
                
                    if let day = jsonData["list"][i]["temp"]["day"].double {
                        nextTemp.append(day)
                    }
                
                    if let eve = jsonData["list"][i]["temp"]["eve"].double {
                        nextTemp.append(eve)
                    }
                
                    if nextTemp.count != 0 {
                        let summ = round( nextTemp.reduce(0, combine: +) / Double(nextTemp.count) )
                        self.nextTemp[i] = "\(Int(summ))"
                    }
                
                    self.nextWeather[i] = jsonData["list"][i]["weather"][0]["main"].string ?? "?"
                }
                print("update data")
                controller.update();
            }
        })
        task2.resume()
        
//        controller.update();
        
        
    }
}
