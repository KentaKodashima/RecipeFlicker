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
import RealmSwift
import Kingfisher

class HomeVC: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet weak var buttonStack: UIStackView!
  
  // MARK: - Properties
  private var userRef: DatabaseReference!
  private var userId: String!
  private let realm = try! Realm()
  private var rlmUser: RLMUser!
  
  private let kolodaView = KolodaView()
  private var recipeAPI = RecipeAPI()
  
  private var timer = Timer()
  private var resetTimer: Timer!
  private var countdownTimer = UILabel()
  private var countdownView = UIView()
  private var currentDate: Date!
  
  // MARK: - View controller life-cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Fetch anonymous user's uid from Firebase
    if let userId = Auth.auth().currentUser?.uid {
      self.userId = userId
    }
    
    currentDate = Date()
    resetTimer = Timer(fireAt: currentDate.get7am(), interval: 0, target: self, selector: #selector(resetIsFirstSignIn), userInfo: nil, repeats: false)
    
    // Fetch existing user from Realm
    rlmUser = RLMUser.all().first

    createUserIfThereIsNone()
    
    kolodaView.delegate = self
    kolodaView.dataSource = self
  }
  
  // MARK: - Actions
  @IBAction func dislikeButtonTapped(_ sender: UIButton) {
    kolodaView.swipe(SwipeResultDirection.left)
  }
  
  @IBAction func likeButtonTapped(_ sender: UIButton) {
    kolodaView.swipe(SwipeResultDirection.right)
  }
  
  fileprivate func createUserIfThereIsNone() {
    // Create new user in both Core Data and Firebase, if there is none
    Auth.auth().signInAnonymously() { (authResult, error) in
      if self.rlmUser == nil {
        let user = authResult?.user
        let uid = user?.uid
        self.rlmUser = RLMUser(userId: uid!)
        self.rlmUser.isFirstSignIn = false
        try! self.realm.write {
          self.realm.add(self.rlmUser!)
        }
        
        // Create new user in Firebase
        self.userRef = Database.database().reference()
        self.userRef.child("users").child(self.rlmUser!.userId).child("userId").setValue(self.rlmUser!.userId)
        
        // Fetch recipes and setKolodaView
        self.fetchRecipesToBind()
      } else {
        if self.rlmUser.isFirstSignIn {
          self.fetchRecipesToBind()
          try! self.realm.write {
            self.rlmUser.isFirstSignIn = false
          }
        } else {
          // Check if this is a the first login in the day
          if (self.currentDate! > self.currentDate.get7am()) && (self.rlmUser.lastFetchTime! < self.currentDate.get7am()) {
            self.resetIsFirstSignIn()
            self.fetchRecipesToBind()
          } else {
            if self.rlmUser.recipesOfTheDay.count == 0 {
              self.setCountdownView()
            } else {
              self.setKolodaView()
            }
          }
        }
      }
    }
  }
  
  fileprivate func fetchRecipesToBind() {
    // Fetch data from API and bind to KolodaView
    recipeAPI.getRandomRecipes { recipeArray, error in
      try! self.realm.write {
        for recipe in recipeArray ?? [Recipe]() {
          self.rlmUser?.recipesOfTheDay.append(recipe)
          self.rlmUser.lastFetchTime = Date()
        }
      }
      self.setKolodaView()
      self.kolodaView.reloadData()
    }
  }
  
  fileprivate func setKolodaView() {
    kolodaView.frame = CGRect()
    kolodaView.center.x = self.view.center.x
    kolodaView.layer.shadowColor = UIColor.gray.cgColor
    kolodaView.layer.shadowOffset = CGSize.zero
    kolodaView.layer.shadowOpacity = 1.0
    kolodaView.layer.shadowRadius = 7.0
    kolodaView.layer.masksToBounds = false
    kolodaView.alpha = 0.0
    kolodaView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(kolodaView)
    self.kolodaView.animator.animateAppearance(2)
    
    UIView.animate(withDuration: 0.1, delay: 1, options: [], animations: { () in
      self.kolodaView.alpha = 1.0
    })
    
    // Constraints
    kolodaView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
    kolodaView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -16).isActive = true
    kolodaView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
    kolodaView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
  }
  
  fileprivate func setCountdownView() {
    let countdownViewWidth = self.view.bounds.width
    let countdownViewHeight = self.view.bounds.height
    countdownView = UIView(frame: CGRect(x: 0, y: 0, width: countdownViewWidth, height: countdownViewHeight))
    countdownView.backgroundColor = UIColor.white
    
    let countdownLabel = UILabel()
    countdownLabel.translatesAutoresizingMaskIntoConstraints = false
    countdownLabel.text = "Your next recipes are coming in..."
    countdownLabel.textAlignment = .center
    countdownLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 18)
    
    countdownTimer.translatesAutoresizingMaskIntoConstraints = false
    countdownTimer.textAlignment = .center
    countdownTimer.font = UIFont(name: "ChalkboardSE-Bold", size: 24)
    countdownTimer.accessibilityIdentifier = "00:00:01"
    countdownTimer.setCountdownTimerText()
    
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountdown), userInfo: nil, repeats: true)
    
    let stack = UIStackView()
    stack.axis = .vertical
    stack.alignment = .fill
    stack.spacing = 16
    stack.distribution = .fill
    stack.translatesAutoresizingMaskIntoConstraints = false
    
    stack.addArrangedSubview(countdownLabel)
    stack.addArrangedSubview(countdownTimer)
    
    countdownView.addSubview(stack)
    self.view.addSubview(countdownView)
    
    // Constraints
    stack.centerXAnchor.constraint(equalTo: countdownView.centerXAnchor).isActive = true
    stack.centerYAnchor.constraint(equalTo: countdownView.centerYAnchor).isActive = true
  }
  
  @objc fileprivate func startCountdown() {
    countdownTimer.setCountdownTimerText()
  }
  
  @objc fileprivate func resetIsFirstSignIn() {
    try! self.realm.write {
      self.rlmUser.isFirstSignIn = true
    }
  }
  
  @objc fileprivate func removeCountdownView() {
    timer.invalidate()
    resetIsFirstSignIn()
    if self.view.subviews.count != 0 {
      countdownView.removeFromSuperview()
    }
    fetchRecipesToBind()
  }
}

// MARK: - KolodaView Data Source
extension HomeVC: KolodaViewDataSource {
  func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
    return rlmUser?.recipesOfTheDay.count ?? 0
  }
  
  func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    let card = CardView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    let recipe = rlmUser.recipesOfTheDay[index]
    let noImage = UIImage(named: "NoImage")
    let imageUrl = URL(string: recipe.image)!
    
    card.clipsToBounds = true
    card.layer.cornerRadius = card.frame.size.width * 0.1
    card.cardImage.kf.setImage(with: imageUrl, completionHandler: {
      (image, error, cacheType, imageUrl) in
      if image == nil || error != nil {
        card.cardImage.image = noImage
      }
    })
    card.cardImage.layer.cornerRadius = card.cardImage.frame.size.width * 0.1
    card.recipeTitle.text = recipe.title
    card.recipeTitle.adjustsFontSizeToFitWidth = true
    card.translatesAutoresizingMaskIntoConstraints = false
    
    return card
  }
}

// MARK: - KolodaView delegate
extension HomeVC: KolodaViewDelegate {
  func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
    return [.left, .right]
  }
  
  func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
    if direction == .right {
      let recipe = rlmUser!.recipesOfTheDay[index]
      try! realm.write {
        recipe.saveToFirebase(userId: userId)
      }
    }
    
    try! realm.write {
      rlmUser!.recipesOfTheDay.remove(at: index)
    }
    self.kolodaView.resetCurrentCardIndex()
  }
  
  func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
    return false
  }
  // Method called after all cards have been swiped
  // Uncomment out to show countdown view
  func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
    if rlmUser.isFirstSignIn == true {
      fetchRecipesToBind()
    } else {
      setCountdownView()
    }
  }
}
