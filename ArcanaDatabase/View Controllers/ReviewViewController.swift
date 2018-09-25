//
//  ViewController.swift
//  ArcanaDatabase
//
//  Created by Jitae Kim on 9/17/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class ReviewViewController: UIViewController {
    
    let arcanaID: String
    
    lazy var uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = lightGreenColor
        button.addTarget(self, action: #selector(confirmUpload), for: .touchUpInside)
        return button
    }()
    
    init(arcanaID: String) {
        self.arcanaID = arcanaID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(uploadButton)
        
        uploadButton.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 100)
        uploadButton.anchorCenterYToSuperview()
    }
    
    @objc func confirmUpload() {
        
        let reviewRef = REVIEW_REF.child(arcanaID)
        
        reviewRef.observeSingleEvent(of: .value, with: { snapshot in
            
            guard let dict = snapshot.value as? [String:Any] else { return }
            // review will have the full arcana. divide this and upload at /arcanaPreview and /arcana
            let arcanaRef = ARCANA_REF.child(self.arcanaID)
            arcanaRef.updateChildValues(dict, withCompletionBlock: { (error, reference) in
                if error != nil {
                    return
                }
                reviewRef.removeValue()
            })
        })
        
    }
}

