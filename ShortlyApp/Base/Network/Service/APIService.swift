//
//  APIService.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 23.12.2024.
//


import Foundation
import Alamofire

protocol APIServiceProtocol {
    func createShortenLink(originalUrl: String, title: String, completion: @escaping (Result<[Link], Error>) -> Void)
}

enum APIServiceError: Error {
    case networkError(internal: Error)
    case serializationError(internal: Error)
}

class APIService: APIServiceProtocol {
    
    private let apiKey = "285938e720434ecfbd6f1d034791dd87"
    private let baseUrl = "https://api.rebrandly.com/v1/links"
    
    func createShortenLink(originalUrl: String, title: String, completion: @escaping (Result<[Link], Error>) -> Void) {
        let parameters: [String: Any] = [
            "destination": originalUrl,
            "title": title
        ]
        
        AF.request(baseUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [
            "apikey": apiKey
        ])
        .responseData { response in
            switch response.result {
            case .success(let data):
                print("API Response: \(String(data: data, encoding: .utf8) ?? "")")
                
                let decoder = JSONDecoder()
                do {
                    let link = try decoder.decode(Link.self, from: data)
                    completion(.success([link]))
                    
                } catch {
                    print("Serialization Error: \(error.localizedDescription)")
                    completion(.failure(APIServiceError.serializationError(internal: error)))
                }
                
            case .failure(let error):
                print("Network Error: \(error.localizedDescription)")
                completion(.failure(APIServiceError.networkError(internal: error)))
            }
        }
    }
}
