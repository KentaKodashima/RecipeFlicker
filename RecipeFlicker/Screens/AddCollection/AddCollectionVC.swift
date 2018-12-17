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
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var stackView: UIStackView!
  
  // MARK: - Properties
  private var nextButton: UIBarButtonItem!
  
  // MARK: - View controller life-cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: AddCollectionVC.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: AddCollectionVC.keyboardWillHideNotification, object: nil)
    
    collectionNameField.delegate = self
    collectionNameField.setToolbarForKeyboard()
    
    setRightBarButton()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self, name: AddCollectionVC.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: AddCollectionVC.keyboardWillHideNotification, object: nil)
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
    // Get width & height of the screen
    let screenSize: CGRect = UIScreen.main.bounds
    let screenWidth = screenSize.width
    let screenHeight = screenSize.height
  
    // Get the keyboard's final size
    let info = notification.userInfo!
    let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    
    // The bottom position of the stackview
    let stackBottom = stackView.frame.origin.y + stackView.frame.height + self.view.frame.origin.y
    // The top position of the keyboard
    let keyboardTop = screenHeight - keyboardFrame.size.height
    // How much the keyboard overlaps the stackview
    let overlap =  stackBottom - keyboardTop
    
    if overlap >= 0 {
      // Move the contents up overlap value + 88.0
      scrollView.contentOffset.y = overlap + 88.0
      scrollView.isScrollEnabled = false
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    scrollView.contentOffset.y = 0
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
