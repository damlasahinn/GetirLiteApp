//
//  ProductDetailRouter.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 11.04.2024.
//

import Foundation
import ProductAPI

enum ProductDetailRoutes {
    case listing
    case cart
}

protocol ProductDetailRouterProtocol: AnyObject {
    func navigate(_ route: ProductDetailRoutes)
}

final class ProductDetailRouter {
    weak var viewController: ProductDetailViewController?
    static func createModule(with product: Product) -> ProductDetailViewController {
        let view = ProductDetailViewController()
        let interactor = ProductDetailInteractor()
        let router = ProductDetailRouter()
        
        let presenter = ProductDetailPresenter(view: view, router: router, interactor: interactor, product: product)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
    
}

extension ProductDetailRouter: ProductDetailRouterProtocol {
    func navigate(_ route: ProductDetailRoutes) {
        switch route {
        case .listing:
            viewController?.navigationController?.popViewController(animated: true)
        case .cart:
            let cartVC = ShoppingCartRouter.createModule()
            viewController?.navigationController?.pushViewController(cartVC, animated: true)
        }
    }
}
