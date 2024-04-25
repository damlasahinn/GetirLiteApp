# GetirLiteApp

A simple clone of the Getir app, focusing on essential features such as product listing, product details, and a shopping cart interface.

## Description

GetirLiteApp is a simple version of the Getir app. It makes shopping easy. Here are the main parts of the app:

- **Product Listing**: This is where you can see all the products. This section is the starting point of the shopping process, where users can explore various items categorized efficiently.

- **Product Details**: You can find out more about each product here. It shows the price, a description, and pictures. You can also choose how many you want to buy on this page.

- **Shopping Cart**: In the shopping cart, you can see the products you've chosen to buy and some other products you might like. You can change how many you want or remove products from the cart.

This app helps you shop quickly and easily, focusing on the most important parts of shopping.

# Getting Started

To begin using the GetirLiteApp, follow these steps:

1. Ensure that Xcode version 15.0 or higher is installed on your computer.
2. Download the Getir Lite App project files from the GitHub repository.
3. Open the `GetirLiteApp.xcworkspace` file in Xcode.
4. Select the active scheme and press the run button.

Once started, the application will display the product listing screen where you can explore various products.

# Architecture

The GetirLiteApp is structured using the VIPER architecture, which enhances the separation of concerns and makes the code more modular and testable. This architecture choice aids in maintaining a clean codebase and simplifies the management of complex features.

### Design Patterns
- **CoreDataManager**: This class uses the Singleton pattern to ensure there is a single, globally accessible instance that manages all interactions with the app's Core Data stack. It helps in maintaining a consistent state throughout the app.
- **LoadingView**: Another Singleton instance, this manages the display of a loading indicator across the app, ensuring that UI updates are centralized and controlled through a single point of access.

### Modular Local Library
The ProductAPI module, through the ProductService class, fetches product details and suggested items from a remote API, enriching the application with dynamic content.

### Testing
Comprehensive tests have been integrated to ensure the app's reliability:
- **Unit Tests**: Focused on testing the business logic and data management.
- **UI Tests**: Ensure that the user interface behaves as expected under various conditions.

### Custom Views
- **LoadingView**: Represents a custom view that incorporates an activity indicator and a blur background. This custom component is reused throughout the app to provide a consistent user experience during data loading operations.
- **StepperView**: is a customizable view component designed to allow users to increase or decrease quantities or remove items entirely. It features a horizontal or vertical stack view arrangement for flexibility in different UI contexts.
- **CompleteButton**: is another custom component designed to finalize shopping actions. It showcases a composite view with a label to complete orders and a dynamically updating label to display the total price.

By employing these architectural and design strategies, GetirLiteApp is both robust and maintainable, ensuring a seamless user experience.

# Screenshots

<img src="https://github.com/damlasahinn/GetirLiteApp/assets/120717680/e9f036a4-56a6-4c94-9f0d-88ee24ec8177" width="200">
<img src="https://github.com/damlasahinn/GetirLiteApp/assets/120717680/7c8101fd-5931-498e-8c16-ab70c5ef9f63" width="200">
<img src="https://github.com/damlasahinn/GetirLiteApp/assets/120717680/767b70c7-80d7-4e0a-b3b7-4df8903cb0a8" width="200">

# GIF

<img src="https://github.com/damlasahinn/GetirLiteApp/assets/120717680/bb45357b-bb03-490b-8ef2-9fd6fef31290" width="200">

