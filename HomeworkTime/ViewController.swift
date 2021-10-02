//
//  ViewController.swift
//  HomeworkTime
//
//  Created by Александр Горденко on 30.09.2021.
//

import UIKit

class ViewController: UIViewController {
    var isWorkTime: Bool = true
    var isStarted: Bool = false
    var timer: Timer?
    let durationWork: TimeInterval = 25 * 60 // 25 minutes
    let durationRest: TimeInterval = 5 * 60 // 5 minutes
    var durationInAction: TimeInterval = 25 * 60
    
    private lazy var progressCustom: CircularProgressBarView = {
        let circularProgressBarView = CircularProgressBarView(frame: .zero)
        circularProgressBarView.createCircularPath()
        circularProgressBarView.setColor(color: isWorkTime ? UIColor.systemGreen.cgColor : UIColor.systemOrange.cgColor)
        return circularProgressBarView
    }()
    
    private lazy var timeLabel: UILabel = {
        var label = UILabel()
        label.text = formatTimeToString(time: durationInAction)
        label.font = UIFont(name: "Arial", size: 50)
        label.textColor = isWorkTime ? .systemGreen : .systemOrange
        return label
    }()
    
    private lazy var buttonPlay: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
        button.tintColor = isWorkTime ? .systemGreen : .systemOrange
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }
    
    func setupHierarchy() {
        view.addSubview(timeLabel)
        view.addSubview(buttonPlay)
        view.addSubview(progressCustom)
    }
    
    func setupLayout() {
        // progress
        progressCustom.center = view.center
        progressCustom.translatesAutoresizingMaskIntoConstraints = false
        progressCustom.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressCustom.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        // position label
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        // position button
        buttonPlay.translatesAutoresizingMaskIntoConstraints = false
        buttonPlay.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonPlay.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
    }
    
    @objc func buttonAction() {
        if isStarted {
            if timer != nil {
                timer?.invalidate()
                timer = nil
                isStarted = false
                progressCustom.stopAnimate()
            }
        } else {
            setTimer()
        }
        
        updateIconButton()
    }
    
    func formatTimeToString(time: TimeInterval) -> String {
        let ti = Int(time)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        return String(format: "%0.2d:%0.2d%", minutes, seconds)
    }
    
    @objc func updateTimer() {
        durationInAction -= 0.1
        updateValueButton()
        if(durationInAction < 0) {
            timer?.invalidate()
            timer = nil
            isStarted = false
            clearProgress()
            changeState()
        }
    }
    
    func setTimer() {
        if timer == nil {
            isStarted = true
            progressCustom.startProgressAnimate(from: 0.0, to: 1.0, duration: durationInAction)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    func changeState() {
        changeTimeState()
        changeColorState()
    }
    
    func changeTimeState() {
        if(isWorkTime) {
            isWorkTime = false
            durationInAction = durationRest
        } else {
            isWorkTime = true
            durationInAction = durationWork
        }
        
        updateValueButton()
        updateIconButton()
    }
    
    func changeColorState() {
        if(isWorkTime) {
            timeLabel.textColor = .systemGreen
            buttonPlay.tintColor = .systemGreen
            progressCustom.setColor(color: UIColor.systemGreen.cgColor)
        } else {
            timeLabel.textColor = .systemOrange
            buttonPlay.tintColor = .systemOrange
            progressCustom.setColor(color: UIColor.systemOrange.cgColor)
        }
    }
    
    func updateValueButton() {
        timeLabel.text = formatTimeToString(time: durationInAction)
    }
    
    func updateIconButton() {
        buttonPlay.setImage(UIImage(systemName: isStarted ? "pause" : "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
    }
    
    func clearProgress() {
        progressCustom.startProgressAnimate(from: 1.0, to: -0.5, duration: 1)
    }
}
