//
//  ViewController.swift
//  weather forecast
//
//  Created by 迫 佑樹 on 2015/12/29.
//  Copyright © 2015年 迫 佑樹. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var resultLabel: UILabel!
    
    @IBOutlet var cityLabel: UILabel!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        cityLabel.text = cityTextField.text
        
        cityTextField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func findWeather(sender: AnyObject) {
        super.viewDidLoad()
        
        var success = false
        
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        if let url = attemptedUrl {
        
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
                if let urlContent = data {
                    //データがnilではない
                
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                    let websiteArray = webContent?.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                
                    if websiteArray!.count > 1 {
                    
                        let weatherArray = websiteArray![1].componentsSeparatedByString("</span>")
                    
                        if weatherArray.count > 1 {
                        
                            let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "°")
                        
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                success = true
                                
                                self.resultLabel.text = weatherSummary
                            })
                        }
                    }
                }
            }
        
            task.resume()
        
            if success == false{
                self.resultLabel.text = "Sorry, something went wrong."
            }
        
        
        
        }
    }
    
    
        
    override func viewDidLoad() {
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    



}

