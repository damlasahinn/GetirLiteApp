//
//  ShoppingCartRouter.swift
//  GetirLiteAppTests
//
//  Created by Damla Sahin on 23.04.2024.
//

import Foundation
@testable import GetirLiteApp
@testable import ProductAPI

final class TestShoppingCartRouter: ShoppingCartRouterProtocol {
    var navigateCalled = false
    var route: ShoppingCartRoutes?

    func navigate(_ route: ShoppingCartRoutes, _ product: Product?) {
        navigateCalled = true
        self.route = route
    }
}
