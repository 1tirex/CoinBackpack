//
//  AlertController+.swift
//  CoinBackpack
//
//  Created by Илья on 26.11.2022.
//

enum StutusAlert: String {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success: return "Success"
        case .failed: return "Failed"
        }
    }
    
    var message: String {
        switch self {
        case .success: return  "Good job"
        case .failed: return "Please check the entered data. All fields must be filled."
        }
    }
}
