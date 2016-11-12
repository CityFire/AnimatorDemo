//
//  ViewController.swift
//  AnimatorDemo
//
//  Created by wjc on 16/9/25.
//  Copyright © 2016年 wjc. All rights reserved.
//  后者优先：UIViewPropertyAnimator 实例中靠后添加的动画或者执行时间更晚的动画会覆盖之前的效果。

import UIKit

class ViewController: UIViewController {

    // 记录拖动时的圆形视图 center
    var cirleCenter: CGPoint!
    // 我们将在拖拽响应事件上附加不同的动画
    var circleAnimator: UIViewPropertyAnimator!
    let animationDuration = 4.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 添加可拖动的视图
        let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        circle.center = self.view.center
        circle.layer.cornerRadius = 50.0
        circle.backgroundColor = UIColor.green
        
        // 添加拖动手势
        circle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dragCircle)))
        
        // 可选动画参数
//        circleAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut, animations: { 
//            [unowned circle] in
//            // 放大两倍
//            circle.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
//        })
        
        circleAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut)

        
        self.view.addSubview(circle)
        
    }
    
    func dragCircle(gesture: UIPanGestureRecognizer)  {
        let target = gesture.view!
        switch gesture.state {
        case .began, .ended:
            cirleCenter = target.center
            
            let durationFactor = circleAnimator.fractionComplete  // 记录完成进度
            // 在原始进度上增加新动画
            circleAnimator.stopAnimation(false)
            circleAnimator.finishAnimation(at: .current)
            
//            if circleAnimator.isRunning {
//                circleAnimator.pauseAnimation()
//                circleAnimator.isReversed = gesture.state == .ended
//            }
//            circleAnimator.startAnimation()
            
            if circleAnimator.state == .active {
                // 使animator为inactive状态
                circleAnimator.stopAnimation(true)
            }
            
            if gesture.state == .began {
                circleAnimator.addAnimations({
                    target.backgroundColor = UIColor.green
                    target.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                })
            } else {
                circleAnimator.addAnimations({
                    target.backgroundColor = UIColor.green
                    target.transform = CGAffineTransform.identity
                })
            }
            
            circleAnimator.startAnimation()
            circleAnimator.pauseAnimation()
            // 剩余时间完成新动画
            circleAnimator.continueAnimation(withTimingParameters: nil, durationFactor: durationFactor)
            
            // animator 三个重要属性
            print("Animator isRunning, isReversed, state: \(circleAnimator.isRunning), \(circleAnimator.isReversed), \(circleAnimator.state)")
        case .changed:
            let translation = gesture.translation(in: self.view)
            target.center = CGPoint(x: cirleCenter!.x + translation.x, y: cirleCenter!.y + translation.y)
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

