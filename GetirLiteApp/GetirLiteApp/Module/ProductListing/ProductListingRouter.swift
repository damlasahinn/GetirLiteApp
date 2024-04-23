//
//  ProductListingRouter.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 11.04.2024.
//

import Foundation
import ProductAPI

enum ProductListingRoutes {
    case detail
    case cart
}

protocol ProductListingRouterProtocol: AnyObject {
    func navigate(_ route: ProductListingRoutes,_ product: Product?)
}

final class ProductListingRouter {
    
    weak var viewController: ProductListingViewController?
    
    static func createModule() -> ProductListingViewController {
        
        let view = ProductListingViewController()
        let interactor = ProductListingInteractor()
        let router = ProductListingRouter()
        
        let presenter = ProductListingPresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension ProductListingRouter: ProductListingRouterProtocol {
    func navigate(_ route: ProductListingRoutes, _ product: Product? = nil) {
        switch route {
        case .detail:
            
            guard let product = product else {
                print("Product is required for the detail route.")
                return
            }
            let detailVC = ProductDetailRouter.createModule(with: product)
            viewController?.navigationController?.pushViewController(detailVC, animated: true)

        case .cart:
            let cartVC = ShoppingCartRouter.createModule()
            viewController?.navigationController?.pushViewController(cartVC, animated: true)
        }
    }
}

