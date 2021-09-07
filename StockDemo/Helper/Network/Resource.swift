//
//  Resource.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/6.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

typealias ResourceParameter = [String: String]

struct Resource<T: Decodable> {
    // MARK:- Public property
    let url: URL
    let parameters: ResourceParameter
    let httpMethod: HttpMethod
    var urlRequest: URLRequest? {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        urlComponents.queryItems = parameters.keys.map({ key in
            URLQueryItem(name: key, value: parameters[key])
        })
        guard let url = urlComponents.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        return urlRequest
    }
    
    // MARK:- Private property
    
    // MARK:- Initialization
    init(url: URL, parameters: ResourceParameter, httpMethod: HttpMethod = .get) {
        self.url = url
        self.parameters = parameters
        self.httpMethod = httpMethod
    }
    
    // MARK:- Public methods
    
    // MARK:- Private methods
}
