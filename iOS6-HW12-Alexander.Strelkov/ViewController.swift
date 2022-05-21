//
//  ViewController.swift
//  iOS6-HW12-Alexander.Strelkov
//
//  Created by Alexandr Strelkov on 20.05.2022.
//

import UIKit

class ViewController: UIViewController {

    var secondsRemaining = 0
    var timer = Timer()
    var isWorkTime = true
    let workAndRelaxtimes = ["Work": 1500, "Relax": 300]
    
    //MARK: - Outlets
    
    @IBOutlet weak var animatingTimerLabel: UILabel!
    
    @IBAction func workButton(_ sender: UIButton) {
        secondsRemaining = workAndRelaxtimes["Work"] ?? 0
        workButtonLabel.setTitle("press PLAY", for: .normal)
    }
    
    @IBOutlet weak var workButtonLabel: UIButton!
    @IBOutlet weak var relaxButtonLabel: UIButton!
    
    @IBAction func relaxButton(_ sender: UIButton) {
        isWorkTime = false
        secondsRemaining = workAndRelaxtimes["Relax"] ?? 0
        relaxButtonLabel.setTitle("press PLAY", for: .normal)
    }
    
    @IBAction func playPauseButton(_ sender: UIButton) {

        timer.invalidate()
        if isWorkTime {
            setUpWorkCircularProgressBarView()
        } else {
            setUpRelaxCircularProgressBarView()
        }
        
        if isWorkTime {
            workButtonLabel.setTitle("Working", for: .normal)
        } else if !isWorkTime {
            relaxButtonLabel.setTitle("Relaxing..", for: .normal)
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Timer function
    
    @objc func updateTimer() {
        var minutes: Int
        var seconds: Int
        
        minutes = (secondsRemaining % 3600) / 60
        seconds = (secondsRemaining % 3600) % 60
        if secondsRemaining >= 0 {
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
    
    func setUpWorkCircularProgressBarView() {
        // set view
        circularProgressBarView = CircularProgressBarView(frame: .zero)
        // align to the center of the screen
        circularProgressBarView.center = view.center
        // call the animation with circularViewDuration
        circularProgressBarView.createWorkCircularPath()
        circularProgressBarView.progressAnimation(duration: Double(secondsRemaining))
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
        circularProgressBarView.progressAnimation(duration: Double(secondsRemaining))
        // add this view to the view controller
        view.addSubview(circularProgressBarView)
    }
}

