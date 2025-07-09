/*:
## Exercise - Methods
 
 A `Book` struct has been created for you below. Add an instance method on `Book` called `description` that will print out facts about the book. Then create an instance of `Book` and call this method on that instance.
 */
struct Book {
    var title: String
    var author: String
    var pages: Int
    var price: Double
    
}
let description = Book(title: "The Alchemist", author: "Paulo Coelho", pages: 222, price: 12.99)
let bookDescription = description.title + " by " + description.author + " has " + String(description.pages) + " pages and costs $" + String(description.price)
print(bookDescription)
//:  A `Post` struct has been created for you below, representing a generic social media post. Add a mutating method on `Post` called `like` that will increment `likes` by one. Then create an instance of `Post` and call `like()` on it. Print out the `likes` property before and after calling the method to see whether or not the value was incremented.
struct Post {
    var message: String
    var likes: Int
    var numberOfComments: Int
    
    mutating func incrementLikes() {
        likes += 1
    }
    
    func displayLikesAndComments() {
        print("Likes: \(likes)")
        print("Number of comments: \(numberOfComments)")
    }
    
}
Post(message: "Hello, world!", likes: 0, numberOfComments: 10).displayLikesAndComments()
var post = Post(message: "Hello, world!", likes: 0, numberOfComments: 10)
post.incrementLikes()
post.displayLikesAndComments()
/*:
[Previous](@previous)  |  page 5 of 10  |  [Next: App Exercise - Workout Functions](@next)
 */
