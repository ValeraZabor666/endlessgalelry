//
//  GalleryInteractor.swift
//  endlessgallery
//
//  Created by Captain Kidd on 28.08.2021.
//

import Foundation

protocol GalleryInteractorProtocol {
    var presenter: GalleryPresenterProtocol? { get set }

    func loadData()
    func loadMoreData(page: Int)
}

class GalleryInteractor: GalleryInteractorProtocol{
    
    var presenter: GalleryPresenterProtocol?
    var isLoading = false
    
    func loadData() {
        let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=5&query=office&client_id=IU_QszZHZO4ZCI76OYRM9b7hPuTytuNuROcTnOCwqgs"
        let url = URL(string: urlString)
        let decoder = JSONDecoder()

        getJSON(url: url!) { (data, error) in
            guard let data = data else {
                self.presenter?.uploadDataWithStorage()
                return
            }
            let response = try? decoder.decode(APIResponse.self, from: data)
            if response != nil {
                self.presenter?.uploadData(data: response!)
            }
            else {
                self.presenter?.uploadDataWithStorage()
            }
        }
    }
    
    func loadMoreData(page: Int) {
        if !isLoading {
            isLoading = true
            let urlString = "https://api.unsplash.com/search/photos?page=\(page)&per_page=3&query=office&client_id=IU_QszZHZO4ZCI76OYRM9b7hPuTytuNuROcTnOCwqgs"
            let url = URL(string: urlString)
            let decoder = JSONDecoder()
            let queue = DispatchQueue.global(qos: .background)

            queue.async {
                self.getJSON(url: url!) { (data, error) in
                    guard let data = data else { return }
                    let response = try? decoder.decode(APIResponse.self, from: data)
                    if response != nil {
                        self.presenter?.uploadData(data: response!)
                        self.isLoading = false
                    }
                    self.isLoading = false
                }
            }
        }
    }

    private func getJSON(url: URL, completion: @escaping (Data?, Error?) -> Void) {

        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }

    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {

        return URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }
    
}
