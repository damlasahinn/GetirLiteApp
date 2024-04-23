//
//  ShoppingCartRouter.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 11.04.2024.
//

import Foundation
import ProductAPI

enum ShoppingCartRoutes {
    case listing
    case detail
}

protocol ShoppingCartRouterProtocol: AnyObject {
    func navigate(_ route: ShoppingCartRoutes, _ product: Product?)
}

final class ShoppingCartRouter {
    
    weak var viewController: ShoppingCartViewController?
    
    static func createModule() -> ShoppingCartViewController {
        
        let view = ShoppingCartViewController()
        let interactor = ShoppingCartInteractor()
        let router = ShoppingCartRouter()
        
        let presenter = ShoppingCartPresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension ShoppingCartRouter: ShoppingCartRouterProtocol {
    func navigate(_ route: ShoppingCartRoutes,_ product: Product? = nil) {
        switch route {
        case .listing:
            let listingVC = ProductListingRouter.createModule()
            viewController?.navigationController?.pushViewController(listingVC, animated: true)
        case .detail:
            guard let product = product else {
                print("Product is required for the detail route.")
                return
            }
            let detailVC = ProductDetailRouter.createModule(with: product)
            viewController?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
