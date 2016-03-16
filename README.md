<h1 align="center"> The-Red-Button-Swift </h1> 

>A Swift version of the App Store featured game - Don't tap the red button in less than 100 lines

<p align="center">
</p>
<!--<p align="center">-->
<!--        <img src="https://cloud.githubusercontent.com/assets/6619146/13851120/43e238e0-ec33-11e5-8ba0-0cf5f0f230d7.png" height="100" width="100" />-->
</p>
<p align="center">
        <img src="https://cloud.githubusercontent.com/assets/6619146/13851445/969aeebe-ec34-11e5-90a5-5f4ca46e295a.gif" height="210" width="375" />
</p>

##Idea of Implementation
### Changing the button color
What you need is a NSTimer keep firing the method that turns the button color:
```swift
NSTimer.scheduledTimerWithTimeInterval(Constants.blinkingInterval, target: self, selector: Selector("turnButtonColor"),userInfo: nil, repeats: true)
```
In the turn color method change the button randomly:
```swift
func turnButtonColor(){
        color = arc4random_uniform(UInt32(2)+1) //get a random number between 1 and 2
        if color==1{
            tapButton.imageView?.image = UIImage(named: "bluebutton") 
        }else{
            tapButton.imageView?.image = UIImage(named: "redbutton")
        }
    }
```
###Scaling the button

```swift
//Set up a target action for UIButton
func setUpScalingButton(){
        tapButton.layer.cornerRadius = tapButton.frame.width/2
        tapButton.addTarget(self, action: Selector("touchedDown"), forControlEvents: UIControlEvents.TouchDown)
        tapButton.addTarget(self, action: Selector("touchedUp"), forControlEvents: UIControlEvents.TouchUpInside)
        }
```
```swift
//Transform the scale base on each action
    func touchedDown(){
        let scale:CGFloat = Constants.buttonScaleRatio
        self.tapButton.transform = CGAffineTransformMakeScale(scale, scale)
    }
    func touchedUp(){
            self.tapButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }
```
###Saving & Updating High Score
```swift
lazy var prefs = NSUserDefaults.standardUserDefaults()
if let highScore=prefs.valueForKey("highScore") as? Int where highScore > count{
        //when current score smaller than highscore
            highScoreLabel.text="High Score: \(highScore)"
        }else{
        //when current score break the record or this is first game playt
            highScoreLabel.text="High Score: \(count)"
            prefs.setValue(count, forKey: "highScore")
            highScoreLabel.textColor = UIColor.greenColor()
            prefs.synchronize()
        }
```

That is all you need to know to build a featured game on App Store.

Gaming design sometimes is more important than technical expertise.

##MIT license

Copyright (c) 2016 Chenglin


