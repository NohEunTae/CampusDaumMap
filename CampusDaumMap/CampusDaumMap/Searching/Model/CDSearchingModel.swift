//
//  CDSearchingModel.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 5..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class CDSearchingModel: NSObject {
    var name: String = String()
    var imageName: String = String()
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}
