# FMNixieDisplay
Nixie Tube Display Component on Swift

Companion project to this post: http://flexmonkey.blogspot.co.uk/2015/08/a-swift-nixie-tube-display-component.html

 I’m a chap of a certain age who can still remember Nixie Tubes in common use: when I was growing up we had a digital clock that displayed the time with them and, back then, it was the height of technical sophistication. When I stumbled across these assets, I couldn’t resist creating a simple Swift component to display numbers and simple strings in an extremely skeuomorphic, retro style.

My FMNixieDigitDisplay component is super easy to implement: after constructing an instance and adding it to a target view:

```swift
    let nixieDigitDisplay = FMNixieDigitDisplay(numberOfDigits: 8)
    view.addSubview(nixieDigitDisplay)
```

Its intrinsicContentSize can be used for sizing and positing. Here, I centre it on its parent view:

```swift
    nixieDigitDisplay.frame = CGRect(
        x: view.frame.width / 2 - nixieDigitDisplay.intrinsicContentSize().width / 2,
        y: view.frame.height / 2 - nixieDigitDisplay.intrinsicContentSize().height / 2,
        width: nixieDigitDisplay.intrinsicContentSize().width,
        height: nixieDigitDisplay.intrinsicContentSize().height)
```

The component has three setValue functions which support integers, floats or simple strings:

```swift
    nixieDigitDisplay.setValue(int: 1234)
    nixieDigitDisplay.setValue(float: 123.456)
    nixieDigitDisplay.setValue(string: "12.34-56")
```

The only non-numeric characters the display supports are dashes and dots. Any other characters will be displayed as an empty space.

The FMNixieDigitDisplay component contains an array of FMNixieDigit which display the individual digits. To get the smooth cross fade as the digit changes, I use UIView.transitionFromView to transition between two UIImageView instances.

For example, when the FMNixieDigit is first created, its useEven Boolean property is set to true and of its two image views evenDigitView and oddDigitView, only oddDigitView has been added to the view. When its value changes, it sets the image property of evenDigitView and executes:

```swift
    UIView.transitionFromView(oddDigitView, toView: evenDigitView, duration: 0.5, options: animationOptions, completion: nil)
```

This code removes oddDigitView from its superview and adds evenDigitView to that same superview with a dissolve. By toggling useEven with each change, I get a smooth transition with each time.

When I first started writing FMNixieDigitDisplay, my only thought was displaying integers, so its setValue(Int) uses the base 10 logarithm of the value to figure out how many characters are required and then iterates that many times, progressively raising it to increasing powers of ten to find the current digit with a modulo 10:

```swift
    let numberOfChars = Int(ceil(log10(Double(value))))

    for i in 0 ..< numberOfChars
    {
        let digitValue = floor((Double(value) / pow(10.0, Double(i)))) % 10
        
        nixieDigits[i].value = Int(digitValue)
    }
```

I then thought it would be nice to support floating point numbers, so added more code break up the value into its integer part of fractional part using modf() and striding backwards through the fractional part:

```swift
    for i in (numberOfDigits - numberOfChars - 1).stride(to: 0, by: -1)
    {
        let digitValue = modf(value).1 * pow(10.0, Float(numberOfDigits - numberOfChars - i)) % 10
        
        if i - 1 >= 0
        {
            nixieDigits[i - 1].value = Int(digitValue)
        }
    }
```

Finally, I decided to add a setValue(String) to display simple strings consisting of numbers, dots and dashes. This iterates of the value’s characters and sets each digit accordingly. With hindsight, both the integer and float implementations of setValue() could have used this technique and kept the code a whole lot simpler. However, I’m quite fond of those first two functions and since this isn’t production code, I’ve kept all the code in.

The demonstration view controller code uses an NSTimer to update an instance of FMNixieDigitDisplay every second with the current time. Here, I break up an NSDate into its component parts and form a string to display the time:

```swift
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
```

All the code for this component is available at my GitHub repository here. If you plan to use this commercially, please pay attention to the usage notes for the assets here. Enjoy!
