//
//  FormViewController.swift
//  Test MVVM Project
//
//  Created by BS236 on 18/3/22.
//

import UIKit

class FormViewController: UIViewController {
    
    var viewModel = FormViewModel()
    
    //MARK: Constants
    let textFieldHeight = 50.0
    
    
    //MARK: UI Elements
    var scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIScrollView())
    
    var contentStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 8
        return $0
    }(UIStackView())
    
    var emailTextField: UITextField = {
        $0.borderStyle = UITextField.BorderStyle.roundedRect
        $0.placeholder = "Email"
        $0.font = UIFont.systemFont(ofSize: 18.0)
        $0.tag = 0
        return $0
    }(UITextField())
    
    var nameTextField: UITextField = {
        $0.borderStyle = UITextField.BorderStyle.roundedRect
        $0.placeholder = "Name"
        $0.font = UIFont.systemFont(ofSize: 18.0)
        $0.tag = 1
        return $0
    }(UITextField())
    
    var usernameTextField: UITextField = {
        $0.borderStyle = UITextField.BorderStyle.roundedRect
        $0.placeholder = "Username"
        $0.font = UIFont.systemFont(ofSize: 18.0)
        $0.tag = 2
        return $0
    }(UITextField())
    
    var passwordTextField: UITextField = {
        $0.borderStyle = UITextField.BorderStyle.roundedRect
        $0.placeholder = "Password"
        $0.isSecureTextEntry = true
        $0.font = UIFont.systemFont(ofSize: 18.0)
        $0.tag = 3
        return $0
    }(UITextField())
    
    var confirmPasswordTextField: UITextField = {
        $0.borderStyle = UITextField.BorderStyle.roundedRect
        $0.placeholder = "Re-enter Password"
        $0.isSecureTextEntry = true
        $0.font = UIFont.systemFont(ofSize: 18.0)
        $0.tag = 4
        return $0
    }(UITextField())
    
    var submitButton: UIButton = {
        $0.setTitle("Submit", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 8.0
        $0.isEnabled = false
        return $0
    }(UIButton())
    
    var emailErrorLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .red
        $0.isHidden = true
        return $0
    }(UILabel())
    
    var nameErrorLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .red
        $0.isHidden = true
        return $0
    }(UILabel())
    
    var usernameErrorLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .red
        $0.isHidden = true
        return $0
    }(UILabel())
    
    var passwordErrorLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .red
        $0.isHidden = true
        return $0
    }(UILabel())
    
    var confirmPasswordErrorLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .red
        $0.isHidden = true
        return $0
    }(UILabel())
    
    
    //MARK: Controller Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()

        title = "Hello World"
        self.view.backgroundColor = .white
        
        self.initializeHideKeyboard()
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShowOrHide))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillShowOrHide))
        
        [emailTextField,nameTextField,passwordTextField,confirmPasswordTextField,usernameTextField].forEach({
            $0.delegate = self
        })
        
        scrollView.backgroundColor = .white
        self.view.addSubview(scrollView)
        
        contentStackView.backgroundColor = .white
        scrollView.addSubview(contentStackView)
        
        emailTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(usernameChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(confirmPasswordChanged), for: .editingChanged)
        
        [emailTextField, emailErrorLabel, nameTextField, nameErrorLabel, usernameTextField, usernameErrorLabel, passwordTextField, passwordErrorLabel, confirmPasswordTextField, confirmPasswordErrorLabel, submitButton].forEach { contentStackView.addArrangedSubview($0) }
        
        activateLayoutConstraints()
        bind()
    }
    
    func activateLayoutConstraints() {
        
        [emailTextField,nameTextField,passwordTextField,confirmPasswordTextField,usernameTextField,submitButton].forEach({
            $0.heightAnchor.constraint(equalToConstant: self.textFieldHeight).isActive = true
        })
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32.0),
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16.0),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16.0),
            contentStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)

        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Unsubscribe from all our notifications
        unsubscribeFromAllNotifications()
    }
    
    func bind() {
        viewModel.emailText.bind { [weak self] status, message in
            self?.emailErrorLabel.text = message
            self?.emailErrorLabel.isHidden = status
            UIView.animate(withDuration: 0.2, delay: 0) {
                self?.view.layoutIfNeeded()
            }
        }
        viewModel.nameText.bind { [weak self] status, message in
            self?.nameErrorLabel.text = message
            self?.nameErrorLabel.isHidden = status
            UIView.animate(withDuration: 0.2, delay: 0) {
                self?.view.layoutIfNeeded()
            }
        }
        viewModel.usernameText.bind { [weak self] status, message in
            self?.usernameErrorLabel.text = message
            self?.usernameErrorLabel.isHidden = status
            UIView.animate(withDuration: 0.2, delay: 0) {
                self?.view.layoutIfNeeded()
            }
        }
        viewModel.passwordText.bind { [weak self] status, message in
            self?.passwordErrorLabel.text = message
            self?.passwordErrorLabel.isHidden = status
            UIView.animate(withDuration: 0.2, delay: 0) {
                self?.view.layoutIfNeeded()
            }
        }
        viewModel.confirmPasswordText.bind { [weak self] status, message in
            self?.confirmPasswordErrorLabel.text = message
            self?.confirmPasswordErrorLabel.isHidden = status
            UIView.animate(withDuration: 0.2, delay: 0) {
                self?.view.layoutIfNeeded()
            }
        }
        viewModel.formValidated = { [weak self] status in
            self?.submitButton.isEnabled = status
            self?.submitButton.backgroundColor = status == true ? .blue : .lightGray
        }
    }
    
}


//MARK: Validation Methods
extension FormViewController {
    @objc func emailChanged() {
        viewModel.checkEmail(with: emailTextField.text)
    }
    
    @objc func passwordChanged() {
        viewModel.checkPassword(with: passwordTextField.text)
    }
    
    @objc func confirmPasswordChanged() {
        viewModel.checkConfirmPassword(with: passwordTextField.text, against: confirmPasswordTextField.text)
    }
    
    
    @objc func nameChanged() {
        viewModel.checkName(with: nameTextField.text)
    }
    
    @objc func usernameChanged() {
        viewModel.checkUsername(with: usernameTextField.text)
    }
}

//MARK: Keyboard Handling
extension FormViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShowOrHide(notification: NSNotification) {
        // Get required info out of the notification
        if let userInfo = notification.userInfo, let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey], let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey], let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] {
            
            // Transform the keyboard's frame into our view's coordinate system
            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
            
            // Find out how much the keyboard overlaps our scroll view
            let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
            
            // Set the scroll view's content inset & scroll indicator to avoid the keyboard
            scrollView.contentInset.bottom = keyboardOverlap
            //scrollView.scrollIndicatorInsets.bottom = keyboardOverlap
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardOverlap
            
            let duration = (durationValue as AnyObject).doubleValue
            let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
            UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

}
