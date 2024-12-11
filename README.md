# FetchRecipeApp
Take Home Project from Fetch

### Steps to Run the App
1. Open `FetchRecipeApp.xcodeproj` in Xcode(a SwfitUI project). Minimum Deployment: IOS 16.6.
2. Run it on the simulator or a connected iPhone or iPad.
3. The app will have a list of recipes fetched from the API endpoint. Tapping on any recipe shows a detail popup.

### Focus Areas
- Async/Await for Data Fetching & Image Loading: Adopting Swift Concurrency for network operations and image fetching. 
- Clear Architecture: Separated concerns into distinct files to ensure maintainability and scalability.

### Time Spent
I spent:
- 1 hour on designing the UI and outlining a blueprint.
- 4 hours on Implementation: Setting up the architecture, fetching data with async/await, building the UI, and implementing caching.
- 1 hour on Refinements: Adding error handling, polishing UI, and verifying performance.
- 1 hour on Testing: Creating sample unit tests.

### Trade-offs and Decisions
- Caching Strategy: I chose a simple disk cache with a hashed filename approach. 
- Limited UI Complexity: I prioritized concurrency and caching over a highly customized UI to ensure the code focusing on performance and architecture was clear.
- Testing Coverage: Because this is a rather smaller project. Tests are minimal. In a real project, I would add more comprehensive tests to cover edge cases and failure modes.

### Weakest Part of the Project
- Testing Coverage: Currently, the weakest area might be the testing coverage. More thorough tests would provide stronger confidence in the code’s reliability and handle edge cases.
- Advanced Error Handling or Retry Mechanisms: I'm trying to make error messages more user-friendly, but a more robust error handling could improve resilience and UX.

### Additional Information
- Scalability: The current architecture can scale by adding more features (e.g., multiple endpoints, offline support).
