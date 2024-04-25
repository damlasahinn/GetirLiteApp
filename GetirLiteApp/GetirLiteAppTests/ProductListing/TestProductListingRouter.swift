//
//  ProductListingRouter.swift
//  GetirLiteAppTests
//
//  Created by Damla Sahin on 23.04.2024.
//

import Foundation
@testable import GetirLiteApp
@testable import ProductAPI

final class TestProductListingRouter: ProductListingRouterProtocol {
    
    var isNavigateCalled = false
    var navigatedToRoute: ProductListingRoutes?
    var navigatedWithProduct: Product?

    func navigate(_ route: ProductListingRoutes, _ product: Product?) {
        isNavigateCalled = true
        navigatedToRoute = route
        navigatedWithProduct = product
    }
}
