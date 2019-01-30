//
//  ResultModel.swift
//  Networking
//
//  Created by OSX on 2.03.2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation
import Alamofire

open class ResultModel<T: Serializable>{
    
    private var model: Any?
    private var json: String = ""
    private var token: String = ""
    private var networkResponse : [String: String]?
    private var requestParams: [String: Any]?
    private var responseHeaders: [AnyHashable: Any]?
    
    public init() {
        
    }
    
    //-- GET PROPERTY
    public func getNetworkResponse() -> [String: String]? {
        return self.networkResponse ?? nil
    }
 
    public func getJsonObject() -> Any? {
        if let data = self.json.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    public func getJsonArray() -> [Any]? {
        if let data = self.json.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    public func getModel<T:Codable>(type: T.Type) -> T? {
        
        return  self.model as? T
    }
    
    public func getRequestParams() -> [String: Any]? {
        return self.requestParams
    }

    public func getJson() -> String {
        return self.json
    }

    public func getToken() -> String {
        return self.token
    }
    
    public func getResponseHeaders() -> [AnyHashable: Any]? {
        return responseHeaders
    }
    
//-----  SET PROPERTY
    public func setJson(json: String?) {
        self.json = json ?? ""
    }

    public func setModel<T: Codable>(model: T?, type: T.Type) {
        self.model = model
    }
    
    public func setArrayModel<T>(model: [T]?, type: [T].Type) {
        self.model = model
    }
    
    public func setRequestParams(requestParams: [String: Any]?) {
        self.requestParams = requestParams
    }
    
    public func setToken(token: String) {
        self.token = token
    }
    
    internal func setNetworkResponse(networkResponse: [String: String]) {
        self.networkResponse = networkResponse
    }
    
    internal func setResponseHeaders(_ headers: [AnyHashable: Any]?) {
        self.responseHeaders = headers
    }
}

open class DownloadResultModel<T: Serializable>  : ResultModel<T>{
    
    private var data: Data?
    
    internal func setData(data: Data?) {
        self.data = data ?? nil
    }
    public func getData() -> Data? {
        return self.data
    }
}
