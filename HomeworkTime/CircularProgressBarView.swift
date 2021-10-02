//
//  CircularProgressBarView.swift
//  HomeworkTime
//
//  Created by Александр Горденко on 02.10.2021.
//

import UIKit

class CircularProgressBarView: UIView {
    // MARK: - Properties -
        
    enum statesOfAnimation {
        case animation
        case pause
    }
    
    private var circularPath = UIBezierPath()
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var shapeLayerItem = CAShapeLayer()
    private var shapeLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    private var circularProgressAnimation = CABasicAnimation()
    private var stateAnimation: statesOfAnimation = .animation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createCircularPath() {
        // created circularPath for circleLayer and progressLayer
        circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 120, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 8.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.systemGreen.cgColor
        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 8.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.systemGray.cgColor
        layer.addSublayer(progressLayer)
    }
    
    func setColor(color: CGColor) {
        circleLayer.strokeColor = color
    }
    
    func stopAnimate() {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        stateAnimation = .pause
    }
    
    func startProgressAnimate(from startValue: Float, to endValue: Float, duration: TimeInterval) {
        if stateAnimation == .animation {
            // created circularProgressAnimation with keyPath
            circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
            // set the end time
            circularProgressAnimation.duration = duration
            circularProgressAnimation.fromValue = startValue
            circularProgressAnimation.toValue = endValue
            circularProgressAnimation.fillMode = .forwards
            circularProgressAnimation.isRemovedOnCompletion = false
            progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        } else {
            let pausedTime = layer.timeOffset
            layer.speed = 1.0
            layer.timeOffset = 0.0
            layer.beginTime = 0.0
            let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            layer.beginTime = timeSincePause
            stateAnimation = .animation
        }
    }
}


