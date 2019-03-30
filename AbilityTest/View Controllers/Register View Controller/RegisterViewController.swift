//
//  RegisterViewController.swift
//  AbilityTest
//
//  Created by Chase Choi on 2019/3/20.
//  Copyright © 2019 Chase Choi. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class RegisterViewController: UIViewController {
    
    // MARK: @IBOutlets
    
    @IBOutlet weak var nameTextField: RegisterTextField!
    @IBOutlet weak var idTextField: RegisterTextField!
    @IBOutlet weak var examinerTextField: RegisterTextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var isIntellectuallyDisabledButton: UISwitch!
    
    // MARK: - Properties
    
    var managedObjectContext: NSManagedObjectContext?
    
    var newCandidate: Candidate?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupDelegate()
        setupTextfieldIsNotEmpty()
        setupNotificationHandling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeNotificationHandling()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case Segue.topicsCarouselView:
            if let topicsCarouselViewController = segue.destination as? TopicsCarouselViewController, let candidate = self.newCandidate {
                topicsCarouselViewController.candidate = candidate
            }
        default:
            break
        }
    }
    
    // MARK: - Notification Handling
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        
        // Add Observer
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillChange(_:)), name:  UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        
        // Remove Observer
        
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Helper Methods

    @objc func keyboardWillChange(_ notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillChangeFrameNotification
            || notification.name == UIResponder.keyboardWillShowNotification {
            // Move Up
            view.frame.origin.y = -keyboardRect.height/2
        } else {
            // Recover
            view.frame.origin.y = 0
        }
    }
    
    // Setup Delegate
    func setupDelegate() {
        nameTextField.delegate = self
        idTextField.delegate = self
        examinerTextField.delegate = self
    }
    
    // Text field
    func setupTextfieldIsNotEmpty() {
        continueButton.isEnabled = false
        
        nameTextField.addTarget(self, action: #selector(textFieldIsNotEmpty(_:)), for: .editingChanged)
        idTextField.addTarget(self, action: #selector(textFieldIsNotEmpty(_:)), for: .editingChanged)
        examinerTextField.addTarget(self, action: #selector(textFieldIsNotEmpty(_:)), for: .editingChanged)
    }
    
    @objc func textFieldIsNotEmpty(_ sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        guard let name = nameTextField.text, !name.isEmpty,
        let id = idTextField.text, !id.isEmpty,
        let examiner = examinerTextField.text, !examiner.isEmpty else {
            continueButton.isEnabled = false
            return
        }
        continueButton.isEnabled = true
    }
    
    func setupView() {
        
        // Configure switch
        isIntellectuallyDisabledButton.onTintColor = UIColor(red: 24/255, green: 139/255, blue: 247/255, alpha: 1)
        
        // Configure buttons
        continueButton.applyRegisterViewButtonStyle()
        closeButton.applyRegisterViewButtonStyle()
        
    }
    
    // MARK: - @IBActions
    @IBAction func continueButtonTapped() {
        guard let managedObjectContext = self.managedObjectContext else {
            return
        }
        guard let name = nameTextField.text else {return}
        guard let id = idTextField.text else {return}
        guard let examiner = examinerTextField.text else {return}
        
        // Create and Configure New Candidate
        let newCandidate = Candidate(context: managedObjectContext)
        newCandidate.name = name
        newCandidate.examiner = examiner
        newCandidate.id = id
        newCandidate.isIntellecuallyDisabled = isIntellectuallyDisabledButton.isOn
        newCandidate.createAt = Date()
        
        self.newCandidate = newCandidate
    }
}

extension RegisterViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension UIButton {
    func applyRegisterViewButtonStyle() {
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
