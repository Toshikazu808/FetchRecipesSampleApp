# Fetch Recipes Sample App

### Summary
This sample application fetches a list of recipes from a specified URL and displays them on screen using SwiftUI.  Each recipe object contains data such as name, cuisine, uuid, a photo URL, and a Youtube URL.

Upon fetching the initial list of recipes from the API, the app will then save it to the device.  All future fetches will then check if data exists locally before making another remote fetch.

Finally, each recipe in the list is tappable, and navigates the user to a second screen to view a Youtube video if available.

### Focus Areas
SwiftUI makes creating Views pretty simple and clean, especially when using the MVVM architecture.  I wanted to make sure the Views were componentized appropriately, dependencies conformed to protocols for dependency injection unit testing, and all business logic is seperated from the View and placed in the view model.  Unit tests are for the `Api` and `RecipeListVM` objects, and there are some UI tests for the `RecipeListView`.  More details about my thoughts behind building this project are under the *Trade-offs and Decisions* section.

### Time Spent
I spent around 3 hours building the app to a basic state, with ugly Views, and using `AsyncImage` to display images.  However, it took about another 3 hours just to think about the caching logic in the `RecipeListVM`.  Because the `RecipeListView` uses a `LazyVStack` nested in a `ScrollView`, I knew that not all `RecipeViews` would be loaded at the same time.

Because of this, I added an `.onAppear` modifier to the `RecipeView` to fetch `UIImage` data only when each "cell" is displayed, and refactored the `AsyncImage` to just a regular `Image` object.  That way not all 60+ images are fetched at once which should help improve performance.

Lastly, I spent another 3 hours writing unit tests and UI tests while making minor adjustments to make sure everything runs as expected.  All unit tests and UI tests passed.  I opted to use `XCTest` instead of the new `Testing` framework because there were some cases that I wanted to use `XCTAssertNoThrow`.  Although the `Testing` framework has the `try #require()` function, I was still unable to use it for my exact use case, so I rewrote the tests using `XCTest` instead.

### Trade-offs and Decisions
1. My first order of business was to define the `struct Recipe` model object.  Because the specifications called for a caching layer, I also created a `@Model final class CachedRecipe` object since we would be interfacing with `SwiftData`.

2. Created the `Api` object to fetch data using `URLSession`.  The `Api` object conforms to a `protocol ApiCallable` so we can use dependency injection for easier unit testing.  This dependency is injected into the main `App` object using a custom `AppDelegate` in the `didFinishLaunchingWithOptions` function.

3. Since this app specifies to have only 1 screen, I opted to place the main `NavigationStack` in the ContentView file, which displays the `RecipeListView` as the root view.  If this app specified to have multiple tabs, I would've used a `TabView` here instead.

4. The Views are created to be as componentized as possible.  The `RecipeListView` contains Views to display a scrollable vertical list.  The `RecipeView` contains the Views to display the metadata for each "cell" in the list.  The `RecipeVideoView` is a bonus View I added to view a video associated with each `Recipe`.

5. The `RecipeListVM` contains all of the business logic associated with the `RecipeListView`.  Because we use the MVVM architecture, we can make sure that each View is "dumb", and doesn't perform any business logic within the View.

6. The `RecipeListVM` also contains logic to cache fetched `Recipe` objects, including any `UIImage` data it may contain by using the `SwiftData` `ModelContext` object.  Each app can only have 1 `ModelContext` instance, so we inject this into the view model via a function `setModelContext(modelContext:)`.

7. The `RecipeListVM` also contains a function `lazyInit(_ api: ApiCallable)` which is used to inject the `ApiCallable` dependency.  If this were a UIKit project, this would be simply done in the standard `init()`, but because SwiftUI manages these view model objects via the `@StateObject` property wrapper, and because the `ApiCallable` dependency is stored in the `@EnvironmentObject` `appDelegate`, we're unable to initialize the view model as follows because we won't have access to `self` at the point of initialization.  This does **NOT** work: `@StateObject private var recipeListVM = RecipeListVM(api: self.appDelegate.apiManager)`.  Although I really like the MVVM architecture, this could potentially be seen as "code smell" given the current state of how SwiftUI Views manage their state objects.

8. The decision to make the `RecipeListVM` conform to `ObservableObject` was made only because it interfaces with `SwiftData`.  If we used the `Observation` framework and had the view model conform to `@Observable` instead, we would not be able to interface well with `SwiftData`, as I discovered during testing on a previous project.  This would be a future update initiative if `Observation` ever has updates to work better with `SwiftData`.

### Weakest Part of the Project
The weakest part of the project is likely the `lazyInit()` function in the `RecipeListVM`, because this component will not work as expected unless this function is called.  Again, this was only used because of the limitation with how SwiftUI Views declare `@StateObject` view models, but I made sure to add appropriate documentation both for this function as for the view model class itself.  Writing unit tests for this function should ensure that this "weaker" part of the code always works as intended.

Another area of improvement for this app could be how it uses the `AppDelegate` to initialize the app's dependencies.  Rather that storing the dependencies in the `AppDelegate` we could potentially instead use a "Dependency Injection Container" singleton to initialize and store all dependencies.  Then we could access each instance of any future dependencies directly from the container.  This was out of scope for this project so I left it out.

### Additional Information
I very much appreciate this style of coding assessment instead of the "Leetcode" style approach.  Leetcode might be okay for backend, but in my opinion it's definitely not a good indicator for frontend technologies like iOS.  Thank you for taking this into consideration.  I had fun building this. 
