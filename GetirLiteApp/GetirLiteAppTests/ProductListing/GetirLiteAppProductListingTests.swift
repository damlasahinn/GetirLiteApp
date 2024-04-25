//
//  GetirLiteAppTests.swift
//  GetirLiteAppTests
//
//  Created by Damla Sahin on 10.04.2024.
//

import XCTest
@testable import GetirLiteApp
@testable import ProductAPI

final class GetirLiteAppProductListingTests: XCTestCase {
    
    var view: TestProductListingViewController!
    var interactor: TestProductListingInteractor!
    var presenter: ProductListingPresenter!
    var router: TestProductListingRouter!

    
    override func setUp() {
        view = TestProductListingViewController()
        interactor = TestProductListingInteractor()
        router = TestProductListingRouter()
        presenter = ProductListingPresenter(view: view, router: router, interactor: interactor)
    }

    override func tearDown() {
        super.tearDown()
        view = nil
        interactor = nil
        router = nil
        presenter = nil
    }
    
    func test_viewWillAppear_InvokesRequiredViewMethods() {
        XCTAssertFalse(view.isInvokedShowLoading, "Değeriniz True dönüyor, lütfen fonksiyonunuzu kontrol ediniz")
        XCTAssertFalse(view.isInvokedHideLoading, "Değeriniz True dönüyor, lütfen fonksiyonunuzu kontrol ediniz")
        XCTAssertEqual(view.isInvokedShowLoadingCount, 0)
        XCTAssertEqual(view.isInvokedHideLoadingCount, 0)
        presenter.viewDidLoad()
        XCTAssertTrue(view.isInvokedShowLoading, "Değeriniz false, lütfen kontrol ediniz")
        XCTAssertFalse(view.isInvokedHideLoading, "Değeriniz true, lütfen kontrol ediniz")
        XCTAssertEqual(view.isInvokedShowLoadingCount, 1)
        XCTAssertEqual(view.isInvokedHideLoadingCount, 0)
        
    }
    

    func test_viewDidLoad_FetchesProductsForBothHorizontalAndVerticalCollections() {
        presenter.viewDidLoad()

        XCTAssertTrue(interactor.isFetchProductsCalled, "Fetch products should be called on view did load")
        XCTAssertEqual(interactor.fetchProductsCalledCount, 2, "Fetch products should be called twice for both collection view types")
    }

    func test_interactorOutput_FailedToFetchProducts_ShowsError() {
        presenter.failedToFetchProducts(with: "Network Error")

        XCTAssertTrue(view.isInvokedDisplayError, "Display error should be invoked when fetching products fails")
        XCTAssertEqual(view.displayedError, "Network Error", "The displayed error message should match the given error message")
    }

    func test_navigateToCart_NavigatesToCart() {
        presenter.navigateToCart(.cart)

        XCTAssertTrue(router.isNavigateCalled, "Navigate should be called when navigating to cart")
        XCTAssertEqual(router.navigatedToRoute, .cart, "Should navigate to the cart route")
    }

    func test_viewDidAppear_CalculatesTotalCartValue() {
        presenter.viewDidAppear()

        XCTAssertTrue(interactor.isCalculateTotalCartValueCalled, "Calculate total cart value should be called on view did appear")
    }

    func test_interactorOutput_TotalCartValueCalculated_UpdatesCartValue() {
        presenter.totalCartValueCalculated(150.0)

        XCTAssertTrue(view.isInvokedUpdateCartValue, "Update cart value should be invoked when total cart value is calculated")
        XCTAssertEqual(view.updatedCartValue, 150.0, "Updated cart value should match the calculated value")
    }

}
