# Recimazing - The amazing recipe sample app

### Summary

The Recimazing app displays a list of recipes fetched from the cloud. The recipes are grouped by cuisine type and ordered alphabetically within a section. Each row will have the name of the recipe and an optional small image. The recipe list can be refreshed by clicking the refresh button in the navigation bar. 

A recipe can be clicked on which will take you to the recipe detail view. On this view, you will see the cuisine type, the recipe name, an optional larger image and two optional buttons. The "View Recipe Website" button will open a modal web view with the website of the recipe. The "Watch Video" button will also open a modal web view displaying the YouTube video website.

![recimaze-screenshot-1](https://github.com/user-attachments/assets/066b64ee-5422-4fd9-b734-aa7f298db360)
![recimaze-screenshot-2](https://github.com/user-attachments/assets/97d78945-77b2-4108-8bb6-f97e50a80c49)
![recimaze-screenshot-3](https://github.com/user-attachments/assets/4de85742-80e1-4238-b9a1-f5c0c0661f72)
![recimaze-screenshot-4](https://github.com/user-attachments/assets/463c88f3-8dc4-40e6-b0be-cb62c3567300)

### Focus Areas

I prefer to start projects from the areas that can be modularized and split off into their own packages. So I prioritized building the cloud services that would communicate with the recipe API and the image service. I also prioritized testing for these services to confirm they work as expected. I added unit tests with mocks and decided to add some integration tests for fun. 

After getting the cloud services to work, I then prioritized organizing the application into an MVVM architecture. Building the persistent models, views, view models and unit tests for the models and view models.

Finally, I decided to add some UI tests as the icing on the cake.

### Time Spent

I spent approximately eight hours working on this project. About 25% on the API and image services, 25% on the UI and MVVM architecture and about 50% on unit, integration and UI tests.  

Let me explain why I took longer than the estimated time given in the assignment. I used this as an opportunity to gather some new skills in addition to applying some of what I know best.

More specifically, I wanted to target iOS 17 so I could use SwiftData which I have not had an opportunity to use in a production application yet.

I also wanted to use this opportunity to get some more practice with the new Swift Testing framework. I used the Swift Testing framework for all unit and integration tests and XCTest for the UI tests. I know the integration tests and UI tests were not required but I make it a habit of adding them and for this small application they were relatively easy and quick to add.

I will say I really enjoy using the new Testing framework and wouldn't go back to XCTest for any new tests. (Other than UI of course) 

### Trade-offs and Decisions

The first decision I had to make was whether to target multiple platforms or just iOS, considering this is a prototype application, I decided just to concentrate on iOS.

The second decision I made was whether to target iOS 16, iOS 17 or iOS 18. Since I really wanted to use SwiftData, I decided to target iOS 17. I know Fetch currently targets iOS 16, but I assume the company will move to iOS 17 when iOS 19 is released. So I'd like to stay ahead of the curve.

The third decision was whether to use Core Data or SwiftData for persistence. Since I'm less familiar with SwiftData and I've been reading about it, I wanted to use this project as an opportunity to practice with it. 

The fourth decision I needed to make was whether to use the MVVM architecture with SwiftData. I've been reading how they don't necessarily compliment one another and I went down a few rabbit holes into the debate. I decided to try out MVVM with SwiftData to see how they interact with one another. I did lose some of the power of Swift data, for example the @Query macro within views but I think my approach did turn out pretty well.

The fifth decision I made was to use the new Swift Testing framework for all the unit tests. I'm very happy with this decision as the new framework seems far superior and easier to use than XCTest.

Another decision I made, as it relates to image caching, was I decided to only cache images to disk instead of adding an intermediate, in-memory cache as well. I thought for the sake of a prototype it was unnecessary and would just add more complexity and more functionality to test.

### Weakest Part of the Project

The weakest part of the application may be the UI design and lack of features. Also, there is no security or authentication, nor the ability to add, favorite, share, delete or search recipes. Also it was not optimized for iPad or other platforms. Also, not optimized for accessibility or internationalization.

When fetching recipes, the weakest part is probably on a refresh where I decided to delete all recipes and then add them all back. This could be optimized in the future. The lack of paging is also a weakness.

Also, as it relates to image retrieval and caching. The cache could probably be improved with an in-memory cache as well as the on disk solution I used. Also, if the images were modified, there is no current way of getting the new image unless the app was deleted.

### Additional Information

Did I mention I really like the new Swift Testing framework ;) Also, I got above 90% code coverage... 

For the cloud services, I tried building them as if I was going to create a Swift package. It would be pretty easy to do since it has no dependencies within the project. The only drawback is I created a CloudRecipe codable struct in addition to a SwiftData recipe class. Using the SwiftData recipe class within the cloud service certainly would have been possible, but seemed to be more trouble than it was worth.

Also, I used SwiftLint while developing this application but removed the build phase so it's not required to build the project.

There is also one part of the instructions that I thought could be improved.

*"If a recipe is malformed, your app should disregard the entire list of recipes and handle the error gracefully."*

I feel that if subset of recipes are malformed but the other recipes have the required fields, then why not display the valid ones. At first I actually implemented it this way and had 60 of 63 recipes being displayed but then I re-read the instructions and fixed it to behave as described.

I also liked working with SwiftData but I did not implement a versioned schema. I think SwiftData has a great future and I look forward to using it in future projects.
