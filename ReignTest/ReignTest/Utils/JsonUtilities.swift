//
//  JsonUtilities.swift
//  ReignTest
//
//  Created by Pedro Valderrama on 31/03/2022.
//

import Foundation

class JsonUtilities {
    
    static let shared = JsonUtilities()
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    func encode<T: Codable>(object: T) -> Data? {
        do {
            encoder.outputFormatting = .prettyPrinted
            return try encoder.encode(object)
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func decode<T: Decodable>(object: Data?, as clazz: T.Type) -> T? {
        guard let object = object else { return nil }
        do {
            let data = try decoder.decode(T.self, from: object)
            return data
        } catch {
            print(String(describing: error))
        }
        return nil
    }
    
}

