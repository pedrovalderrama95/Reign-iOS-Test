//
//  HackerNewsViewModel.swift
//  ReignTest
//
//  Created by Pedro Valderrama on 31/03/2022.
//

import Moya
import SwiftKeychainWrapper


protocol HackerNewsViewModelDelegate: AnyObject {
    func onFinish()
    func onError(error: Error)
    func onLoad()
    func onDelete(index: IndexPath)
}

class HackerNewsViewModel: APIRequestable {
    
    typealias Service = HackerNewsService
    lazy var provider: MoyaProvider<Service> = MoyaProvider<Service>()
    
    var news: [News] = []
    var page = 0
    var isLoadingList = true
    weak var delegate: HackerNewsViewModelDelegate?
    
    func getNews(_ service: Service, _ callback: @escaping (Result<NewsResponse, Error>) -> Void) {
        request(target: service, model: NewsResponse.self, callback: callback)
    }
    
    func incrementPages() {
        if page < 1000 {
            if !isLoadingList {
                page += 1
                getNews()
            }
        }
    }
        
    func deleteNews(index: IndexPath) {
        // Remove an element from the array that feeds the table.
        let newsRemoved = news.remove(at: index.row)
        delegate?.onDelete(index: index)
        
        // Update the latest news in cache
        KeychainWrapper.standard[.lastNews] = JsonUtilities.shared.encode(object: news)
        
        // Agrega un new a la lista de eliminados para no mostrarla en la tabla.
        
        // Add the "newsRemoved" to the "deleted list" to not be show in the list.
        var currentDeleted = JsonUtilities.shared.decode(object: KeychainWrapper.standard[.deletedNews], as: [News].self) ?? []
        currentDeleted.append(newsRemoved)
        KeychainWrapper.standard[.deletedNews] = JsonUtilities.shared.encode(object: currentDeleted)
    }
    
    // Method used to perform the request
    func getNews() {
        
        guard isReachable else {
            //If there is no internet it will download the cached list.
            //If there is something in cache it will assign it to the list.
            if let newsSaved = JsonUtilities.shared.decode(object: KeychainWrapper.standard[.lastNews], as: [News].self) {
                news = newsSaved
            }
            delegate?.onFinish()
            return
        }
        
        // Calls the delegate to show the indicator/Refresh controll
        delegate?.onLoad()
        
        let service = HackerNewsService.getNews(page: page)
        
        getNews(service) { [weak self] result in
            // It already has the information rather it was success or failure
            self?.isLoadingList = false
            
            switch result {
            case let .success(newsReponse):
                // If there is something deleted, it is assigned to currentDeleted, otherwise an empty array is created (nothing saved).
                let currentDeleted = JsonUtilities.shared.decode(object: KeychainWrapper.standard[.deletedNews], as: [News].self) ?? []
                
                // Filter the API array, the news that are not already stored in the deleted list.
                let newsToAdd = newsReponse.news.filter { news in
                    !currentDeleted.contains(news)
                }
                
                // Add a new Element in the list if it does not contain it
                newsToAdd.forEach {
                    if self?.news.contains($0) == false {
                        self?.news.append($0)
                    }
                }
                
                // Save the latest news in chache from the array self?.news
                KeychainWrapper.standard[.lastNews] = JsonUtilities.shared.encode(object: self?.news)
                
                //calls the delegate to show the indicator/Refresh controll
                
                self?.delegate?.onFinish()
            case let .failure(error):
                self?.delegate?.onError(error: error)
            }
        }
        
    }
    
}
