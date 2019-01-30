//
//  KSNetworkLearning.swift
//  Networking
//
//  Created by Umut BOZ on 15/03/2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation
public protocol NetworkLearning {

    func sendError(errorModel: ErrorModel, fail: Fail)
    func checkCustomError<ResultType: Serializable>(errorModel: ErrorModel, success: Success<ResultType>,  fail: Fail)
    func checkSuccess<ResultType: Serializable>(responseModel: ResultModel<ResultType>, success: Success<ResultType>, fail: Fail)
}

extension NetworkLearning {
    func sendError(errorModel: ErrorModel, fail: Fail) {
        fail(errorModel)
    }
}

// MARK: Get Model
extension NetworkLearning {
    public func getMappedModel<T: Decodable>(json: String, type: T.Type) -> T? {
        guard let data = json.data(using: .utf8) else { return nil }
        let object = try? JSONDecoder().decode(type, from: data)
        return object
    }
    
    public func getMappedModel(json: String) -> [String: Any]? {
        let dictionary = try? JSONSerializer.toDictionary(json)
        return dictionary as? [String: Any]
    }
}
