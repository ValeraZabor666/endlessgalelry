//
//  GalleryView.swift
//  endlessgallery
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation
import UIKit
import RealmSwift

protocol GalleryViewControllerProtocol {
    var presenter: GalleryPresenterProtocol? { get set }
    
    func setGallery(data: APIResponse)
    func setOfflineGallery()
}

class GalleryViewController: UIViewController, GalleryViewControllerProtocol, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var presenter: GalleryPresenterProtocol?
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(GalleryTableViewCell.self,
                       forCellReuseIdentifier: GalleryTableViewCell.id)
        return table
    }()
    var elements: [Result] = []
    var page = 1
    let realm = try! Realm()
    var items: Results<Elements>!
    var offline = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.getPhotos()
        setViewDetails()
        setTableView()
    }
    
    func setGallery(data: APIResponse) {
        if elements.count == 0 {
            elements = data.results
        } else {
            elements += data.results
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setOfflineGallery() {
        items = realm.objects(Elements.self)
        offline = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setViewDetails() {
        title = "Gallery"
        view.backgroundColor = .white
    }
    
    private func setTableView() {
        tableView.frame  = view.bounds
        tableView.backgroundColor = UIColor(red: 0.9,
                                            green: 0.9,
                                            blue: 0.9,
                                            alpha: 1.0)
        self.tableView.rowHeight = 200
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if offline == true {
            return items.count
        } else {
            return elements.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GalleryTableViewCell.id,
                                                 for: indexPath) as! GalleryTableViewCell
        if offline == true {
            cell.offlineSet(index: indexPath.row)
        } else {
            let queue = DispatchQueue.global(qos: .background)
            queue.async() {
                cell.set(info: self.elements[indexPath.row])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! GalleryTableViewCell
        if offline == true {
            AllData.sharedData.id = items[indexPath.row].id
        } else {
            AllData.sharedData.id = elements[indexPath.row].id
        }
        currentCell.setImage()
        presenter?.openPhoto()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > scrollView.contentSize.height - scrollView.frame.size.height + 100 {
            page += 1
            presenter?.getMorePhotos(page: page)
        }
    }
}
