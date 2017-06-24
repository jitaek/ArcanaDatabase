//
//  ViewController.swift
//  ArcanaDatabase
//
//  Created by Jitae Kim on 9/17/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    let arcanaID: String
    
    init(arcanaID: String) {
        self.arcanaID = arcanaID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}

