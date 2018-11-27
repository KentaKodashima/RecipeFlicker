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
//    setActivityIndicator()
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
    toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))

    webKitView.addSubview(toolBar)
    
    // Constraints
    toolBar.bottomAnchor.constraint(equalTo: webKitView.bottomAnchor, constant: 0).isActive = true
    toolBar.leadingAnchor.constraint(equalTo: webKitView.leadingAnchor, constant: 0).isActive = true
    toolBar.trailingAnchor.constraint(equalTo: webKitView.trailingAnchor, constant: 0).isActive = true
  }
  
  fileprivate func setActivityIndicator() {
    activityIndicator = UIActivityIndicatorView()
    activityIndicator.center = webKitView.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.style = UIActivityIndicatorView.Style.gray
    webKitView.addSubview(activityIndicator)
  }
  
}

extension DetailVC: WKUIDelegate {
  override func loadView() {
    let webConfiguration = WKWebViewConfiguration()
    webKitView = WKWebView(frame: .zero, configuration: webConfiguration)
    webKitView.uiDelegate = self
    self.view = webKitView
  }
  
  private func sendRequest(urlString: String) {
    print("This is THE URL: \(urlString)")
    let myURL = URL(string: urlString)
    let myRequest = URLRequest(url: myURL!)
    webKitView.load(myRequest)
  }
}

extension DetailVC: WKNavigationDelegate {
  fileprivate func showActivityIndicator(show: Bool) {
    if show {
      activityIndicator.startAnimating()
    } else {
      activityIndicator.stopAnimating()
    }
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    showActivityIndicator(show: false)
  }
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    showActivityIndicator(show: true)
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    showActivityIndicator(show: false)
  }
}
