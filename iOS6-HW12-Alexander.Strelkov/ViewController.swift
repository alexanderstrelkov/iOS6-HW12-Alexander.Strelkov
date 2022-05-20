//
//  ViewController.swift
//  iOS6-HW12-Alexander.Strelkov
//
//  Created by Alexandr Strelkov on 20.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let workingTime = 1500
    let restTime = 300
    var secondsRemaining = 4
    var timer = Timer()
    
    //MARK: - Outlets
    
    @IBOutlet weak var animatingTimerLabel: UILabel!
    
    @IBAction func playPauseButton(_ sender: UIButton) {
        
        timer.invalidate()
        
        secondsRemaining = 1500
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCircularProgressBarView()
    }
    
    //MARK: Timer function
    
    @objc func updateTimer() {
        var minutes: Int
        var seconds: Int
        
        minutes = (secondsRemaining % 3600) / 60
        seconds = (secondsRemaining % 3600) % 60
        if secondsRemaining > 0 {
            animatingTimerLabel.text = String(format: "%02d:%02d", minutes, seconds)
            secondsRemaining -= 1
        } else {
            timer.invalidate()
            animatingTimerLabel.sizeToFit()
            animatingTimerLabel.text = "Done!"
        }
    }
    
    //MARK: CircularBar
    
    var circularProgressBarView: CircularProgressBarView!
    var circularViewDuration: TimeInterval = 2
    
    func setUpCircularProgressBarView() {
        // set view
        circularProgressBarView = CircularProgressBarView(frame: .zero)
        // align to the center of the screen
        circularProgressBarView.center = view.center
        // call the animation with circularViewDuration
        circularProgressBarView.createCircularPath()
        circularProgressBarView.progressAnimation(duration: circularViewDuration)
        // add this view to the view controller
        view.addSubview(circularProgressBarView)
    }
    
}

