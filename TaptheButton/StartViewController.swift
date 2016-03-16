//
//  StartViewController.swift
//  TaptheButton
//
//  Created by Chenglin Liu on 3/16/16.
//  Copyright © 2016 Chenglin Liu. All rights reserved.
//

import UIKit
import GameKit

class StartViewController: UIViewController ,GKGameCenterControllerDelegate {

    @IBOutlet weak var startButton: UIButton!
    var score: Int = 0 // Stores the score
    var gcEnabled = Bool() // Stores if the user has Game Center enabled
    var gcDefaultLeaderBoard = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = startButton.frame.width/2
        #if DEBUG
            print("Debug mode")
        #else
            self.authenticateLocalPlayer()
        #endif
    }
    
//MARK: Game Center
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer: String?, error: NSError?) -> Void in
                    if let error = error {
                        print(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                } as? (String?, Error?) -> Void)
                
                
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated, disabling game center")
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func showLeaderboard(_ sender: UIButton) {
        if !gcEnabled {
            authenticateLocalPlayer()
        }
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.leaderboards
        gcVC.leaderboardIdentifier = "LeaderboardID"
        self.present(gcVC, animated: true, completion: nil)
    }
    @IBAction func rateApp(_ sender: UIButton){
        UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/app/dont-tap-the-red-button/id1094754084")!)
    }
}
