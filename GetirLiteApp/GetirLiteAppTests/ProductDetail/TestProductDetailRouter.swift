//
//  ProductDetailRouter.swift
//  GetirLiteAppTests
//
//  Created by Damla Sahin on 23.04.2024.
//

import Foundation
@testable import GetirLiteApp

final class TestProductDetailRouter: ProductDetailRouterProtocol {
    var navigateCalled = false
    var navigatedRoute: ProductDetailRoutes?

    func navigate(_ route: ProductDetailRoutes) {
        navigateCalled = true
        navigatedRoute = route
    }
}
