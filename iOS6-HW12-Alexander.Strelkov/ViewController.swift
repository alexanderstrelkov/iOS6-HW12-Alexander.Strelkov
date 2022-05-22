//
//  ViewController.swift
//  iOS6-HW12-Alexander.Strelkov
//
//  Created by Alexandr Strelkov on 20.05.2022.
//

import UIKit

class ViewController: UIViewController {

    var secondsRemaining = 0.0
    var timer = Timer()
    var isWorkTime = true
    var isStarted = false
    var isAnimationStarted = false
    
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var animatingTimerLabel: UILabel!
    
    @IBAction func workButton(_ sender: UIButton) {
        relaxButtonLabel.isEnabled = false
        secondsRemaining = Durations.workTime
        workButtonLabel.setTitle("press PLAY", for: .normal)
    }
    
    @IBOutlet weak var workButtonLabel: UIButton!
    @IBOutlet weak var relaxButtonLabel: UIButton!
    
    @IBAction func relaxButton(_ sender: UIButton) {
        workButtonLabel.isEnabled = false
        isWorkTime = false
        secondsRemaining = Durations.relaxTime
        relaxButtonLabel.setTitle("press PLAY", for: .normal)
       
    }
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBAction func playPauseButton(_ sender: UIButton) {

        cancelButton.isEnabled = true
        cancelButton.alpha = 1.0
        
        if !isStarted {
            startTimer()
            startResumeAnimation()
            isStarted = true
            playPauseButton.setImage(UIImage (systemName: "pause"), for: .normal)
        } else {
            circularProgressBarView.pauseAnimation()
            timer.invalidate()
            isStarted = false
            playPauseButton.setImage(UIImage (systemName: "play"), for: .normal)
        }

    }
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancelButton(_ sender: UIButton) {
        circularProgressBarView.stopAnimation()
        isAnimationStarted = false
        isWorkTime = true
        cancelButton.isEnabled = false
        relaxButtonLabel.isEnabled = true
        workButtonLabel.isEnabled = true
        cancelButton.alpha = 0.5
        timer.invalidate()
        secondsRemaining = 0
        isStarted = false
        animatingTimerLabel.text = ""
        workButtonLabel.setTitle("Work", for: .normal)
        relaxButtonLabel.setTitle("Relax", for: .normal)
        playPauseButton.setImage(UIImage (systemName: "play"), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Timer function
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        var minutes: Int
        var seconds: Int
        
        minutes = (Int(secondsRemaining) % 3600) / 60
        seconds = (Int(secondsRemaining) % 3600) % 60
        if secondsRemaining > 0 {
            animatingTimerLabel.text = String(format: "%02d:%02d", minutes, seconds)
            secondsRemaining -= 1
        } else {
            timer.invalidate()
            animatingTimerLabel.sizeToFit()
            animatingTimerLabel.text = "Done!"
            workButtonLabel.setTitle("Work", for: .normal)
            relaxButtonLabel.setTitle("Relax", for: .normal)
            playPauseButton.setImage(UIImage (systemName: "play"), for: .normal)
        }
    }
    
    
    //MARK: CircularBar
    
    var circularProgressBarView: CircularProgressBarView!
    
    func startResumeAnimation() {
        if !isAnimationStarted && isWorkTime {
            setUpWorkCircularProgressBarView()
        } else if !isAnimationStarted && !isWorkTime {
            setUpRelaxCircularProgressBarView()
        } else {
            circularProgressBarView.resumeAnimation()
        }
    }
        
    func setUpWorkCircularProgressBarView() {
        // set view
        circularProgressBarView = CircularProgressBarView(frame: .zero)
        // align to the center of the screen
        circularProgressBarView.center = view.center
        // call the animation with circularViewDuration
        circularProgressBarView.createWorkCircularPath()
        circularProgressBarView.progressAnimation(duration: secondsRemaining)
        isAnimationStarted = true
        // add this view to the view controller
        view.addSubview(circularProgressBarView)
    }
    
    func setUpRelaxCircularProgressBarView() {
        // set view
        circularProgressBarView = CircularProgressBarView(frame: .zero)
        // align to the center of the screen
        circularProgressBarView.center = view.center
        // call the animation with circularViewDuration
        circularProgressBarView.createRelaxCircularPath()
        circularProgressBarView.progressAnimation(duration: secondsRemaining)
        isAnimationStarted = true
        // add this view to the view controller
        view.addSubview(circularProgressBarView)
    }
    
}

extension ViewController {
    enum Durations {
        static let workTime = 1500.0
        static let relaxTime = 300.0
    }
}

