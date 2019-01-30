//
//  ErrorModel.swift
//  Networking
//
//  Created by OSX on 2.03.2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//


open class ErrorModel {
    
    private var errorModel: Any?
    private var errorCode: Int?
    private var description = String()
    private var data: String?
    private var networkErrorTypes : NetworkErrorTypes?
    private var retryCount = Int()
    
    public init() { }
    
    //--- SET Property
    public func setErrorModel(model: Any) {
        self.errorModel = model
    }
    
    public func setHttpErrorCode(errorCode: Int?) {
        self.errorCode = errorCode
    }
    
    public func setDescription(description: String) {
        self.description = description
    }
    
    public func setData(data: String?) {
        self.data = data
    }
    
    public func setNetworkErrorTypes(types: NetworkErrorTypes) {
        self.networkErrorTypes = types
    }
    
    public func setRetryCount(retryCount: Int) {
        self.retryCount = retryCount
    }
    
    //--- GET Property
    public func getErrorModel() -> Any? {
        return self.errorModel
    }
    
    public func getHttpErrorCode() -> Int? {
        return self.errorCode
    }
    
    public func getDescription() -> String {
        return self.description
    }
    
    public func getData() -> String? {
        return self.data
    }
    
    public func getNetworkErrorTypes() -> NetworkErrorTypes? {
        return self.networkErrorTypes
    }
    
    public func hasServerError() -> Bool {
        if getNetworkErrorTypes() != nil {
            if getNetworkErrorTypes() == NetworkErrorTypes.serverError {
                return true
            }
        }
        return false
    }
    
    public func getRetryCount() -> Int {
        return self.retryCount
    }
}
