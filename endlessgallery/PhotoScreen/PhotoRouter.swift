//
//  PhotoRouter.swift
//  endlessgallery
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation
import UIKit

protocol PhotoRouterProtocol {
    
    var entry: UIViewController? { get }
    static func start() -> PhotoRouterProtocol
}

class PhotoRouter: PhotoRouterProtocol {
    
    var entry: UIViewController?
    
    static func start() -> PhotoRouterProtocol {
        let router = PhotoRouter()
        
        //vip
        var view: PhotoViewControllerProtocol = PhotoViewController()
        var presenter: PhotoPresenterProtocol = PhotoPresenter()
        var interactor: PhotoInteractorProtocol = PhotoInteractor()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view as? UIViewController
        
        return router
    }
    
}
