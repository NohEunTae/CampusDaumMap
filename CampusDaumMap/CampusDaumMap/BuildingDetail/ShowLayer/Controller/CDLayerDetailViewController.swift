//
//  CDLayerDetailViewController.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 5..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class CDLayerDetailViewController: UIViewController {

    var layerDetailView: CDLayerDetailView?
    var layer: Layers?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if layer!.stairNumb == -1 {
            self.title = "B\(layer!.stairNumb)F"
        } else {
            self.title = "\(layer!.stairNumb)F"
        }
        
        guard let customView = Bundle.main.loadNibNamed("CDLayerDetailView", owner: self, options: nil)?.first as? CDLayerDetailView else {
            return
        }
        layerDetailView = customView
        layerDetailView?.layerImage.image = UIImage(named: layer!.imageName!)
        self.view.addSubview(layerDetailView!)
        // Do any additional setup after loading the view.
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
