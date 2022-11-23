//
//  Networking.swift
//  CoinBackpack
//
//  Created by Илья on 21.11.2022.
//
import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetch<T: Decodable>(type: T.Type,
                             next url: String? = "",
                             coin name: String? = "",
                             completion: @escaping(Result<T, NetworkError>) -> Void) {

        let link = CreateLink(next: url ?? "", baseAsset: name ?? "")
        print(link.url)

        guard let url = URL(string: link.url ) else {
                completion(.failure(.invalidURL))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let type = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(type))
                    }
                } catch {
                    completion(.failure(.decodingError))
                }
            }.resume()
        }
    
    func sendPostRequest(to url: String, with data: MarketsInfo?, completion: @escaping(Result<MarketsInfo, AFError>) -> Void) {
        AF.request(url, method: .post, parameters: data)
            .validate()
            .responseDecodable(of: AddCoin.self) { dataResponse in
                switch dataResponse.result {
                case .success(let coinJP):
                    let coin = MarketsInfo(coinJP: coinJP)
                    completion(.success(coin))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

enum Link: String {
    case postRequest = "https://jsonplaceholder.typicode.com/posts"
}