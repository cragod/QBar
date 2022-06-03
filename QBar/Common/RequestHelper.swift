//
//  RequestHelper.swift
//  QBar
//
//  Created by Talon Huang on 2022/6/2.
//

import Foundation
import CryptoKit

enum QBarError: Error {
    case missKeyOrSecret
}

enum BinanceFutureAPI: String {
    enum AuthType {
        case none
        case trade
        case userData
        case userStream
        case marketData
        
        var needSingature: Bool {
            switch self {
            case .userData, .trade:
                return true
            default:
                return false
            }
        }
        
        var needAPIKey: Bool {
            switch self {
            case .none:
                return false
            default:
                return true
            }
        }
    }
    
    case accountInfo = "/fapi/v2/account"
    
    var httpMethod: String? {
        "GET"
    }
    
    private var authType: AuthType {
        switch self {
        case .accountInfo:
            return .userData
        }
    }
    
    func fullURL(with parameterString: String) -> URL {
        let baseURL = "https://fapi.binance.com"
        switch self {
        case .accountInfo:
            let url = URL(string: "\(baseURL)\(rawValue)?\(parameterString)")!
//            print("url: \(url)")
            return url
        }
    }
    
    
    func headFields(with key: String? = nil) throws -> [String:String] {
        if authType.needAPIKey {
            guard let key = key else {
                throw QBarError.missKeyOrSecret
            }
            return [
                "X-MBX-APIKEY": key,
                "Content-Type": "application/x-www-form-urlencoded",
            ]
        }
        return [String:String]()
    }
    
    func parameters(with userInfo: [String:Any]? = nil, secret: String? = nil) throws -> String {
        var parameters = userInfo ?? [String:Any]()
        let timestamp = Int(Date.now.timeIntervalSince1970*1000)
        parameters["timestamp"] = timestamp
        let parameterString = parameters.map { String("\($0.key)=\($0.value)") }.joined(separator: "&")
        
        if authType.needSingature {
            guard let secret = secret else {
                throw QBarError.missKeyOrSecret
            }
            
            let signature = hmacSHA256(with: parameterString, secret: secret)
            return [parameterString, ["signature", signature].joined(separator: "=")].joined(separator: "&")
        }
        return parameterString
    }
    
    private func hmacSHA256(with parameterString: String, secret: String) -> String {
        let key = SymmetricKey(data: Data(secret.utf8))
        
        let signature = HMAC<SHA256>.authenticationCode(for: Data(parameterString.utf8), using: key)
        return Data(signature).map { String(format: "%02hhx", $0) }.joined()
    }
}

struct RequestHelper {
    static func generateURLRequest(for api: BinanceFutureAPI, timeout: TimeInterval = 3, key: String? = nil, secret: String?, userInfo: [String: String]? = nil) throws -> URLRequest {
        do {
            let parameterString = try api.parameters(with: userInfo, secret: secret)
            var request = URLRequest(url: api.fullURL(with: parameterString), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeout)
            try api.headFields(with: key).forEach {
                request.setValue($0.value, forHTTPHeaderField: $0.key)
            }
            request.httpMethod = api.httpMethod
            return request
        } catch {
            throw error
        }
    }
}
