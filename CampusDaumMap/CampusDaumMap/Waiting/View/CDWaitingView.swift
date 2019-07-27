//
//  CDWaiting.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 4..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Lottie

protocol CDWaitingViewDelegate {
    func animationFinished()
}

class CDWaitingView: UIView {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var animationView: UIView!
    
    var lottie: LOTAnimationView?
    var delegate: CDWaitingViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.logoImageView.image = UIImage(named: "mainLogo")
        
        lottie = LOTAnimationView(name: "loading")
        self.animationView.addSubview(lottie!)
//        lottie?.loopAnimation = true
        lottie?.play(completion: { (finished) in
            self.delegate?.animationFinished()
        })
//        lottie?.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let validLottie = lottie {
            validLottie.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.init(item: validLottie, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.animationView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint.init(item: validLottie, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.animationView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint.init(item: validLottie, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.animationView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint.init(item: validLottie, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.animationView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0).isActive = true
        }
    }
}
