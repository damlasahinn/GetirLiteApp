//
//  GetirLiteAppUITests.swift
//  GetirLiteAppUITests
//
//  Created by Damla Sahin on 10.04.2024.
//

import XCTest

final class GetirLiteAppUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testProductListing() throws {
        
        XCTAssertTrue(app.productListingView.waitForExistence(timeout: 5), "Product listing view should be displayed")

        XCTAssertTrue(app.horizontalCollectionView.exists, "Horizontal collection view should exist")
        XCTAssertTrue(app.horizontalCollectionView.cells.count > 0, "Horizontal collection view should have cells")

        XCTAssertTrue(app.verticalCollectionView.exists, "Vertical collection view should exist")
        XCTAssertTrue(app.verticalCollectionView.cells.count > 0, "Vertical collection view should have cells")

        let horizontalCell = app.horizontalCollectionView.cells.element(boundBy: 0)
        horizontalCell.tap()

        XCTAssertTrue(app.otherElements["ProductDetailViewController"].waitForExistence(timeout: 5), "Product detail view should be displayed after tapping on a cell")
    }
}

extension XCUIApplication {
    var productListingView: XCUIElement {
        otherElements["mainScreen"]
    }

    var horizontalCollectionView: XCUIElement {
        collectionViews["horizontalCollectionView"]
    }

    var verticalCollectionView: XCUIElement {
        collectionViews["verticalCollectionView"]
    }

    var listingCartButton: XCUIElement {
        buttons["listingCartButton"]
    }

    var cartView: XCUIElement {
        otherElements["CartViewController"]
    }
}
