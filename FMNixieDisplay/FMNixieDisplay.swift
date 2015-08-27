//
//  FMNixieDisplay.swift
//  FMNixieDisplay
//
//  Created by Simon Gladman on 27/08/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit

let digitWidth = 175 / 3
let digitHeight = 300 / 3

class FMNixieDigitDisplay: UIView
{
    private var numberOfDigits: Int
    private var nixieDigits = [FMNixieDigit]()
    
    required init(numberOfDigits: Int)
    {
        self.numberOfDigits = numberOfDigits
        
        super.init(frame: CGRect(x: 0, y: 0, width: numberOfDigits * digitWidth, height: digitHeight))
        
        backgroundColor = UIColor.darkGrayColor()
        
        for i in 0 ..< numberOfDigits
        {
            let digitWidget = FMNixieDigit()
            digitWidget.value = i
            
            nixieDigits.insert(digitWidget, atIndex: 0)
            insertSubview(digitWidget, atIndex: 0)
            
            digitWidget.frame = CGRect(x: i * digitWidth, y: 0, width: digitWidth, height: digitHeight)
        }
    }

    func setValue(string value: String)
    {
        guard value.characters.count <= numberOfDigits else
        {
            showError()
            return
        }
        
        for (i, char) in value.characters.enumerate()
        {

            if let intValue = Int(String(char))
            {
                nixieDigits[numberOfDigits - i - 1].value = intValue
            }
            else if char  == "."
            {
                nixieDigits[numberOfDigits - i - 1].displayDecimalPoint()
            }
            else if char == "-"
            {
                nixieDigits[numberOfDigits - i - 1].displayDash()
            }
            else
            {
                nixieDigits[numberOfDigits - i - 1].value = nil
            }   
        }
        
        for i in value.characters.count ..< numberOfDigits
        {
            nixieDigits[i].value = nil
        }

    }
    
    func setValue(float value: Float)
    {
        let numberOfChars = Int(ceil(log10(Double(value))))
        
        guard numberOfChars <= numberOfDigits else
        {
            showError()
            return
        }
        
        for i in 0 ..< numberOfChars
        {
            let digitValue = floor((Double(value) / pow(10.0, Double(i)))) % 10
            
            nixieDigits[numberOfDigits - numberOfChars + i].value = Int(digitValue)
        }
        
        if numberOfDigits - numberOfChars - 1 >= 0
        {
            nixieDigits[numberOfDigits - numberOfChars - 1].displayDecimalPoint()
        }
        
        for i in (numberOfDigits - numberOfChars - 1).stride(to: 0, by: -1)
        {
            let digitValue = modf(value).1 * pow(10.0, Float(numberOfDigits - numberOfChars - i)) % 10
            
            if i - 1 >= 0
            {
                nixieDigits[i - 1].value = Int(digitValue)
            }
        }
    }
    
    func setValue(int value: Int)
    {
        let numberOfChars = Int(ceil(log10(Double(value))))
        
        guard numberOfChars <= numberOfDigits else
        {
            showError()
            return
        }
        
        for i in 0 ..< numberOfChars
        {
            let digitValue = floor((Double(value) / pow(10.0, Double(i)))) % 10
            
            nixieDigits[i].value = Int(digitValue)
        }
        
        for i in numberOfChars ..< numberOfDigits
        {
            nixieDigits[i].value = nil
        }
    }
    
    func showError()
    {
        for digitWidget in nixieDigits
        {
            digitWidget.displayDash()
        }
    }
    
    override func intrinsicContentSize() -> CGSize
    {
        return CGSize(width: numberOfDigits * digitWidth, height: digitHeight)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

class FMNixieDigit: UIView
{
    let offImage = UIImage(named: "off.png")
    let dotImage = UIImage(named: "dot.png")
    let dashImage = UIImage(named: "dash.png")
    
    let evenDigitView = UIImageView()
    let oddDigitView = UIImageView()
    
    let animationOptions = UIViewAnimationOptions(rawValue: UIViewAnimationOptions.CurveEaseOut.rawValue | UIViewAnimationOptions.TransitionCrossDissolve.rawValue)
    
    var useEven = true
    
    required init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: digitWidth, height: digitHeight))
        
        oddDigitView.image = offImage
    }
    
    func displayImage(image: UIImage)
    {
        if useEven
        {
            evenDigitView.image = image
            
            UIView.transitionFromView(oddDigitView, toView: evenDigitView, duration: 0.5, options: animationOptions, completion: nil)
        }
        else
        {
            oddDigitView.image = image
            
            UIView.transitionFromView(evenDigitView, toView: oddDigitView, duration: 0.5, options: animationOptions, completion: nil)
        }
        
        useEven = !useEven
    }
    
    func displayDash()
    {
        displayImage(dashImage!)
    }
    
    func displayDecimalPoint()
    {
        displayImage(dotImage!)
    }
    
    var value: Int?
    {
        didSet
        {
            displayImage(UIImage(named: String(format: "%i.png", value ?? -1)) ?? offImage!)
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview()
    {
        super.didMoveToSuperview()
        
        evenDigitView.frame = bounds
        oddDigitView.frame = bounds
        
        addSubview(oddDigitView)
    }
}