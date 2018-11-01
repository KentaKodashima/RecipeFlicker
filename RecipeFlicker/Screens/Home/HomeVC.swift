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

  private var appDelegate = UIApplication.shared.delegate as! AppDelegate
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  private var userRef: DatabaseReference!
  private var userId: String!
  
  private let kolodaView = KolodaView()
  private var users = [CDUser]()
  private var recipes = [Recipe]()
  private var recipeAPI = RecipeAPI()
  
  var timer = Timer()
  private var countdownTimer = UILabel()
  private var countdownView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    kolodaView.delegate = self
    kolodaView.dataSource = self
    setKolodaView()
    
    // Fetch anonymous user's uid from Firebase
    if let userId = Auth.auth().currentUser?.uid {
      self.userId = userId
    }
    
    fetchRecipesToBind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // Fetch existing user from Core Data
    do {
      users = try context.fetch(CDUser.fetchRequest())
    } catch {
      print("Could not fetch. \(error), \(error._userInfo)")
    }
    
    // Create new user in both Core Data and Firebase, if there is none
    if users.count == 0 {
      Auth.auth().signInAnonymously() { (authResult, error) in
        let user = authResult?.user
        let uid = user?.uid
        let newUser = CDUser(context: self.context)
        newUser.userId = uid
        self.userId = uid
        self.appDelegate.saveContext()
        self.users.append(newUser)
        
        // Create new user in Firebase
        self.userRef = Database.database().reference()
        self.userRef.child("users").child(newUser.userId!).child("userId").setValue(self.users[0].userId)
      }
    }
  }
  
  @IBAction func dislikeButtonTapped(_ sender: UIButton) {
    kolodaView.swipe(SwipeResultDirection.left)
  }
  
  @IBAction func likeButtonTapped(_ sender: UIButton) {
    kolodaView.swipe(SwipeResultDirection.right)
  }
  
  fileprivate func fetchRecipesToBind() {
    // Fetch data from API and bind to KolodaView
    recipeAPI.getRandomRecipes { recipeArray, error in
      for recipe in recipeArray! {
        self.recipes.append(recipe)
      }
      self.kolodaView.reloadData()
    }
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
    
//    let countdownTimer = UILabel()
    countdownTimer.translatesAutoresizingMaskIntoConstraints = false
    countdownTimer.text = ""
    countdownTimer.textAlignment = .center
    countdownTimer.font = UIFont(name: "ChalkboardSE-Bold", size: 24)
    
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
    
    // Constraint
    stack.centerXAnchor.constraint(equalTo: countdownView.centerXAnchor).isActive = true
    stack.centerYAnchor.constraint(equalTo: countdownView.centerYAnchor).isActive = true
  }
  
  @objc fileprivate func startCountdown() {
    let now = Date()
    let calendar = Calendar.current
    let components = DateComponents(calendar: calendar, hour: 7)  // <- 07:00 = 7am
    let nextDay = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime)!
    let difference = calendar.dateComponents([.hour, .minute, .second], from: now, to: nextDay)
    let formatter = DateComponentsFormatter()
    
    // Test the string
    // Test if the UI exists after 7:00 am
    if formatter.string(from: difference)! == "0" {
      timer.invalidate()
      countdownView.removeFromSuperview()
    } else {
      countdownTimer.text = formatter.string(from: difference)!
    }
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
      recipe.saveToFirebase(userId: userId)
    }
  }
  
  // Method called after all cards have been swiped
  // Uncomment out to show countdown view
  func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
    setCountdownView()
  }
}
