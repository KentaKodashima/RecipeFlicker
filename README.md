# RecipeFlicker

## Overview
RecipeFlicker allows you to make your own favorite recipe lists. Even if you can't come up with anything you want to cook for the night, RecipeFlicker offers random recipes from all around the world.

## Concepts
- Keep good recipes
- Share good recipes with friends

## Target
- People who cook
- People who are in need of help to decide what to cook

## Implementation Phases
### Phase 1
#### Objectiev
Publishing the app without any trouble.
#### Functionalities
- Swipe to decide recipe(Tinder-like UI)
- Favorite recipe list (two patterns of UI using TableView and CollectionView)
- Use Firebase as database for the later use
### Phase 2
#### Objective
Implement full functionality.
#### Functionalities
- Post URL with comment
- Follow people
- Like someone's post

## Implementation Style
Follow the guideline GUIDELINE.md.

## Specifications
Language: Swift 4.2

Libraries: Alamofire, SwiftyJSON, KolodaView

API: EDAMAM Recipe Search API

Database: Farebase

## Architecture
We adopt simple MVC architecture so that we can keep the app simple. Additionally, MVC is easy to understand thanks to its simplicity.

![architecture](https://user-images.githubusercontent.com/18434054/47101258-5e574780-d1ee-11e8-9ea9-5f6499c23f36.png)

## Object Map

![objectmap](https://user-images.githubusercontent.com/18434054/47105540-1a1d7480-d1f9-11e8-9993-5cb7b3980ed8.png)