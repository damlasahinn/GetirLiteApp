//
//  ProductListingPresenter.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 11.04.2024.
//

import Foundation
import RxSwift
import RxCocoa
import ProductAPI

protocol ProductListingPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewDidAppear()
    func didSelectProduct(_ product: Product)
    func navigateToCart(_ route: ProductListingRoutes)
    func fetchCartProductsIDs()
}

final class ProductListingPresenter {
    
    unowned var view: ProductListingViewControllerProtocol!
    let router: ProductListingRouterProtocol!
    let interactor: ProductListingInteractorProtocol!
    private let disposeBag = DisposeBag()
    
    init(view: ProductListingViewControllerProtocol!, 
         router: ProductListingRouterProtocol!,
         interactor: ProductListingInteractorProtocol!)
    {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension ProductListingPresenter: ProductListingPresenterProtocol {
    func viewDidLoad() {
        view?.showLoadingView()
        let verticalProductsObservable = interactor.fetchProducts(for: .vertical)
        let horizontalProductsObservable = interactor.fetchProducts(for: .horizontal)

        Observable.zip(verticalProductsObservable, horizontalProductsObservable)
            .subscribe(
                onNext: { [weak self] verticalProducts, horizontalProducts in
                    self?.view.displayProducts(verticalProducts, for: .vertical)
                    self?.view.displayProducts(horizontalProducts, for: .horizontal)
                    self?.view.reloadData()
                    self?.view.hideLoadingView()
                },
                onError: { [weak self] error in
                    self?.view.displayError(error.localizedDescription)
                }
            ).disposed(by: disposeBag)
    }
    
    func viewDidAppear() {
        interactor.calculateTotalCartValue { [weak self] total in
            self?.view?.updateCartValue(total: total)
        }
        fetchCartProductsIDs()
    }
    
    func didSelectProduct(_ product: Product) {
        router.navigate(.detail, product)
    }
    
    func navigateToCart(_ route: ProductListingRoutes) {
        router.navigate(.cart, nil)
    }
    
    func fetchCartProductsIDs() {
        interactor.fetchCartProductIDs { [weak self] ids in
            self?.view.setCartProductsIDs(ids)
        }
    }
}

extension ProductListingPresenter: ProductListingInteractorOutputProtocol {
    func fetchOutput(_ products: [ProductResponse], for type: CollectionViewType) {
        view?.hideLoadingView()
        view?.displayProducts(products, for: type)
        view?.reloadData()
    }
    
    func failedToFetchProducts(with reason: String) {
        view?.displayError(reason)
    }
}

