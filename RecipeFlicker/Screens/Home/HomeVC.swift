//
//  ViewController.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-10-15.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import Koloda
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Kingfisher

class HomeVC: UIViewController {

  private let kolodaView = KolodaView()
  private var users = [CDUser]()
  private var recipes = [Recipe]()
  private var recipeAPI = RecipeAPI()
  private var appDelegate = UIApplication.shared.delegate as! AppDelegate
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  private var userRef: DatabaseReference!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    kolodaView.delegate = self
    kolodaView.dataSource = self
    setKolodaView()
    
    // Create new user in both Core Data and Firebase, if there is none
    if users.count == 0 {
      Auth.auth().signInAnonymously() { (authResult, error) in
        let user = authResult?.user
        let uid = user?.uid
        let newUser = CDUser(context: self.context)
        newUser.userId = uid
        self.appDelegate.saveContext()
        self.users.append(newUser)
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // Fetch existing user from Core Data
    do {
      users = try context.fetch(CDUser.fetchRequest())
    } catch {
      print("Could not fetch. \(error), \(error._userInfo)")
    }
    
    // Create new user in Firebase
    userRef = Database.database().reference()
    userRef.child("user").child("userId").setValue(users[0].userId)
    
    // Fetch data from API and bind to KolodaView
    recipeAPI.getRandomRecipes { recipeArray, error in
      for recipe in recipeArray! {
        self.recipes.append(recipe)
      }
      self.kolodaView.reloadData()
    }
  }
  
  @IBAction func dislikeButtonTapped(_ sender: UIButton) {
    kolodaView.swipe(SwipeResultDirection.left)
  }
  
  @IBAction func likeButtonTapped(_ sender: UIButton) {
    kolodaView.swipe(SwipeResultDirection.right)
  }
  
  
  fileprivate func setKolodaView() {
    let kolodaViewWidth = self.view.bounds.width * 0.9
    let kolodaViewHeight = self.view.bounds.height * 0.4
    kolodaView.frame = CGRect(x: 0, y: 0, width: kolodaViewWidth, height: kolodaViewHeight)
    kolodaView.center = self.view.center
    kolodaView.layer.cornerRadius = 20
    kolodaView.layer.shadowColor = UIColor.gray.cgColor
    kolodaView.layer.shadowOffset = CGSize.zero
    kolodaView.layer.shadowOpacity = 1.0
    kolodaView.layer.shadowRadius = 7.0
    kolodaView.layer.masksToBounds =  false
    self.view.addSubview(kolodaView)
  }
}

extension HomeVC: KolodaViewDataSource {
  func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
    return recipes.count
  }
  
  func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    let card = CardView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    let recipe = recipes[index]
    let imageUrl = URL(string: recipe.image)!
    
    card.cardImage.kf.setImage(with: imageUrl)
    card.recipeTitle.text = recipe.title
    
    return card
  }
}

extension HomeVC: KolodaViewDelegate {
  func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
    return [.left, .right]
  }
  
  func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
    if direction == .right {
      var recipe = recipes[index]
      recipe.saveToFirebase()
    }
  }
  
//  // Method called after all cards have been swiped
//  func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//
//  }
}
