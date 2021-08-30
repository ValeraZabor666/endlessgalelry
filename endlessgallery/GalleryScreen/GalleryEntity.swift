//
//  GalleryEntity.swift
//  endlessgallery
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation
import UIKit
import RealmSwift

class AllData {
    static let sharedData = AllData()
    
    var id: String?
    var image: UIImage?
}

struct APIResponse: Codable {
    let results: [Result]
}

struct Result: Codable {
    var id: String
    var alt_description: String
    var urls: URLS
}

struct URLS: Codable {
    var small: String
}

class Storage: Object {
    @objc dynamic var id: String?
    @objc dynamic var date: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Elements: Object {
    @objc dynamic var id = ""
    @objc dynamic var date = ""
    @objc dynamic var alt_description = ""
    @objc dynamic var images = NSData()
}
