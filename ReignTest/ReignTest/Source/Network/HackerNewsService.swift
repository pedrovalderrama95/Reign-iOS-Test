//
//  HackerNewsService.swift
//  ReignTest
//
//  Created by Pedro Valderrama on 30/03/2022.
//

import Moya

enum HackerNewsService {
    case getNews(page: Int)
}

extension HackerNewsService: TargetType {
    var baseURL: URL { return URL(string: "https://hn.algolia.com")! }
    
    var path: String {
        switch self {
        case .getNews: return "api/v1/search_by_date"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getNews: return .get
        }
    }
    
    var sampleData: Data { return Data() }
    
    
    var task: Moya.Task {
        switch self {
        case let .getNews(page):
            let params: [String : Any] = [
                "query" : "mobile",
                "page" : page,
                "hitsPerPage": "20"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authorizationType: AuthorizationType? {
        return nil
    }
    
}

