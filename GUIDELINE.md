#  RecipeFlicker Implementation Guideline
This guideline is besically conforming to the official Swift Style Guide from raywenderlich.com.
You can check the original document from [here](https://github.com/raywenderlich/swift-style-guide#naming).

## Spacing
- Indent using 2 spaces. Set up your Xcode as below.
![Indentation setting in Xcode](https://user-images.githubusercontent.com/18434054/47031082-0522e180-d124-11e8-9261-09b67a29cefd.png)
- Colons always have no spaces on the left and one space on the right.
`[String: Int]`
- There should be one blank line between methods for the visuality purpose.

## Naming Conventions
Follow the Swift naming conventions from  the API [Guiidelines](https://swift.org/documentation/api-design-guidelines/). Here are some key takeaways from the document.

- Use camel case
    - Variables: `var someName = "Some name"`
    - Constants: `let fixedName = "Fixed name"`
  
- Use uppercase for types (and protocols), lowercase for everything else
    - Class:  `class SampleClass`
    - Enums:  `struct SampleEnum`
    -  Struccts: `struct SampleStruct`
    - Protocols: `protocol SampleProtocol`
- Use names based on roles, not types

## Code Organization
### Protocol Conformance
Add a separate extension for the protocol methods when adding protocol conformance.

**Preferred:**
```
extension MyViewController: UITableViewDataSource {
  // table view data source methods
}
```
**Not Preferred:**
```
class MyViewController: UIViewController, UITableViewDataSource, UIScrollViewDelegate {
  // table view data source methods
}
```
## Classes and Structs
### Which one to use?
Use **structs** for things that do not have an identity such as Arrays. We can say two arrays with exactly the same values are the same things.

Use **classes** for things that do have an identity or a specific life cycle such as Person object. Person objects which have the same name and age are not the same.

You can refenrence [this article](https://medium.com/@KentaKodashima/swift-classes-and-structs-a52ed8d99441) when you are not sure about the differences between classes and structs.

## Use of Self
Use `self` only when the compiler requirs it.

## Computed Properties
Use `get` clause only when the `set` clause is provided.

**Preferred:**
```
var fullName: String {
  return firstName + lastName
}
```
**Not Preferred:**
```
var fullName: String {
  get {
    return firstName + lastName
  }
}
```

## Constants and Variables
Always use `let` instead of `var` if the value will not change. If you are not sure at first, start with `let` and change it to `var` if it's necessary.

## Parentheses
Basically, parentheses around conditionals should be omited.
However, long conditionals(using ternary operators, etc.) whould be more readable code with parentheses.

**Preferred:**
```
if message == "How are you?" {
  print("Great!")
}
```
**Not Preferred:**
```
if (message == "How are you?") {
  print("Great!")
}
```

## References
- [The Official raywenderlich.com Swift Style Guide](https://github.com/raywenderlich/swift-style-guide#references)
- [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)