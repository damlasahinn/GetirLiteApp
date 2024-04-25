//
//  GetirLiteAppShoppingCartUITests.swift
//  GetirLiteAppUITests
//
//  Created by Damla Sahin on 24.04.2024.
//

import XCTest

final class GetirLiteAppShoppingCartUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("**** Test Begin ****")
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func loadCartVC() {
        app.launch()
        let productListingViewExists = app.otherElements["mainScreen"].waitForExistence(timeout: 20)
        XCTAssertTrue(productListingViewExists, "Product Listing View did not appear.")

        let cartButton = app.buttons["listingCartButton"]
        XCTAssertTrue(cartButton.exists, "Cart button does not exist on Product Listing View.")
        cartButton.tap()

        let cartViewExists = app.otherElements["ShoppingCartViewController"].waitForExistence(timeout: 20)
        XCTAssertTrue(cartViewExists, "Shopping Cart View did not appear after tapping cart button.")
    }
    
    func testShoppingCartUIElementsVisibility() {
        loadCartVC()
        XCTAssertTrue(app.isCloseButtonDisplayed, "Close button should be visible")
        XCTAssertTrue(app.isCompleteOrderButtonDisplayed, "Complete Order button should be visible")
        XCTAssertTrue(app.isCartTableViewDisplayed, "Cart Table View should be visible")
        XCTAssertTrue(app.isSuggestedProductsCollectionViewDisplayed, "Suggested Products Collection View should be visible")
        app.cartCloseButton.tap()
    }
}

extension XCUIApplication {
    var cartCloseButton: XCUIElement {
        navigationBars.buttons["cartCloseButton"]
    }
    
    var deleteButton: XCUIElement {
        navigationBars.buttons["deleteButton"]
    }
    
    var completeOrderButton: XCUIElement {
        buttons["completeOrderButton"]
    }
    
    var cartTableView: XCUIElement {
        tables["CartTableView"]
    }
    
    var suggestedProductsCollectionView: XCUIElement {
        collectionViews["SuggestedProductsCollectionView"]
    }
    
    var isCloseButtonDisplayed: Bool {
        cartCloseButton.exists
    }
    
    var isDeleteButtonDisplayed: Bool {
        deleteButton.exists
    }
    
    var isCompleteOrderButtonDisplayed: Bool {
        completeOrderButton.exists
    }
    
    var isCartTableViewDisplayed: Bool {
        cartTableView.exists
    }
    
    var isSuggestedProductsCollectionViewDisplayed: Bool {
        suggestedProductsCollectionView.exists
    }
    
    func alertExists(withTitle title: String) -> Bool {
        alerts.staticTexts[title].exists
    }
}
