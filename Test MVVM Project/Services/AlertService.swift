//
//  AlertService.swift
//  Test MVVM Project
//
//  Created by BS236 on 18/3/22.
//

import Foundation
import UIKit


class AlertService {
    
    static func createAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Okay", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        
        return alert
    }
    
}
