//
//  GalleryTableViewCell.swift
//  endlessgallery
//
//  Created by Captain Kidd on 28.08.2021.
//

import UIKit
import SnapKit
import RealmSwift

class GalleryTableViewCell: UITableViewCell {

    static let id = "GalleryCell"
    let realm = try! Realm()
    var items: Results<Elements>!
    
    private var photo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 1
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "loadingImage")
        return imageView
    }()
    
    private var idLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.numberOfLines = 2
        label.textAlignment = .natural
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.numberOfLines = 3
        label.textAlignment = .natural
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(photo)
        contentView.addSubview(idLabel)
        contentView.addSubview(descriptionLabel)
        setPhotoConstraints()
        setLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func offlineSet(index: Int) {
        items = realm.objects(Elements.self)
        idLabel.text = items[index].id
        descriptionLabel.text = items[index].alt_description
        let imgPNG = UIImage(data: items[index].images as Data)
        photo.image = imgPNG
    }
    
    func set(info: Result) {
        DispatchQueue.main.async {
            self.idLabel.text = "id: \n\(info.id)"
            self.descriptionLabel.text = info.alt_description
            self.photo.image = UIImage(named: "loadingImage")
        }
        
        let imageURL: URL = URL(string: info.urls.small)!

        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: imageURL)) {
            let img = UIImage(data: cachedResponse.data)
            DispatchQueue.main.async {
                self.photo.image = img
            }
            return
        }

            let dataTask = URLSession.shared.dataTask(with: imageURL) { [weak self] data,response,error in
                if let data = data, let response = response {
//                    self?.imageToCache(data: data, response: response)
                    DispatchQueue.main.async() {
                        self!.photo.image = UIImage(data: data)!
                        self?.imageToCache(data: data, response: response)
                        self!.saveDate(data: info)
                        self?.makeStorage(data: info, image: UIImage(data: data)!)
                    }
                }
            }
            dataTask.resume()
    }
    
    private func saveDate(data: Result) {
        let obj = realm.object(ofType: Storage.self, forPrimaryKey: data.id)
        if obj != nil {
            return
        }
        
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateString = df.string(from: date)
        let base = Storage()
        base.id = data.id
        base.date = dateString
        
        try! realm.write {
            realm.add(base)
        }
    }
    
    private func makeStorage(data: Result, image: UIImage) {
        let obj = realm.object(ofType: Storage.self, forPrimaryKey: data.id)
        items = realm.objects(Elements.self)
        
        let base = Elements()
        base.id = data.id
        base.alt_description = data.alt_description
        base.date = obj!.date!
        let dataImage = NSData(data: image.jpegData(compressionQuality: 0.9)!)
        base.images = dataImage
        
        try! realm.write {
            realm.add(base)
        }
    }
    
    private func imageToCache(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
    
    private func setPhotoConstraints() {
        photo.snp.makeConstraints { maker in
            maker.top.left.bottom.equalTo(contentView).inset(10)
            maker.width.equalTo(150)
        }
    }
    
    private func setLabelConstraints() {
        idLabel.snp.makeConstraints { maker in
            maker.top.right.equalTo(contentView).inset(10)
            maker.left.equalTo(photo).inset(170)
            maker.height.equalTo(100)
        }
        descriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(idLabel).inset(110)
            maker.left.equalTo(photo).inset(170)
            maker.right.bottom.equalTo(contentView).inset(10)
        }
    }
    
    func setImage() {
        AllData.sharedData.image = photo.image
    }
}
