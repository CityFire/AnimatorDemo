//
//  ViewController2.swift
//  AnimatorDemo
//
//  Created by wjc on 16/11/12.
//  Copyright © 2016年 wjc. All rights reserved.
//  UISpringTimingParameters的实例需要设置阻尼系数（damping）、质量参数（mass）、刚性系数（stiffness）和初始速度（initial velocity）。

import UIKit

@available(iOS 10.0, *)
class ViewController2: UIViewController {
    
    // 记录拖动时的圆形视图center
    var circleCenter: CGPoint!
    // 我们将在拖拽响应事件上附加不同的动画
    var circleAnimator: UIViewPropertyAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 添加一个可拖动视图
        let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        circle.center = self.view.center
        circle.layer.cornerRadius = 50.0
        circle.backgroundColor = UIColor.green
        
        circleAnimator = UIViewPropertyAnimator(duration: 1.0, curve: .linear, animations: {
            circle.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        })
        
        circleAnimator?.addAnimations({
            circle.backgroundColor = UIColor.blue
        }, delayFactor: 0.75)
        
        // 添加拖动手势
        circle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dragCircle)))
        
        self.view.addSubview(circle)
    }
    
    func dragCircle(gesture: UIPanGestureRecognizer) {
        let target = gesture.view!
        
        switch gesture.state {
        case .began:
            circleCenter = target.center
        case .changed:
            let translation = gesture.translation(in: self.view)
            target.center = CGPoint(x: circleCenter!.x + translation.x, y: circleCenter!.y + translation.y)
            
            circleAnimator?.fractionComplete = target.center.y / self.view.frame.height
        default: break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
