//
//  KSNetworkConfig.swift
//  Networking
//
//  Created by Yağızhan Akduman on 2.03.2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation
import Alamofire

open class NetworkConfig {
    
    public static var shared: NetworkConfig = NetworkConfig()
    
    private var URL: String?
    private var defaultHeaders: HTTPHeaders = [:]
    private var errorStatusCode: [Int] = []
    private static var bodyContentType: String!
    private var customErrorStatusCodes: [Int] = []
    private var successStatusCodes: [Int] = []
//    private var networkLearning: KSNetworkLearning?
    
    private init() { }
    
    open func addHeader(headerKey: String, headerValue: String) -> NetworkConfig {
        if !defaultHeaders.contains(where: {(key,value) -> Bool in headerValue.localizedCaseInsensitiveContains(String(value)) && key == headerKey }) {
            defaultHeaders[headerKey] = headerValue
        }
        return self
    }
    
    open func removeHeaderByKey(key: String) -> NetworkConfig {
        if defaultHeaders.keys.contains(key) {
            defaultHeaders.removeValue(forKey: key)
        }
        return self
    }
    
    open func addHeader(parameters: [String: String]?) -> NetworkConfig {
        guard let parameters = parameters else { return self }
        for (key, value) in parameters {
            defaultHeaders[key] = value
        }
        return self
    }
    
    open func deleteAllHeaders() { defaultHeaders = [:] }
    
    open func getDefaultHeaders() -> [String: String] { return defaultHeaders }
    
    open func setDefaultHeaders(defaultHeaders: [String: String]) { self.defaultHeaders = defaultHeaders }
    
    open func getURL() -> String? { return URL }
    
    open func setURL(URL: String) { self.URL = URL }
    
    open func getResultErrorCode() -> [Int] { return errorStatusCode }
    
    open func setResultErrorCode(resultErrorCode: [Int]) { self.errorStatusCode = resultErrorCode }
    
    open func getSuccessStatusCode() -> [Int] {
        return successStatusCodes
    }
    
    open func getCustomErrorStatusCode() -> [Int] {
        return customErrorStatusCodes
    }
    
    open func setSucccessStatusCodes<S: Sequence>(statusCode acceptableStatusCodes: S) where S.Iterator.Element == Int {
        successStatusCodes = Array(acceptableStatusCodes)
    }
    
    open func setCustomErrorStatusCodes<S: Sequence>(statusCode errorStatusCodes: S) {
        customErrorStatusCodes = Array(errorStatusCodes.flatMap{ $0 as? Int })
        
    }
    
    open func addCustomErrorStatusCodes(statusCode : Int) -> Void {
        customErrorStatusCodes.append(statusCode)
    }
    
    open static func getBodyContentType() -> String { return bodyContentType ?? "application/json; charset=utf-8" }
    
    open static func setBodyContentType(contentType: String) { bodyContentType = contentType }
    
}
