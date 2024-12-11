# FetchRecipeApp
Take Home Project from Fetch

### Steps to Run the App
1. Clone or open `FetchRecipeApp.xcodeproj` in Xcode(a SwfitUI project). Minimum Deployment: IOS 16.6.
2. Run it on the simulator or a connected iPhone or iPad.
3. The app will have a list of recipes fetched from the API endpoint. Tapping on any recipe shows a detail popup.

### Focus Areas
- Async/Await for Data Fetching & Image Loading: I wanted to show that I’m comfortable using modern Swift concurrency patterns by adopting Swift Concurrency for network operations and image fetching.
- Custom Image Caching and Efficient Networking: I wanted to demonstrate that I understand the importance of efficient network usage and built a disk and in-memory cache system from scratch.
- Clear Architecture: Separated concerns into distinct files to ensure maintainability and scalability.

### Time Spent
I spent:
- 1 hour on designing the UI and outlining a blueprint.
- 4 hours on Implementation: Setting up the architecture, fetching data with async/await, building the UI, and implementing caching.
- 1 hour on Refinements: Adding error handling, polishing UI, and verifying performance.
- 1.5 hours on Testing: Creating sample unit tests.

### Trade-offs and Decisions
- Loading Larger Images on Demand in the Detail Popup: In the recipe detail popup, I chose to fetch the larger image on-demand rather than preloading it. This means the user might see a short loading time when tapping a recipe, slightly impacting the UX. However, this approach reduces unnecessary data usage if the user never opens that detail view. It’s a conscious choice to prioritize efficiency over instantaneous UI responses—one that might be revisited for a more seamless experience if I had more time or user feedback.
- Caching Strategy: I chose a simple disk cache with a hashed filename approach. While straightforward, it lacks advanced cache invalidation or eviction policies. This was acceptable for a limited scope and dataset
- Limited UI Complexity: I prioritized concurrency and caching over a highly customized UI to ensure the code focusing on performance and architecture was clear.
- Testing Coverage: Because this is a rather smaller project. Tests are minimal. In a real project, I would add more comprehensive tests to cover edge cases and failure modes.

### Weakest Part of the Project
Probably the lack of advanced error handling and more comprehensive test coverage. 
- Testing Coverage: A more thorough test would provide stronger confidence in the code’s reliability and handle edge cases.
- Advanced Error Handling or Retry Mechanisms: I'm trying to make error messages more user-friendly, but a more robust error handling could improve resilience and UX.

### Additional Information
- Scalability: The current architecture can scale by adding more features (e.g., multiple endpoints, offline support).
