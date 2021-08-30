//
//  PhotoInteractor.swift
//  endlessgallery
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation

protocol PhotoInteractorProtocol {
    var presenter: PhotoPresenterProtocol? { get set }

}

class PhotoInteractor: PhotoInteractorProtocol{
    
    
    var presenter: PhotoPresenterProtocol?
    
}
