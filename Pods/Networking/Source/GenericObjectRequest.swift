//
//  GenericObjectRequest.swift
//  Networking
//
//  Created by Halil İbrahim YILMAZ on 02/03/2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//  Edit @umut 14.03.2018

import Foundation
import Alamofire

public class GenericObjectRequest<R, T: Serializable> : Alamofire.SessionManager {
    
    private var headers: [String: String] = [:]
    private var inputType: R.Type?
    private var outputType: T.Type?
    private var object: R?
    private var jsonKeys: [String]?
    private var jsonKey: String?
    private var timeOut: Int?
    private var parameters: Parameters? = [:]
    internal var request: DataRequest!
    private var tag : String?
    
    internal var successCallback: Success<T>?
    internal var errorCallback: Fail?
    private var httpMethod : HTTPMethod?
    private var url : String?
    private var learning : NetworkLearning?
    
    var customErrorStatusCodes: Array<Int>? = Array<Int>()
    var successStatusCodes: Array<Int>? = Array<Int>()
    
    public init() {
        super.init()
    }
    
    // MARK: -
    // MARK: INIT GENERIC REQUEST
    init(url: String, method: HTTPMethod, inputModel : R? = nil,  inputType: R.Type? = nil, outputType: T.Type, jsonKeys: [String]? = nil) {
    
        self.inputType = inputType
        self.outputType = outputType
        self.jsonKeys = jsonKeys
        self.httpMethod = method
        self.url = url
        
        
        /*  INIT SESSION CONFIG    */
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        configuration.httpAdditionalHeaders = NetworkConfig.shared.getDefaultHeaders()
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 20
        super.init(configuration:configuration)
        headers = getHeaders()
        
        /*  BODY PARAMS   */
        if inputModel != nil && !(inputModel is String) {
            let inputJSONString = JSONSerializer.toJson(inputModel!)
            parameters = try? JSONSerializer.toBodyParameter(inputJSONString)
        }  else if let param = inputModel, param is [String: Any] {
            parameters = inputModel as? Parameters
        } else {
            if inputModel != nil {
                let value = inputModel as? String
                if value != "" {
                    parameters = try? JSONSerializer.toBodyParameter(inputModel as! String)
                }
            }
        }
    }

    public func getHeaders() -> [String: String] {
        let defaultHeaders = NetworkConfig.shared.getDefaultHeaders()
        for (key, value) in defaultHeaders {
            headers[key] = value
        }
        return headers
    }
    
    internal func getBody() -> [String: Any]? {
        return parameters
    }
    
    public func addHeader(_ key: String, value: String) -> Self {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = NetworkConfig.shared.getDefaultHeaders()
        configuration.httpAdditionalHeaders![key] = value
        headers = configuration.httpAdditionalHeaders as! [String : String]
        return self
    }
    
    public func setJsonKey(_ key: String?) -> Self {
        if key == nil {
            jsonKeys = nil
        } else {
            jsonKey = key
            jsonKeys = [jsonKey!]
        }
        return self
    }
    
    // MARK: CREATE REQUEST
    public func fetch() {
        if self.httpMethod == .post {
            request = super.request(self.url!, method: httpMethod!, parameters: parameters!, encoding: JSONEncoding.default, headers: headers)
        } else {
            request = super.request(self.url!, method: httpMethod!, encoding: URLEncoding.default, headers: headers)
        }
        //NETWORK CANCELLATION
        if let tagString = getTag(), !tagString.isEmpty {
            NetworkCancellation.addRequest(getTag()!, request: self.request)
        }
        setSuccessStatusCodes(statusCode: 200..<201)
        print("REQUEST      ++++ \(request.description)")
        parseNetworkResponse(success: successCallback!, fail: errorCallback!)
    }
    
    // MARK: NETWORK RESPONSE PARSE
    private func parseNetworkResponse(success: @escaping Success<T>,
                                      fail: @escaping Fail) {
        let utilityQueue = DispatchQueue.global(qos: .utility)
        request.responseString(queue: utilityQueue) { response in
            print("RESPONSE     ++++ \(response.debugDescription)")
            let responseHeaders = response.response?.allHeaderFields
            let hasLearning: Bool = self.learning != nil ? true : false
            switch response.result {
            case .success(let value):
                do {
                    let json = value
                    let result = try self.getResultModel(json)
                    result.setResponseHeaders(responseHeaders)
                    if hasLearning {
                        self.learning?.checkSuccess(responseModel: result, success: success, fail: fail)
                    } else {
                        success(result)
                    }
                } catch let error {
                    let errorModel = ErrorModel()
                    errorModel.setDescription(description: error.localizedDescription)
                    errorModel.setHttpErrorCode(errorCode: response.response?.statusCode)
                    errorModel.setDescription(description: value)
                    errorModel.setData(data: response.data?.toString())
                    if let errorType = error as? NetworkErrorTypes {
                        errorModel.setNetworkErrorTypes(types: errorType)
                    } else {
                        errorModel.setNetworkErrorTypes(types: NetworkErrorTypes.networkError)
                    }
                    if hasLearning {
                        self.learning?.sendError(errorModel: errorModel, fail: fail)
                    } else {
                        fail(errorModel)
                    }
                }
            case .failure(let error):
                let errorModel = ErrorModel()
                errorModel.setDescription(description: error.localizedDescription)
                errorModel.setHttpErrorCode(errorCode: response.response?.statusCode)
                errorModel.setData(data: response.data?.toString())
                errorModel.setNetworkErrorTypes(types: NetworkErrorTypes.networkError)
                //NETWORK CANCELLATION
                if !errorModel.getDescription().isEmpty  && GenericObjectRequest.cancelledTag == errorModel.getDescription().lowercased(){
                    print("request cancelled with tag %@",self.getTag())
                    return
                }
                if hasLearning {
                    let customErrorStatusCode = NetworkConfig.shared.getCustomErrorStatusCode()
                    if customErrorStatusCode.contains(response.response?.statusCode ?? 0) {
                        self.learning?.checkCustomError(errorModel: errorModel, success: success, fail: fail)
                    } else {
                        self.learning?.sendError(errorModel: errorModel, fail: fail)
                    }
                } else {
                    fail(errorModel)
                }
            }
        }
    }
    
    // MARK: GET RESULT MODEL
    private func getResultModel(_ json: String?) throws -> ResultModel<T> {
        if jsonKeys == nil || jsonKeys?.isEmpty == true {
            if isJSONArray(json) {
                let array = json?.toArray(type: [T].self)
                let resultModel = ResultModel<T>()
                resultModel.setArrayModel(model: array, type: [T].self)
                resultModel.setJson(json: json)
                return resultModel
            } else {
                let resultModel = ResultModel<T>()
                let object = json?.toObject(type: T.self)
                resultModel.setModel(model: object,type: T.self)
                resultModel.setJson(json: json)
                return resultModel
            }
        } else {
            guard let jsonDict = json?.toData() as? [String: Any] else {
                let resultModel = ResultModel<T>()
                resultModel.setJson(json: json)
                return resultModel
            }
            
            var jsonData: Any?
            for jsonKey in jsonKeys! {
//                let jsonKeySplit = jsonKey.components(separatedBy: "/")
                let jsonKeySplit = jsonKey.split(separator: "/")
                if jsonKeySplit.count > 1 {
                    var dictionary: [String : Any]? = jsonDict
                    for splittedKey in jsonKeySplit {
                        dictionary = dictionary![splittedKey.description] as? [String: Any]
                    }
                    jsonData = dictionary
                } else {
                    if let jsonArray = jsonDict[jsonKey]  as? [Any] {
                        jsonData = jsonArray
                    } else {
                        jsonData = jsonDict[jsonKey] as? [String: Any]
                    }
                }
                
                if jsonData == nil {
                    if let str = jsonData as? String, str == "null" {
                        continue
                    }
                    continue
                } else {
                    break
                }
            }
            
            let resultModel = ResultModel<T>()
            resultModel.setJson(json: json)
            
            if jsonData != nil && JSONSerialization.isValidJSONObject(jsonData!) {
                do {
                    let data = try JSONSerialization.data(withJSONObject: jsonData!, options: [])
                    if jsonData as? [Any] != nil {
                        let decoder = try JSONDecoder().decode([T].self, from: data)
                        resultModel.setArrayModel(model: decoder, type: [T].self)
                    } else {
                        let decoder = try JSONDecoder().decode(T.self, from: data)
                        resultModel.setModel(model: decoder, type: T.self)
                    }
                } catch let error {
                    print(error.localizedDescription)
                    throw NetworkErrorTypes.parseError
                }
            } else {
                throw NetworkErrorTypes.invalidJSON
            }
            
            return resultModel
        }
    }
    
    private func isJSONArray(_ jsonString: String?) -> Bool {
        let json = jsonString?.toData()
        var result = false
        var jsonData: Any?
        
        if jsonKeys == nil || jsonKeys?.isEmpty == true {
            jsonData = json
            if let _ = jsonData as? [Any] {
                result = true
            } else {
                result = false
            }
        } else {
            for jsonKey in jsonKeys! {
                let object = json as? [String: Any]
                jsonData = object?[jsonKey] as? [Any]
                if object != nil {
                    break
                } else {
                    continue
                }
            }
            if jsonData != nil && isJSONArray(jsonData as? String) {
                result = true
            }
        }
        return result
    }
    
    private func setSuccessStatusCodes<S: Sequence>(statusCode statusCodes: S) where S.Iterator.Element == Int {
        request.validate(statusCode: statusCodes)
    }
    
    internal func setLearning(learning: NetworkLearning?) {
        self.learning = learning
    }
    
    public func setTag(requestTag: String?) -> Self {
        self.tag = requestTag
        return self
    }
    public func getTag() -> String? {
        return self.tag
    }
    public func setTimeout(_ timeout: Int) -> Self {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = TimeInterval(timeout)
        configuration.timeoutIntervalForRequest = TimeInterval(timeout)
        return self
    }
    static var cancelledTag: String { return "cancelled" }
   
}
