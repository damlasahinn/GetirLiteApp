//
//  GetirLiteAppShoppingCartTests.swift
//  GetirLiteAppTests
//
//  Created by Damla Sahin on 24.04.2024.
//

import XCTest
@testable import GetirLiteApp
@testable import ProductAPI

final class GetirLiteAppShoppingCartTests: XCTestCase {

    var view: TestShoppingCartViewController!
    var interactor: TestShoppingCartInteractor!
    var presenter: ShoppingCartPresenter!
    var router: TestShoppingCartRouter!

    
    override func setUp() {
        view = TestShoppingCartViewController()
        interactor = TestShoppingCartInteractor()
        router = TestShoppingCartRouter()
        presenter = ShoppingCartPresenter(view: view, router: router, interactor: interactor)
    }

    override func tearDown() {
        super.tearDown()
        view = nil
        interactor = nil
        router = nil
        presenter = nil
    }
    
    func testViewDidLoad_CallsFetchFromAPIAndCoreData() {
        presenter.viewDidLoad()
        
        XCTAssertTrue(interactor.fetchSuggestedProductsCalled, "FetchSuggestedProducts should be called on viewDidLoad")
    }

    func testViewDidAppear_UpdatesCartValue() {
        presenter.viewDidAppear()
        
        XCTAssertTrue(interactor.calculateTotalCartValueCalled, "calculateTotalCartValue should be called on viewDidAppear")
        XCTAssertTrue(view.updateCartValueCalled, "updateCartValue should be updated on viewDidAppear")
        XCTAssertEqual(view.total, 100.0, "Total cart value should be updated correctly")
    }

    func testIncreaseProductQuantity_CallsInteractor() {
        let productId = "testID"
        presenter.increaseProductQuantity(productId: productId)
        
        XCTAssertTrue(interactor.updateProductQuantityCalled, "updateProductQuantity should be called with increase action")
    }

    func testDecreaseProductQuantity_CallsInteractor() {
        let productId = "testID"
        presenter.decreaseProductQuantity(productId: productId)
        
        XCTAssertTrue(interactor.updateProductQuantityCalled, "updateProductQuantity should be called with decrease action")
    }

    func testDeleteProduct_CallsInteractor() {
        let productId = "testID"
        presenter.deleteProduct(productId: productId)
        
        XCTAssertTrue(interactor.deleteProductFromCoreDataCalled, "deleteProductFromCoreData should be called")
    }

    func testDeleteAllCartData_CallsInteractor() {
        presenter.deleteAllCartData()
        
        XCTAssertTrue(interactor.deleteAllProductsCalled, "deleteAllProducts should be called")
    }

    func testCloseViewController_CallsRouter() {
        presenter.closeViewController()
        
        XCTAssertTrue(router.navigateCalled, "navigate should be called")
        XCTAssertEqual(router.route, .listing, "Should navigate back to the listing page")
    }

    func testDidSelectProduct_CallsRouterWithProduct() {
        let product = Product(id: "1", name: "Test Product", attribute: "Size", thumbnailURL: nil, squareThumbnailURL: nil, imageURL: nil, price: 10.0, priceText: "$10", quantity: 1)
        presenter.didSelectProduct(product)
        
        XCTAssertTrue(router.navigateCalled, "navigate should be called on product select")
        XCTAssertEqual(router.route, .detail, "Should navigate to the product detail page")
    }

    func testFetchCartProductsIDs_CallsInteractor() {
        presenter.fetchCartProductsIDs()
        
        XCTAssertTrue(interactor.fetchCartProductIDsCalled, "fetchCartProductIDs should be called")
    }
}
