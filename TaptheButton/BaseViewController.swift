//
//  BaseViewController.swift
//  TaptheButton
//
//  Created by Chenglin Liu on 3/16/16.
//  Copyright © 2016 Chenglin Liu. All rights reserved.
//

import UIKit
import GameKit

private struct Constants {
    static let blinkingInterval = 0.25
    static let buttonScaleRatio:CGFloat = 0.9
}

class BaseViewController: UIViewController {
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var restartStackView: UIStackView!
    @IBOutlet weak var highScoreLabel: UILabel!
    private var count = 0
    private var color: UInt32 = 1
    private var timer = Timer()
    private lazy var prefs = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScalingButton()
        setUpGame()
    }
    
    private func setUpGame(){
        count = 0
        scoreLabel.text = "Score: \(count)"
        timer = Timer.scheduledTimer(timeInterval: Constants.blinkingInterval, target: self, selector: #selector(BaseViewController.turnButtonColor),userInfo: nil, repeats: true)
        tapButton.imageView?.image = UIImage(named: "bluebutton")
        gameOverLabel.text = "BOOM!"
        gameOverLabel.isHidden = true
        restartStackView.isHidden = true
        highScoreLabel.isHidden = true
        highScoreLabel.textColor = UIColor.black
    }
    
    private func gameOver(){
        timer.invalidate()
        highScoreLabel.isHidden = false
        tapButton.imageView?.image = UIImage(named: "redbutton")
        if let highScore=prefs.value(forKey: "highScore") as? Int, highScore > count{
            highScoreLabel.text="Best: \(highScore)"
            submitScoreToGC(highScore)
        }else{
            highScoreLabel.text="Best: \(count)"
            prefs.setValue(count, forKey: "highScore")
            submitScoreToGC(count)
            highScoreLabel.textColor = UIColor.green
            prefs.synchronize()
        }
        if (count>=5){
            gameOverLabel.text="Lucky"
        }else if(count>10 && count<15){
            gameOverLabel.text="Pro"
        }else if(count>15){
            gameOverLabel.text="Master"
        }
        gameOverLabel.isHidden = false
        restartStackView.isHidden = false
    }
    

//MARK: IBActions for each buttons
    
    @IBAction func restartTapped(_ sender: AnyObject) {
        setUpGame()
    }
    @IBAction func exitTapped(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil)
    }
 
//MARK: Scaling button
    private func setUpScalingButton(){
        tapButton.layer.cornerRadius = tapButton.frame.width/2
        tapButton.addTarget(self, action: #selector(BaseViewController.touchedDown), for: UIControlEvents.touchDown)
        tapButton.addTarget(self, action: #selector(BaseViewController.touchedUp), for: UIControlEvents.touchUpInside)
        tapButton.addTarget(self, action: #selector(BaseViewController.touchedUp), for: UIControlEvents.touchUpOutside)
    }
    
    @objc private func touchedDown(){
        let scale:CGFloat = Constants.buttonScaleRatio
        self.tapButton.transform = CGAffineTransform(scaleX: scale, y: scale)
        guard color==1 else{
            gameOver()
            return
        }
        count += 1
        scoreLabel.text = "Score :\(count)"
    }
    @objc private func touchedUp(){
        tapButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
    }
    
    @objc private func turnButtonColor(){
        color = arc4random_uniform(UInt32(2)+1)
        if color==1{
            tapButton.imageView?.image = UIImage(named: "bluebutton")
            
        }else{
            tapButton.imageView?.image = UIImage(named: "redbutton")
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    //MARK: GameCenter
    private func submitScoreToGC(_ score: Int) {
        let leaderboardID = "buttonLeaderboard"
        let sScore = GKScore(leaderboardIdentifier: leaderboardID)
        sScore.value = Int64(score)
        GKScore.report([sScore], withCompletionHandler: { (error: Error?) -> Void in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Score submitted")
            }
        })
    }
}

