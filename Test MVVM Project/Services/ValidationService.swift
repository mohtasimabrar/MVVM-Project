//
//  ValidationService.swift
//  Test MVVM Project
//
//  Created by BS236 on 18/3/22.
//

import Foundation


class ValidationService {
    
    
    static func invalidEmail(_ value: String) -> String? {
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        if !predicate.evaluate(with: value) {
            return "Invalid Email Address"
        }
        
        return nil
    }
    
    
    
    static func invalidPassword(_ value: String) -> String? {
        if value.count < 8 {
            return "Password must be at least 8 characters"
        }
        if containsDigit(value) {
            return "Password must contain at least 1 digit"
        }
        if containsLowerCase(value) {
            return "Password must contain at least 1 lowercase character"
        }
        if containsUpperCase(value) {
            return "Password must contain at least 1 uppercase character"
        }
        return nil
    }
    
    
    static func confirmPassword(_ password: String, _ confirmPassword: String) -> String? {
        if (confirmPassword.elementsEqual(password)) {
            return nil
        } else {
            return "Password does not match. Please try again."
        }
    }
    
    static func containsDigit(_ value: String) -> Bool {
        let reqularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    static func containsLowerCase(_ value: String) -> Bool {
        let reqularExpression = ".*[a-z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    static func containsUpperCase(_ value: String) -> Bool {
        let reqularExpression = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    
    
    static func invalidLength(_ value: String) -> String? {
        if value.count < 1 {
            return " cannot be empty"
        }
        return nil
    }

}
