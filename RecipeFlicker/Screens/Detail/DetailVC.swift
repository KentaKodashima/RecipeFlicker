//
//  DetailVC.swift
//  RecipeFlicker
//
//  Created by minami on 2018-10-16.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import WebKit
import Firebase
import RealmSwift

class DetailVC: UIViewController {
  
  // MARK: - Properties
  private var webKitView: WKWebView!
  private var toolBar: UIToolbar!
  private var activityIndicatorContainer: UIView!
  private var activityIndicator: UIActivityIndicatorView!
  
  private var userId: String!
  private var recipe: Recipe!
  
  private var userRef = Database.database().reference()
  private var recipeRef: DatabaseReference!
  
  var recipeId: String?
  
  // MARK: - View controller life-cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    userId = Auth.auth().currentUser?.uid
    getRecipeFromFirebase()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  // MARK: - Actions
  private func getRecipeFromFirebase() {
    recipeRef = userRef.child("favorites").child(userId!).child(recipeId!)
    recipeRef.observe(.value) { (snapshot) in
      if let recipe = snapshot.value as? [String: String] {
        let id = recipe["firebaseId"]
        let url = recipe["originalRecipeUrl"]
        let title = recipe["title"]
        let image = recipe["image"]
        let isFavotiteLiteral = recipe["isFavorite"]
        var whichCollectionToBelongList = List<String>()
        if let whichCollectionToBelong = recipe["whichCollectionToBelong"] as? [String:Any] {
          for collectionId in whichCollectionToBelong.keys {
            whichCollectionToBelongList.append(collectionId)
          }
        }
        self.recipe = Recipe(firebaseId: id!, originalRecipeUrl: url!, title: title!, image: image!, isFavorite: (isFavotiteLiteral == "true"), whichCollectionToBelong: whichCollectionToBelongList)
        self.sendRequest(urlString: self.recipe.originalRecipeUrl)
        self.setToolBar()
        self.setActivityIndicator()
      }
    }
  }
  
  fileprivate func setToolBar() {
    let screenHeight = self.view.bounds.height
    let screenWidth = self.view.bounds.width
    let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
    
    toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    toolBar.isTranslucent = false
    toolBar.translatesAutoresizingMaskIntoConstraints = false

    toolBar.items = [backButton]
    webKitView.addSubview(toolBar)
    
    // Constraints
    toolBar.bottomAnchor.constraint(equalTo: webKitView.bottomAnchor, constant: 0).isActive = true
    toolBar.leadingAnchor.constraint(equalTo: webKitView.leadingAnchor, constant: 0).isActive = true
    toolBar.trailingAnchor.constraint(equalTo: webKitView.trailingAnchor, constant: 0).isActive = true
  }
  
  fileprivate func setActivityIndicator() {
    activityIndicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    activityIndicatorContainer.center = webKitView.center
    activityIndicatorContainer.backgroundColor = UIColor.black
    activityIndicatorContainer.alpha = 0.8
    activityIndicatorContainer.layer.cornerRadius = 10
    
    activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    activityIndicatorContainer.addSubview(activityIndicator)
    webKitView.addSubview(activityIndicatorContainer)
    
    // Constraints
    activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorContainer.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorContainer.centerYAnchor).isActive = true
  }
  
}

extension DetailVC: WKUIDelegate {
  override func loadView() {
    let webConfiguration = WKWebViewConfiguration()
    webKitView = WKWebView(frame: .zero, configuration: webConfiguration)
    webKitView.uiDelegate = self
    webKitView.navigationDelegate = self
    webKitView.allowsBackForwardNavigationGestures = true
    self.view = webKitView
  }
  
  private func sendRequest(urlString: String) {
    let myURL = URL(string: urlString)
    let myRequest = URLRequest(url: myURL!)
    webKitView.load(myRequest)
  }
  
  
}

extension DetailVC: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    showActivityIndicator(false)
  }
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    showActivityIndicator(true)
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    showActivityIndicator(false)
  }
  
  @objc private func goBack() {
    if webKitView.canGoBack {
      webKitView.goBack()
    } else {
      self.navigationController?.popViewController(animated: true)
      self.dismiss(animated: true, completion: nil)
      self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
  }
  
  @objc private func goForward() {
    webKitView.goForward()
  }
  
  fileprivate func showActivityIndicator(_ show: Bool) {
    if show {
      activityIndicator.startAnimating()
    } else {
      activityIndicator.stopAnimating()
      activityIndicatorContainer.removeFromSuperview()
    }
  }
}
