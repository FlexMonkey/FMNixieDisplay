//
//  ViewController.swift
//  FMNixieDisplay
//
//  Created by Simon Gladman on 27/08/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    let nixieDigitDisplay = FMNixieDigitDisplay(numberOfDigits: 8)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blackColor()
        
        view.addSubview(nixieDigitDisplay)
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerHandler", userInfo: nil, repeats: true)
    }

    func timerHandler()
    {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(
            NSCalendarUnit(rawValue: NSCalendarUnit.Hour.rawValue | NSCalendarUnit.Minute.rawValue | NSCalendarUnit.Second.rawValue),
            fromDate: date)
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        print(hour, minute, second)
        
        nixieDigitDisplay.setValue(string: "\(hour).\(minute)-\(second)")
    }
    
    override func viewDidLayoutSubviews()
    {
        nixieDigitDisplay.frame = CGRect(x: view.frame.width / 2 - nixieDigitDisplay.intrinsicContentSize().width / 2,
            y: view.frame.height / 2 - nixieDigitDisplay.intrinsicContentSize().height / 2,
            width: nixieDigitDisplay.intrinsicContentSize().width,
            height: nixieDigitDisplay.intrinsicContentSize().height)
    }

}

