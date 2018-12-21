# RecipeFlicker

## Overview
RecipeFlicker allows you to make your own favorite recipe lists. Even if you can't come up with anything you want to cook for the night, RecipeFlicker offers random recipes from all around the world.

⚠️NOTE:  
The GoogleService-Info.plist (Firebase) and API keys for Edamam Recipe Search API are not included for the security reason. Therefore you cannot use this app even if you clone and run it. However, the app is currently under the TestFlight process and published on the App Store very soon.

## Concepts
- Keep good recipes
- Share good recipes with friends

## Target
- People who cook
- People who are in need of help to decide what to cook

## Implementation Phases
### Phase 1
#### Objective
Implement the core functions and publish the app without any trouble.
#### Functionalities
- Swipe to decide recipe(Tinder-like UI)
- Next random recipes are available at 7 am everyday
- Open up WebKitView to see the detail of the recipe
- List right-swiped recipes as the user's favorites
- Use Firebase as database for the later use
- Use Realm to store Firebase anonymous user id and everyday's random recipes

### Phase 2
#### Objective
Implement full functionality.
#### Functionalities
- Firebase authentication (email / password, Facebook, Google)
- Register preferable and unpreferable ingredients
- Random recommendation of someone's collection shows up after the user swipes all recipes of the day
- Post URL with comment
- Follow / Unfollow people
- Save someone's recipe to the user's favorite

#### Github Usage
```
origin
  ├ master
  | 
  └ develop
     ├ dev-master
     ├ developer1
     └ developer2
```
##### origin/master 
Update app data on the app store.
##### develop
Implement new functionalities.
##### develop/dev-master
Code which is ready to be merged into origin master.
##### develop/developer1, develop/developer2
The place where each developers actually create new features.

## Implementation Style
Follow this guideline. [GUIDELINE.md](GUIDELINE.md)

## Specifications
Language: Swift 4.2

Libraries: 

- Alamofire: Simplifying networking process
- SwiftyJSON: Simplifying parsing JSON data
- KolodaView: Implement Tinder-like UI
- KingFisher: Download and cache images

API: EDAMAM Recipe Search API

Database: Firebase, Realm

## Architecture
We adopt simple MVC architecture so that we can keep the app simple. Additionally, MVC is easy to understand thanks to its simplicity.

![architecture](https://user-images.githubusercontent.com/18434054/47101258-5e574780-d1ee-11e8-9ea9-5f6499c23f36.png)

## Database Architecture
### Firebase
```
root
  ├ users
  |  └ userId
  |     └ userId
  | 
  ├ favorites
  |  └ userId
  |     └ recipeId
  |        ├ firebaseId
  |        ├ image
  |        ├ isFavorite
  |        ├ originalRecipeUrl
  |        ├ realmId
  |        └ title
  | 
  ├ userCollections
  |  └ userId
  |     └ collectionId
  |        ├ collectionId
  |        ├ name
  |        └ image
  |            
  └ recipeCollections
     └ collectionId
        └ recipeId (= firebaseId)
           ├ firebaseId
           ├ image
           ├ isFavorite
           ├ originalRecipeUrl
           ├ realmId
           └ title
```

## Class Map

![class map](https://user-images.githubusercontent.com/18434054/48048240-bcbd7900-e14f-11e8-9dcc-a37ef2890c52.png)

## Team Member
Project Manager, Leader, Developer - Kenta (Me)

Developer - [Minami](https://github.com/Minamiciccc)

Designer - [Nagisa](https://github.com/beach1208)
