//
//  FormViewModel.swift
//  Test MVVM Project
//
//  Created by BS236 on 18/3/22.
//

import Foundation

class FormViewModel {
    
    var formValidated: ((Bool) -> Void)?
    
    var emailText = Box(true, "")
    var nameText = Box(true, "")
    var usernameText = Box(true, "")
    var passwordText = Box(true, "")
    var confirmPasswordText = Box(true, "")
    
    var emailError = true
    var nameError = true
    var usernameError = true
    var passwordError = true
    var confirmPasswordError = true

    func checkEmail(with email: String?) {
        guard let email = email, !email.isEmpty  else {
            self.emailText.listener?(true, "")
            emailError = true
            return
        }
        
        guard let errorMessage = ValidationService.invalidEmail(email) else {
            self.emailText.value = email
            self.emailError = false
            self.emailText.listener?(true, "")
            return
        }
        
        self.emailText.value = email
        self.emailError = true
        self.emailText.listener?(false, errorMessage)
        checkForValidForm()
    }
    
    func checkName(with name: String?) {
        if let name = name {
            if let errorMessage = ValidationService.invalidLength(name) {
                self.nameText.value = name
                self.nameError = true
                self.nameText.listener?(false, "Name\(errorMessage)")
            } else {
                self.nameText.value = name
                self.nameError = false
                self.nameText.listener?(true, "")
            }
        }
        checkForValidForm()
    }
    
    func checkUsername(with username: String?) {
        if let username = username {
            if let errorMessage = ValidationService.invalidLength(username) {
                self.usernameText.value = username
                self.usernameError = true
                self.usernameText.listener?(false, "Username\(errorMessage)")
            } else {
                self.usernameText.value = username
                self.usernameError = false
                self.usernameText.listener?(true, "")
            }
        }
        checkForValidForm()
    }
    
    func checkPassword(with password: String?) {
        if let password = password {
            if password.isEmpty {
                self.passwordText.listener?(true, "")
                self.passwordError = true
                return
            }
            if let errorMessage = ValidationService.invalidPassword(password) {
                self.passwordText.value = password
                self.passwordError = true
                self.passwordText.listener?(false, errorMessage)
            } else {
                self.passwordText.value = password
                self.passwordError = false
                self.passwordText.listener?(true, "")
            }
        }
        checkForValidForm()
    }
    
    func checkConfirmPassword(with password: String?, against confirmPassword: String?) {
        if let confirmPassword = confirmPassword {
            if confirmPassword.isEmpty {
                self.confirmPasswordText.listener?(true, "")
                self.confirmPasswordError = true
                return
            }
            if let password = password {
                if let errorMessage = ValidationService.confirmPassword(password, confirmPassword) {
                    self.confirmPasswordText.value = password
                    self.confirmPasswordError = true
                    self.confirmPasswordText.listener?(false, errorMessage)
                } else {
                    self.confirmPasswordText.value = password
                    self.confirmPasswordError = false
                    self.confirmPasswordText.listener?(true, "")
                }
            }
        }
        checkForValidForm()
    }
    
    
    
    func checkForValidForm() {
        if !emailError && !nameError &&  !usernameError && !passwordError && !confirmPasswordError {
            formValidated?(true)
        } else {
            formValidated?(false)
        }
    }
}
