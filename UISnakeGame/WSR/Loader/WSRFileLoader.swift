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
            else { throw WSRFileLoaderError2.fileNotFound(filename) }

            var data: Data = Data()

            do {
                let (_data, _) = try await URLSession.shared.data(from: fileUrl)
                data = _data
            } catch {
                throw WSRFileLoaderError2.fileCannotLoad(error)
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseModel = try decoder.decode(type, from: data)
                return responseModel
            } catch {
                throw WSRFileLoaderError2.parsing(error)
            }
        }

    /**
        Using Generics
     */
    func loadJSON<T: Decodable>(
        _ filename: String,
        _ type: T.Type,
        completion: @escaping(Result<T, WSRFileLoaderError>) -> Void) {
            
        guard let file = Bundle.main.url(forResource: filename,
                                         withExtension: nil)
        else {
            completion(Result.failure(WSRFileLoaderError.fileNotFound(filename)))
            return
        }

        var data: Data = Data()
            
        do {
            data = try Data(contentsOf: file)
        } catch {
            completion(Result.failure(WSRFileLoaderError.fileCannotLoad(error)))
        }

        do {
            let decoder = JSONDecoder()
            let responseModel = try decoder.decode(type, from: data)
            completion(Result.success(responseModel))
        } catch {
            completion(Result.failure(WSRFileLoaderError.parsing(error as? DecodingError)))
        }
    }
}
