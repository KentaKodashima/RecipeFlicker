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
  
  // MARK: - Properties
  private var nextButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: AddCollectionVC.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: AddCollectionVC.keyboardWillHideNotification, object: nil)
    
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
  
  @objc fileprivate func printViewFrameOriginY() {
    print(self.view.frame.origin.y)
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
    adjustHeight(show: true, notification: notification)
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    adjustHeight(show: false, notification: notification)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func adjustHeight(show:Bool, notification:NSNotification) {
    var userInfo = notification.userInfo!
    let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
    
    scrollView.contentInset.bottom += changeInHeight
    scrollView.scrollIndicatorInsets.bottom += changeInHeight
  }

}
