//
//  WSRFileLoader.swift
//  UISnakeGame
//
//  Created by William Rena on 5/11/23.
//

import UIKit

struct WSRFileLoader {
    func loadJSON<T: Decodable>(
        _ filename: String,
        _ type: T.Type) async throws -> Decodable {
            guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: nil)
            else { throw WSRFileLoaderError.fileNotFound(filename) }

            var data: Data = Data()

            do {
                let (_data, _) = try await URLSession.shared.data(from: fileUrl)
                data = _data
            } catch {
                throw WSRFileLoaderError.fileCannotLoad(error)
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(type, from: data)
            } catch {
                throw WSRFileLoaderError.parsing(error)
            }
        }
}
