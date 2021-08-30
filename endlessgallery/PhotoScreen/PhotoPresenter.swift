//
//  PhotoPresenter.swift
//  endlessgallery
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation

protocol PhotoPresenterProtocol {
    var router: PhotoRouterProtocol? { get set }
    var interactor: PhotoInteractorProtocol? { get set }
    var view: PhotoViewControllerProtocol? { get set }
}

class PhotoPresenter: PhotoPresenterProtocol {
    
    var router: PhotoRouterProtocol?
    var interactor: PhotoInteractorProtocol?
    var view: PhotoViewControllerProtocol?
    
}
