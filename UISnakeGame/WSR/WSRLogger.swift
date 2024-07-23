//
//  Helpers.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/4/23.
//

import Foundation

enum WSRDebugInfoKey: String {
    case info = "[INFO]>>"
    case fileloader = "[FILE-LOADER]>>"
    case error = "[ERROR]>>"
    case cache = "[CACHE]>>"
    //
    case realmDb = "[REALM-DB]>>"
    case messaging = "[MESSAGING]>>"
    case map = "[MAP]>>"
    case view = "[VIEW]>>"
    //
    case api = "[API]>>"
    case headers = "[HEADERS]>>"
    case request = "[REQUEST]>>"
    case body = "[BODY]>>"
    case response = "[RESPONSE]>>"
}

struct WSRLogger {
    
    private let nullString = "(null)"
    private let separatorString = "*******************************"
    
    private let allLogKeys: [WSRDebugInfoKey] = []
    private let commonLogKeys: [WSRDebugInfoKey] = [.info, .fileloader, .error, .view]
    private let commonAndPersistentLogKeys: [WSRDebugInfoKey] = [.info, .fileloader, .error]
    private let cacheLogKeys: [WSRDebugInfoKey] = [.cache]
    private let databaseLogKeys: [WSRDebugInfoKey] = [.realmDb]
    private let errorLogKeys: [WSRDebugInfoKey] = [.error]
    private let apiLogKeys: [WSRDebugInfoKey] = [.api]
    private let customLogKeys: [WSRDebugInfoKey] = [.info, .fileloader, .error, .realmDb]
    
    // this will filter what to log only
    // empty means accept all type of logs
    private var filteredLogKeys: [WSRDebugInfoKey] {
        //return commonAndPersistentLogKeys + databaseLogKeys + apiLogKeys + cacheLogKeys
        //return errorLogKeys
        //return customLogKeys
        return commonLogKeys
    }
    
    // MARK: - Deprecated
    
    /**
        Deprecated
     */
    func log(logKey: WSRDebugInfoKey, any: AnyObject, message: String) {
        guard filteredLogKeys.isEmpty ||
                (filteredLogKeys.count > 0 && filteredLogKeys.contains(logKey)) else {
            return
        }
#if DEBUG
        print("\(logKey.rawValue) [\(type(of: any))] :: \(message)")
#endif
    }
    
    /**
        Deprecated
     */
    func log(logKey: WSRDebugInfoKey = .info, category: String, message: String) {
        guard filteredLogKeys.isEmpty ||
                (filteredLogKeys.count > 0 && filteredLogKeys.contains(logKey)) else {
            return
        }
#if DEBUG
        print("\(logKey.rawValue) [\(category)] :: \(message)")
#endif
    }
    
    // MARK: - Private
    
    private func messageFormat(category: WSRDebugInfoKey,
                               message: String,
                               _ file: String,
                               _ function: String,
                               _ line: Int) {
        guard filteredLogKeys.isEmpty ||
                (filteredLogKeys.count > 0 && filteredLogKeys.contains(category)) else {
            return
        }
        
#if DEBUG
        let filename = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
        print("\(category.rawValue) [\(filename).\(function):\(line)] - \(message)")
#endif
    }
    
    private func messageFormat(category: WSRDebugInfoKey,
                               _ file: String,
                               _ function: String,
                               _ line: Int) {
        guard (filteredLogKeys.count > 0 && filteredLogKeys.contains(category)) else {
            return
        }
        
        let filename = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
#if DEBUG
        print("\(category.rawValue) [\(filename).\(function):\(line)]")
#endif
    }
    
    // MARK: - Public
    
    /**
        [INFO]>> [MessagingChatsView.body:27] - selected-item index: 3
     */
    func log(category: WSRDebugInfoKey,
             message: String,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
        self.messageFormat(category: category, message: message, file, function, line)
    }
    
    func realm(message: String,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
        self.messageFormat(category: WSRDebugInfoKey.realmDb, message: message, file, function, line)
    }
    
    func cache(message: String,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
        self.messageFormat(category: WSRDebugInfoKey.cache, message: message, file, function, line)
    }
    
    func info(message: String,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
        self.messageFormat(category: WSRDebugInfoKey.info, message: message, file, function, line)
    }
    
    func api(message: String,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
        self.messageFormat(category: WSRDebugInfoKey.api, message: message, file, function, line)
    }
    
    func error(message: String,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
        self.messageFormat(category: WSRDebugInfoKey.error, message: message, file, function, line)
    }
    
    func api(request: URLRequest, httpResponse: HTTPURLResponse, data: Data) {
        guard filteredLogKeys.isEmpty ||
                (filteredLogKeys.count > 0 && filteredLogKeys.contains(WSRDebugInfoKey.api)) else {
            return
        }
        
        self.request(request: request)
        self.response(request: request, httpResponse: httpResponse, data: data)
    }
    
    func realmDB() {
        guard filteredLogKeys.isEmpty ||
                (filteredLogKeys.count > 0 && filteredLogKeys.contains(WSRDebugInfoKey.realmDb)) else {
            return
        }
        
#if DEBUG
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
        print("\(WSRDebugInfoKey.realmDb.rawValue) \(directory)")
#endif
    }
    
    func map(message: String,
              _ file: String = #file,
              _ function: String = #function,
              _ line: Int = #line) {
        self.messageFormat(category: WSRDebugInfoKey.map,
                           message: message, file, function, line)
    }
    
    func view(_ file: String = #file,
              _ function: String = #function,
              _ line: Int = #line) {
        self.messageFormat(category: WSRDebugInfoKey.view,
                           file, function, line)
    }
    
    // MARK: - Request Details
    
    func request(request: URLRequest) {
        let method = request.httpMethod!
        let url = request.url?.absoluteString ?? nullString
        let headers = prettyPrintedString(from: request.allHTTPHeaderFields) ?? nullString
        let body = string(from: request.httpBody, prettyPrint: true) ?? nullString
        
#if DEBUG
        print(separatorString)
        print("\(WSRDebugInfoKey.request.rawValue) \(method) \(url)")
        print("")
        print("\(WSRDebugInfoKey.headers.rawValue)\n\(headers)")
        print("")
        print("\(WSRDebugInfoKey.body.rawValue)\n\(body)")
#endif
    }
    
    func response(request: URLRequest, httpResponse: HTTPURLResponse, data: Data) {
        // request
        let requestMethod = request.httpMethod ?? nullString
        let requestUrl = request.url?.absoluteString ?? nullString

        // response
        let responseStatusCode = httpResponse.statusCode
        let responseHeaders = prettyPrintedString(from: httpResponse.allHeaderFields) ?? nullString
        let responseData = string(from: data, prettyPrint: true) ?? nullString

#if DEBUG
        print(separatorString)
        print("\(WSRDebugInfoKey.response.rawValue) \(requestMethod) \(responseStatusCode) \(requestUrl)")
        print("")
        print("\(WSRDebugInfoKey.headers.rawValue)\n\(responseHeaders)")
        print("")
        print("\(WSRDebugInfoKey.body.rawValue)\n\(responseData)")
        print(separatorString)
#endif
    }
    
    // MARK: - Private Helpers
    
    private func string(from data: Data?, prettyPrint: Bool) -> String? {
        
        guard let data = data else {
            return nil
        }
        
        var response: String? = nil
        
        if prettyPrint,
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let prettyString = prettyPrintedString(from: json) {
            response = prettyString
        }
            
        else if let dataString = String.init(data: data, encoding: .utf8) {
            response = dataString
        }
        
        return response
    }
    
    private func prettyPrintedString(from json: Any?) -> String? {
        guard let json = json else {
            return nil
        }
        
        var response: String? = nil
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let dataString = String.init(data: data, encoding: .utf8) {
            response = dataString
        }
        
        return response
    }
    
}

// global variable
let wsrLogger = WSRLogger()
