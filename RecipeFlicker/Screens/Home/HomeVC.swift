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
  private var favoriteRecipeUrls = [String]()
  private var recommendations = [Recipe]()
  
  private var timer = Timer()
  private var resetTimer: Timer!
  private var countdownTimer = UILabel()
  private var countdownView = UIView()
  private var currentDate: Date!
  
  private var cardWidth: CGFloat = 0.0
  
  private var activityIndicatorContainer: UIView!
  private var activityIndicator: UIActivityIndicatorView!
  
  private var recommendationCollectionView: UICollectionView!
  
  // MARK: - View controller life-cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Fetch anonymous user's uid from Firebase
    if let userId = Auth.auth().currentUser?.uid {
      self.userId = userId
    }
    
    self.userRef = Database.database().reference()

    currentDate = Date()
    resetTimer = Timer(fireAt: currentDate.get7am(), interval: 0, target: self, selector: #selector(setIsFirstSignIn), userInfo: nil, repeats: false)
    
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
      self.setActivityIndicator()
      self.showActivityIndicator(show: true)
      
      if self.rlmUser == nil {
        let user = authResult?.user
        let uid = user?.uid
        self.rlmUser = RLMUser(userId: uid!)
        self.rlmUser.isFirstSignIn = false
        try! self.realm.write {
          self.realm.add(self.rlmUser!)
        }
        
        // Create new user in Firebase
        self.userRef.child("users").child(self.rlmUser!.userId).child("userId").setValue(self.rlmUser!.userId)
        
        self.userId = self.rlmUser!.userId
        
        // Get favorite recipes from firebase
        self.getFavoriteRecipes()
        
        // Fetch recipes and setKolodaView
        self.fetchRecipesToBind()
      } else {
        // Get favorite recipes from firebase
        self.getFavoriteRecipes()
        
        if self.rlmUser.isFirstSignIn {
          self.fetchRecipesToBind()
          self.setIsFirstSignIn(false)
        } else {
          // Check if lastFetchTime has value
          guard let lastFetchTime = self.rlmUser.lastFetchTime else {
            self.fetchRecipesToBind()
            self.setIsFirstSignIn(false)
            return
          }
          
          // Check if this is a the first login in the day
          if (self.currentDate! > self.currentDate.get7am()) && (lastFetchTime < self.currentDate.get7am()) {
            self.fetchRecipesToBind()
            self.setIsFirstSignIn(false)
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
        guard let userRecipesOfTheDay = self.rlmUser?.recipesOfTheDay else { return }
        guard var recipeStore = recipeArray else { return }
        if userRecipesOfTheDay.count != 0 {
          userRecipesOfTheDay.removeAll()
        }
        while userRecipesOfTheDay.count < 15 {
          let randomRecipe = recipeStore.randomElement()!
          if !self.favoriteRecipeUrls.contains(randomRecipe.originalRecipeUrl) {
            userRecipesOfTheDay.append(randomRecipe)
          }
          recipeStore.remove(at: recipeStore.firstIndex(of: randomRecipe)!)
        }
        self.rlmUser.lastFetchTime = Date()
      }
      self.setKolodaView()
      self.kolodaView.reloadData()
    }
  }
  
  fileprivate func getFavoriteRecipes() {
    let userID = Auth.auth().currentUser?.uid
    userRef.child("favorites").child(userID!).observe(.value) { (snapshot) in
      self.favoriteRecipeUrls.removeAll()
      for child in snapshot.children {
        if let recipe = (child as! DataSnapshot).value as? [String: Any] {
          let originalRecipeUrl = recipe["originalRecipeUrl"] as! String
          let title = recipe["title"] as! String
          let image = recipe["image"] as! String
          let recipeObj = Recipe(originalRecipeUrl: originalRecipeUrl, title: title, image: image, isFavorite: true)
          
          self.favoriteRecipeUrls.append(originalRecipeUrl)
          self.recommendations.append(recipeObj)
        }
      }
      self.recommendationCollectionView.reloadData()
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
      self.showActivityIndicator(show: false)
    })
    
    // Constraints
    kolodaView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
    kolodaView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -16).isActive = true
    kolodaView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
    kolodaView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
  }
  
  fileprivate func setCountdownView() {
    self.showActivityIndicator(show: false)
    let countdownViewWidth = self.view.bounds.width
    let countdownViewHeight = self.view.bounds.height
    countdownView = UIView(frame: CGRect(x: 0, y: 0, width: countdownViewWidth, height: countdownViewHeight))
    countdownView.backgroundColor = UIColor.white
    
    let countdownLabel = UILabel()
    countdownLabel.translatesAutoresizingMaskIntoConstraints = false
    countdownLabel.text = "Time until your next recipe"
    countdownLabel.textAlignment = .center
    countdownLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
    
    countdownTimer.translatesAutoresizingMaskIntoConstraints = false
    countdownTimer.textAlignment = .center
    countdownTimer.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
    countdownTimer.accessibilityIdentifier = "00:00:01"
    countdownTimer.setCountdownTimerText()
    
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountdown), userInfo: nil, repeats: true)
    
    let suggestionLabel = UILabel()
    suggestionLabel.translatesAutoresizingMaskIntoConstraints = false
    suggestionLabel.text = "Suggestions For You"
    suggestionLabel.textAlignment = .center
    suggestionLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 32)
    suggestionLabel.textColor = AppColors.accent.value
    
    // TODO: - Implement collectionview and pagecontrol
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    
    recommendationCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
    recommendationCollectionView.translatesAutoresizingMaskIntoConstraints = false
    let recommendationCollectionViewCell = UINib(nibName: "RecommendationCollectionViewCell", bundle: nil)
    recommendationCollectionView.register(recommendationCollectionViewCell, forCellWithReuseIdentifier: "RecommendationCollectionViewCell")
    
    recommendationCollectionView.delegate = self
    recommendationCollectionView.dataSource = self
    
//    let pageControl = UIPageControl()
    
    let stack = UIStackView()
    stack.axis = .vertical
    stack.alignment = .fill
    stack.spacing = 16
    stack.distribution = .fill
    stack.translatesAutoresizingMaskIntoConstraints = false
    
    stack.addArrangedSubview(countdownLabel)
    stack.addArrangedSubview(countdownTimer)
    stack.addSubview(recommendationCollectionView)
    
    countdownView.addSubview(stack)
    self.view.addSubview(countdownView)
    
    // Constraints
    stack.centerXAnchor.constraint(equalTo: countdownView.centerXAnchor).isActive = true
    stack.centerYAnchor.constraint(equalTo: countdownView.centerYAnchor).isActive = true
    
    recommendationCollectionView.topAnchor.constraint(equalTo: countdownTimer.bottomAnchor, constant: 16).isActive = true
    recommendationCollectionView.leftAnchor.constraint(equalTo: stack.leftAnchor, constant: 16).isActive = true
    recommendationCollectionView.rightAnchor.constraint(equalTo: stack.rightAnchor, constant: 16).isActive = true
    recommendationCollectionView.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 16).isActive = true
  }
  
  @objc fileprivate func startCountdown() {
    countdownTimer.setCountdownTimerText()
  }
  
  @objc fileprivate func setIsFirstSignIn(_ isFirstSignIn: Bool) {
    try! self.realm.write {
      if isFirstSignIn {
        self.rlmUser.isFirstSignIn = true
      } else {
        self.rlmUser.isFirstSignIn = false
      }
    }
  }
  
  @objc fileprivate func removeCountdownView() {
    timer.invalidate()
    setIsFirstSignIn(true)
    if self.view.subviews.count != 0 {
      countdownView.removeFromSuperview()
    }
    fetchRecipesToBind()
  }
  
  fileprivate func setActivityIndicator() {
    let viewBoundWidth = self.view.bounds.size.width / 2
    let viewBoundHeight = self.view.bounds.size.height / 2
    
    activityIndicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    activityIndicatorContainer.backgroundColor = UIColor.black
    activityIndicatorContainer.alpha = 0.8
    activityIndicatorContainer.layer.cornerRadius = 10
    activityIndicatorContainer.center = CGPoint(x: viewBoundWidth, y: viewBoundHeight)

    activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    activityIndicatorContainer.addSubview(activityIndicator)
    self.view.addSubview(activityIndicatorContainer)
    
    activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorContainer.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorContainer.centerYAnchor).isActive = true
  }
  
  fileprivate func showActivityIndicator(show: Bool) {
    if show {
      activityIndicator.startAnimating()
    } else {
      activityIndicator.stopAnimating()
      activityIndicatorContainer.removeFromSuperview()
    }
  }
}

// MARK: - KolodaView Data Source
extension HomeVC: KolodaViewDataSource {
  func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
    return rlmUser?.recipesOfTheDay.count ?? 0
  }
  
  func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    let card = CardView(frame: CGRect(x: 0, y: 0, width: 300, height: self.view.frame.height - buttonStack.frame.height))
    let recipe = rlmUser.recipesOfTheDay[index]
    let noImage = UIImage(named: "NoImage")
    let imageUrl = URL(string: recipe.image)!
    
    card.layoutIfNeeded()
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
    
    cardWidth = card.frame.size.width * 0.1
    
    return card
  }
  
  func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    let overlayView = Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    
    overlayView?.layer.cornerRadius = cardWidth
    
    return overlayView
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

extension HomeVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.recommendations.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationCollectionViewCell", for: indexPath) as! RecommendationCollectionViewCell
    
    let recipe = recommendations[indexPath.row]
    
    cell.recipeTitle.text = recipe.title
    
    return cell
  }
}

extension HomeVC: UICollectionViewDelegate {
  
}
