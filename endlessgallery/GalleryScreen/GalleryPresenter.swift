//
//  GalleryPresenter.swift
//  endlessgallery
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation

protocol GalleryPresenterProtocol {
    var router: GalleryRouterProtocol? { get set }
    var interactor: GalleryInteractorProtocol? { get set }
    var view: GalleryViewControllerProtocol? { get set }
    
    func openPhoto()
    func getPhotos()
    func uploadData(data: APIResponse)
    func getMorePhotos(page: Int)
    func uploadDataWithStorage()
}

class GalleryPresenter: GalleryPresenterProtocol {
    
    var router: GalleryRouterProtocol?
    var interactor: GalleryInteractorProtocol?
    var view: GalleryViewControllerProtocol?
    
    func openPhoto() {
        router?.openPhoto()
    }
    
    func getPhotos() {
        interactor?.loadData()
    }
    
    func getMorePhotos(page: Int) {
        interactor?.loadMoreData(page: page)
    }
    
    func uploadData(data: APIResponse) {
        view?.setGallery(data: data)
    }
    
    func uploadDataWithStorage() {
        view?.setOfflineGallery()
    }
}
