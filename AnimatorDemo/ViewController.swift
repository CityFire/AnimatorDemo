//
//  ViewController.swift
//  AnimatorDemo
//
//  Created by wjc on 16/9/25.
//  Copyright © 2016年 wjc. All rights reserved.
//  后者优先：UIViewPropertyAnimator 实例中靠后添加的动画或者执行时间更晚的动画会覆盖之前的效果。

import UIKit

@available(iOS 10.0, *)
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
        circle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dragCircle3)))
        
        // 可选动画参数
//        circleAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut, animations: { 
//            [unowned circle] in
//            // 放大两倍
//            circle.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
//        })
        circleAnimator = UIViewPropertyAnimator(duration: 1.0, curve: .linear, animations: {
            circle.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        })
        
        circleAnimator?.addAnimations({
            circle.backgroundColor = UIColor.blue
        }, delayFactor: 0.75)

//        circleAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut)

        
        self.view.addSubview(circle)
        
    }
    
    // UISpringTimingParameters的实例需要设置阻尼系数（damping）、质量参数（mass）、刚性系数（stiffness）和初始速度（initial velocity）。
    func dragCircle2(gesture: UIPanGestureRecognizer) {
        
        let target = gesture.view!
        
        switch gesture.state {
            case .began:
                if circleAnimator != nil && circleAnimator!.isRunning {
                    circleAnimator!.stopAnimation(false)
                }
                cirleCenter = target.center
            case .changed:
                let translation = gesture.translation(in: self.view)
                target.center = CGPoint(x: cirleCenter!.x + translation.x, y: cirleCenter!.y + translation.y)
            case .ended:
                let v = gesture.velocity(in: target)
                // 500这个随机值看起来比较合适，你可能会觉得这个值是基于设备屏幕尺寸的
                // 在y轴上的速度分量通常被忽略，当对于视图的center为动画主体时会使用
                let velocity = CGVector(dx: v.x / 500, dy: v.y / 500)
                // 时间曲线函数
                let springParameters = UISpringTimingParameters(mass: 2.5, stiffness: 70, damping: 55, initialVelocity: velocity)
                circleAnimator = UIViewPropertyAnimator(duration: 0.0, timingParameters: springParameters)
                
                circleAnimator!.addAnimations({
                    target.center = self.view.center
                })
                circleAnimator!.startAnimation()
            default: break
        }
    }

    // UICubicTimingParameters 允许通过多个控制点（control point）来定义三阶贝塞尔曲线。需要注意的是，在 0.0~1.0 范围外的点会修正到范围内。
    // 为 y 设置对应的值
//    let curveProvider = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.2, y: -0.48), controlPoint2: CGPoint(x: 0.79, y: 1.41))
//    expansionAnimator = UIViewPropertyAnimator(duration: expansionDuration, timingParameters: curveProvider)
    func dragCircle3(gesture: UIPanGestureRecognizer) {
        let target = gesture.view!
        
        switch gesture.state {
        case .began:
            cirleCenter = target.center
        case .changed:
            let translation = gesture.translation(in: self.view)
            target.center = CGPoint(x: cirleCenter!.x + translation.x, y: cirleCenter!.y + translation.y)
            
            circleAnimator?.fractionComplete = target.center.y / self.view.frame.height
        default: break
        }
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

