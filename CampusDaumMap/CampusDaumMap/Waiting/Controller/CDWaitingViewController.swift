//
//  CDWaitingViewController.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 4..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Lottie

class CDWaitingViewController: UIViewController {
    
    var waitingView: CDWaitingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let customView = Bundle.main.loadNibNamed("CDWaitingView", owner: self, options: nil)?.first as? CDWaitingView else {
            return
        }
        self.waitingView = customView
        self.waitingView?.delegate = self
        self.view.addSubview(waitingView!)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CDWaitingViewController: CDWaitingViewDelegate {
    func animationFinished() {
        //        setInitialCoreData {
        DispatchQueue.main.async {
            let mainVC = CDMainViewController(nibName: "CDMainViewController", bundle: nil)
            CDParentNavigationController.sharedInstance.pushViewController(mainVC, animated: true)
            self.present(CDParentNavigationController.sharedInstance, animated: true, completion: nil)
        }
        //        }
    }
}
