//
//  CitySelectViewController.swift
//  MyWeather
//
//  Created by Игорь Моренко on 11.10.15.
//  Copyright © 2015 LionSoft LLC. All rights reserved.
//

import UIKit

class CitySelectViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selected(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Picker View Data Source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return WeatherData.cityNames.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return WeatherData.cityNames[row]
    }
}
