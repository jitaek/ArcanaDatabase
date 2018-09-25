//
//  ArcanaUploadViewController+TextField.swift
//  ArcanaDatabase
//
//  Created by Jitae Kim on 6/26/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

extension ArcanaUploadViewController: UITextViewDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
