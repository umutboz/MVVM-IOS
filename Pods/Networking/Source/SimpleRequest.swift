//
//  SimpleRequest.swift
//  Networking
//
//  Created by Umut BOZ on 09/03/2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation
import Alamofire

open class SimpleRequest : Alamofire.SessionManager {
    
    private var headers: [String: String] = [:]
    private var inputType: String.Type?
    private var outputType: String.Type?
    private var object: String?
    private var jsonKeys: [String]?
    private var timeOut: Int?
    private var parameters: Parameters?
    private var request: DataRequest!
    
    public init() {
        super.init()
    }
    
    // MARK: -
    // MARK: CREATE REQUEST
    init(url: String, method: HTTPMethod, jsonKeys: [String]? = nil) {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = NetworkConfig.shared.getDefaultHeaders()
        super.init(configuration:configuration);
        self.jsonKeys = jsonKeys
        
        headers = getHeaders()
        request = super.request(url, method: method, encoding: URLEncoding.default, headers: headers)
    }
    
    public func getHeaders() -> [String: String] {
        let defaultHeaders = NetworkConfig.shared.getDefaultHeaders()
        for (key, value) in defaultHeaders {
            headers[key] = value
        }
        return headers
    }
    
    internal func getBody() -> [String: Any]? {
        return nil
    }
    
    public func addHeader(_ key: String, value: String) -> Self {
        headers[key] = value
        return self
    }
    
    internal func parseNetworkResponse(success: @escaping(Success<String>)) {
        request.response { response in
            let json = response.data?.toString()
            let result = self.getResultModel(json)
            success(result)
        }
    }
    
    // MARK: GET RESULT MODEL
    internal func getResultModel(_ json: String?) -> ResultModel<String> {
        if jsonKeys == nil || jsonKeys?.isEmpty == true {
            let resultModel = ResultModel<String>()
            resultModel.setJson(json: json)
            resultModel.setModel(model: json, type: String.self)
            return resultModel
        } else {
            let jsonDict = json?.toData() as? [String: Any]
            var jsonData: Any?
            for jsonKey in jsonKeys! {
                jsonData = jsonDict![jsonKey]
                if jsonData == nil {
                    if let str = jsonData as? String, str == "null" {
                        continue
                    }
                    continue
                } else {
                    break
                }
            }
            let resultModel = ResultModel<String>()
            resultModel.setJson(json: json)
            resultModel.setModel(model: jsonData as? String, type: String.self)
            
            return resultModel
        }
    }

  
}

