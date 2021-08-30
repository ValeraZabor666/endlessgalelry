//
//  PhotoView.swift
//  endlessgallery
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation
import UIKit
import SnapKit
import RealmSwift

protocol PhotoViewControllerProtocol {
    var presenter: PhotoPresenterProtocol? { get set }
}

class PhotoViewController: UIViewController, PhotoViewControllerProtocol {
    
    var presenter: PhotoPresenterProtocol?
    private var image = UIImageView()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        setImage()
        setImageConstraints()
    }
    
    private func setAppearance() {
        view.backgroundColor = .white
        let date = realm.object(ofType: Storage.self, forPrimaryKey: AllData.sharedData.id)
        title = date?.date
    }
    
    private func setImage() {
        image.backgroundColor = .lightGray
        image.image = AllData.sharedData.image
        view.addSubview(image)
    }
    
    private func setImageConstraints() {
        image.snp.makeConstraints { maker in
            maker.width.equalToSuperview()
            maker.top.bottom.equalToSuperview().inset(150)
        }
    }
}
