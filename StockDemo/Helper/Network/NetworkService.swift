//
//  NetworkService.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/6.
//

import Foundation

enum NetworkError: Error {
    case invalidURLRequest
    case invalidResponse
    case notAuthenticated
    case badRequest
    case notFound
    case jsonDecodingError(error: Error)
    case unknown(statusCode: Int)
}

protocol NetworkServiceProtocol: AnyObject {
    var urlSession: URLSession { get }
    func fetch<T>(_ resource: Resource<T>, completion: @escaping (_ result: Result<T, NetworkError>) -> ())
}

extension NetworkServiceProtocol {
    
    func fetch<T>(_ resource: Resource<T>, completion: @escaping (_ result: Result<T, NetworkError>) -> ()) {
        guard let urlRequest = resource.urlRequest else {
            completion(.failure(.invalidURLRequest))
            return
        }
        
        let task = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let _ = self else {
                completion(.failure(.badRequest))
                return
            }
            
            if let data = data {
                do {
                    
                    let object = try JSONDecoder().decode(T.self, from: data)
//                    print("object: \(object)")
                    completion(.success(object))
                } catch {
                    print("decode error: \(error.localizedDescription)")
                    completion(.failure(.jsonDecodingError(error: error)))
                }
            } else {

            }
        }
        task.resume()
    }
    
    // MARK:- Private methods
}
