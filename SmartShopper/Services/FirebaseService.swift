//
//  FirebaseService.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 05.05.2025.
//

import Foundation

protocol FetchDataService {
    func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void)
    func saveData<T: Encodable>(_ object: T, to url: URL, completion: @escaping (Result<Void, Error>) -> Void)
}

final class FirebaseService: FetchDataService {
    static func setup() {
//        FirebaseApp.configure()
    }

    func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                return
            }
        }
    }

    func saveData<T>(_ object: T, to url: URL, completion: @escaping (Result<Void, any Error>) -> Void) where T : Encodable {
        print("Hello")
    }
}
