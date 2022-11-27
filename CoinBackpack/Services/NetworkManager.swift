//
//  Networking.swift
//  CoinBackpack
//
//  Created by Илья on 21.11.2022.
//
import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetch<T: Decodable>(type: T.Type,
                             needFor: CreateLink.TypeLink,
                             coin name: String? = "",
                             completion: @escaping(Result<T, AFError>) -> Void) {
        
        let link = CreateLink(needLinkFor: needFor, baseAsset: name ?? "")
        
        AF.request(link.url)
            .validate()
            .responseDecodable(of: T.self) { dataResponse in
                switch dataResponse.result {
                case .success(let type):
                    completion(.success(type))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
