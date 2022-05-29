//
//  ViewController.swift
//  iOS6-HW12-Alexander.Strelkov
//
//  Created by Alexandr Strelkov on 20.05.2022.
//

import UIKit

class ViewController: UIViewController {

    var secondsRemaining = Durations.workTime
    var timer = Timer()
    var isWorkTime = true
    var isStarted = false
    var isAnimationStarted = false
    
    //MARK: - Outlets
    
    @IBOutlet weak var animatingTimerLabel: UILabel!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBAction func playPauseButton(_ sender: UIButton) {
        
        cancelButton.isEnabled = true
        cancelButton.alpha = 1.0
        resetButton.isEnabled = false
        resetButton.alpha = 1.0
        
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
    
    @IBOutlet weak var resetButton: UIButton!
    @IBAction func resetButton(_ sender: UIButton) {
        secondsRemaining = Durations.workTime
    }
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButton(_ sender: UIButton) {
        circularProgressBarView.stopAnimation()
        isAnimationStarted = false
        isWorkTime = true
        cancelButton.isEnabled = false
        cancelButton.alpha = 0.5
        timer.invalidate()
        secondsRemaining = Durations.workTime
        isStarted = false
        animatingTimerLabel.text = "Start"
        playPauseButton.setImage(UIImage (systemName: "play"), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animatingTimerLabel.text = "Start"
    }
    
    //MARK: Timer function
    
    func formatTime() -> String {
        let minutes = Int(secondsRemaining) / 60 % 60
        let seconds = Int(secondsRemaining) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {

        if secondsRemaining > 0 {
            secondsRemaining -= 1
            animatingTimerLabel.text = formatTime()
        } else {
            cancelButton.isEnabled = false
            cancelButton.alpha = 0.5
            timer.invalidate()
            secondsRemaining = Durations.relaxTime
    
            isStarted = false
            isWorkTime = false
            isAnimationStarted = false
            animatingTimerLabel.sizeToFit()
            animatingTimerLabel.text = "Finish"
            playPauseButton.setImage(UIImage (systemName: "play"), for: .normal)
            resetButton.isEnabled = true
        }
    }
    
    
    //MARK: CircularBar
    
    var circularProgressBarView: CircularProgressBarView!
    
    func startResumeAnimation() {
        if !isAnimationStarted {
            setUpCircularProgressBarView()
        } else {
            circularProgressBarView.resumeAnimation()
        }
    }
    
    func setUpCircularProgressBarView() {
        // set view
        circularProgressBarView = CircularProgressBarView(frame: .zero)
        // align to the center of the screen
        circularProgressBarView.center = view.center
        // call the animation with circularViewDuration
        if isWorkTime {
            circularProgressBarView.createCircularPath()
        } else {
            circularProgressBarView.createRelaxCircularPath()
        }
        //        circularProgressBarView.createCircularPath()
        
        circularProgressBarView.progressAnimation(duration: secondsRemaining)
        isAnimationStarted = true
        // add this view to the view controller
        view.addSubview(circularProgressBarView)
    }
}

extension ViewController {
    enum Durations {
        static let workTime = 5.0
        static let relaxTime = 3.0
    }
}

