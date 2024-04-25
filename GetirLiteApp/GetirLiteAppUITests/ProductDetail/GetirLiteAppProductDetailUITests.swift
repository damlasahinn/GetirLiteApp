//
//  GetirLiteAppProductDetailUITests.swift
//  GetirLiteAppUITests
//
//  Created by Damla Sahin on 24.04.2024.
//

import XCTest

final class GetirLiteAppProductDetailUITests: XCTestCase {

    var app: XCUIApplication!
        
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func loadDetailVC() {
        XCTAssertTrue(app.collectionViews.cells.firstMatch.waitForExistence(timeout: 10))
        app.collectionViews.cells.firstMatch.tap()
        XCTAssertTrue(app.otherElements["ProductDetailViewController"].waitForExistence(timeout: 5))
    }
    
    func testTransitionToProductDetail() {
        loadDetailVC()
    }

    func testProductDetailViewElementsVisibility() {
        loadDetailVC()
        XCTAssertTrue(app.productNameLabel.exists, "Product name label should be visible")
        XCTAssertTrue(app.priceLabel.exists, "Price label should be visible")
        XCTAssertTrue(app.productImageView.exists, "Product image should be visible")
        
        XCTAssertTrue(app.stepperIncreaseButton.exists, "Stepper increase button should appear after adding to cart")
        XCTAssertTrue(app.stepperDecreaseButton.exists, "Stepper decrease button should appear after adding to cart")
        XCTAssertTrue(app.cartButton.exists, "Cart button should appear after adding to cart")
        
        app.stepperIncreaseButton.tap()
        app.stepperDecreaseButton.tap()
        app.detailCloseButton.tap()
    }

}

extension XCUIApplication {
    var detailCloseButton: XCUIElement {
        navigationBars.buttons["detailCloseButton"]
    }
    
    var addToCartButton: XCUIElement {
        buttons["addToCartButton"]
    }
    
    var productNameLabel: XCUIElement {
        staticTexts["productNameLabel"]
    }
    
    var priceLabel: XCUIElement {
        staticTexts["priceLabel"]
    }
    
    var productImageView: XCUIElement {
        images["productImageView"]
    }
    
    var stepperIncreaseButton: XCUIElement {
        buttons["stepperIncrease"]
    }
    
    var stepperDecreaseButton: XCUIElement {
        buttons["stepperDecrease"]
    }
    
    var cartButton: XCUIElement {
        buttons["cartButton"]
    }
}
