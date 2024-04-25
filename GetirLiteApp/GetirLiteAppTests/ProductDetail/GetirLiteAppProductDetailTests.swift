//
//  GetirLiteAppProductDetailTests.swift
//  GetirLiteAppTests
//
//  Created by Damla Sahin on 24.04.2024.
//


import XCTest
@testable import GetirLiteApp
@testable import ProductAPI

final class GetirLiteAppProductDetailTests: XCTestCase {

    var view: TestProductDetailViewController!
    var interactor: TestProductDetailInteractor!
    var presenter: ProductDetailPresenter!
    var router: TestProductDetailRouter!

    
    override func setUp() {
        view = TestProductDetailViewController()
        interactor = TestProductDetailInteractor()
        router = TestProductDetailRouter()
        let dummyProduct = Product(id: "123", name: "Test Product", attribute: "Size", thumbnailURL: nil, squareThumbnailURL: nil, imageURL: nil, price: 100.0, priceText: "₺100", quantity: 1)
        presenter = ProductDetailPresenter(view: view, router: router, interactor: interactor, product: dummyProduct)
    }

    override func tearDown() {
        super.tearDown()
        view = nil
        interactor = nil
        router = nil
        presenter = nil
    }
    
    func test_viewDidLoad_InvokesRequiredViewMethods() {
        presenter.viewDidLoad()
        XCTAssertTrue(view.displayProductDetailsCalled, "Display product details should be called on view did load")
        XCTAssertNotNil(view.displayedProduct, "Displayed product should not be nil")
    }

    func test_viewDidAppear_CalculatesTotalCartValue() {
        presenter.viewDidAppear()
        XCTAssertTrue(interactor.calculateTotalCartValueCalled, "Calculate total cart value should be called on view did appear")
        XCTAssertTrue(view.updateCartValueCalled, "Update cart value should be called with calculated total")
        XCTAssertEqual(view.updatedTotal, 100.0, "Updated total should match the mocked cart value")
    }

    func test_increaseProductQuantity_UpdatesQuantity() {
        presenter.increaseProductQuantity(productId: "123")
        XCTAssertTrue(interactor.updateProductQuantityCalled, "Update product quantity should be called when increasing quantity")
    }

    func test_deleteProduct_ClosesViewController() {
        presenter.deleteProduct(productId: "123")
        XCTAssertTrue(interactor.deleteProductFromCoreDataCalled, "Delete product from CoreData should be called when deleting product")
        XCTAssertTrue(router.navigateCalled, "Navigate should be called to close view controller after deleting product")
        XCTAssertEqual(router.navigatedRoute, .listing, "Navigation after deletion should be back to listing")
    }
}
