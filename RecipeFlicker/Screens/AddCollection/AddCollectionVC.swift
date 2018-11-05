//
//  AddCollectionViewController.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-11-03.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class AddCollectionVC: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet weak var collectionNameField: UITextField!
  
  // MARK: - Properties
  private var nextButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: AddCollectionVC.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: AddCollectionVC.keyboardWillHideNotification, object: nil)
  
    collectionNameField.setToolbarForKeyboard()
    setRightBarButton()
  }
  
  // MARK: - Actions
  @IBAction func textFieldEditingDidChanged(_ sender: UITextField) {
    if !(sender.text?.isEmpty)! && sender.text?.first != " " {
      nextButton.isEnabled = true
    } else {
      nextButton.isEnabled = false
    }
  }
  
  fileprivate func setRightBarButton() {
    nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonTapped))
    nextButton.isEnabled = false
    navigationItem.rightBarButtonItem = nextButton
  }
  
  @objc fileprivate func nextButtonTapped() {
    performSegue(withIdentifier: "goToSelectRecipes", sender: UIBarButtonItem.self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToSelectRecipes" {
      let selectRecipesToAddVC = segue.destination as! SelectReciepsToAddVC
      selectRecipesToAddVC.collectionName = collectionNameField.text!
    }
  }
}

extension AddCollectionVC: UITextFieldDelegate {
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardRectangle.height
      
      // Sliding origin when the keyboard will show
      if view.frame.origin.y == 0 {
        view.frame.origin.y -= keyboardHeight
      }
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardRectangle.height
      
      // Sliding origin when the keyboard will show
      if view.frame.origin.y != 0 {
        view.frame.origin.y += keyboardHeight
      }
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
