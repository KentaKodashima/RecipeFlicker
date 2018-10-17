# RecipeFlicker

## Overview
This app is for people who cannot decide what to cook. It offers some random recipes from the
internet, and users can swipe left or right to choose recipes.

## Concepts
- Offer options for lazy people
- Keep recipes for later
- Make it more enjoyable to choose what to cook

## Target
- People who are lazy or busy

## Implementation Phases
### Phase 1 (Publishing the app)
#### Functionalities
- Swipe to decide recipe
- Favorite recipe list
- Persist data locally (Core Data)
- Search recipe from the API database?
### Phase 2
#### Functionalities
- Make it be able to make a recipe
- Share recipe online (Firebase)

## Implementation Style
Follow the guideline GUIDELINE.md.

## Specifications
Language: Swift 4.2
Libraries: Alamofire, SwiftyJSON, KolodaView
API: EDAMAM Recipe Search API or Google Recipe API
Database: Data persistence with Core Data

## Architecture
We adopt simple MVC architecture so that keep the app simple. Additionally, MVC is easy to understand thanks to its simplicity.

![architecture](https://user-images.githubusercontent.com/18434054/47101258-5e574780-d1ee-11e8-9ea9-5f6499c23f36.png)

## Object Map

![objectmap](https://user-images.githubusercontent.com/18434054/47105540-1a1d7480-d1f9-11e8-9993-5cb7b3980ed8.png)