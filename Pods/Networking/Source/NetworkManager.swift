//
//  KSNetworkManager.swift
//  Networking
//
//  Created by Halil İbrahim YILMAZ on 05/03/2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//
//  Edit @umut 14/03/2018.
import Foundation
import Alamofire

public typealias DownloadSuccess<T : Serializable> = (DownloadResultModel<T>) -> Void
public typealias Success<T : Serializable> = (ResultModel<T>) -> Void
public typealias Fail = (ErrorModel) -> Void

open class NetworkManager {
    
    private var keys: [String]?
    private var customErrorStatusCodes : Array<Int>? = Array<Int>()
    private var successStatusCodes : Array<Int>? = Array<Int>()
    private var learning : NetworkLearning?
   
    private var isEnableSSLCertificate = false
    private var ssl : PKCS12?
    
    public init() { }
    
    // Static dictionary tut.
    
    // MARK: -
    
    // MARK: GET REQUEST
    public func get<T: Serializable>(_ url: String,
                                     success: @escaping Success<T>,
                                     fail: @escaping Fail) -> GenericObjectRequest<String, T> where T : Serializable {
        
        let fullPath = (NetworkConfig.shared.getURL() ?? "") + url
        let request = GenericObjectRequest<String, T>(url: fullPath, method: HTTPMethod.get, inputModel: nil, inputType: nil, outputType: T.self, jsonKeys: getJsonKey())
        request.setLearning(learning: learning)
        request.successCallback = success
        request.errorCallback = fail
        if self.isEnableSSLCertificate{
            request.delegate.sessionDidReceiveChallenge = { session, challenge in
                if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
                    return (URLSession.AuthChallengeDisposition.useCredential, self.ssl!.urlCredential());
                }
                if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                    return (URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!));
                }
                return (URLSession.AuthChallengeDisposition.performDefaultHandling, Optional.none);
            }
        }
        return request
    }
    
    
    // MARK: POS REQUEST
    public func post<R, T: Serializable>(_ url: String,
                                         bodyParameters: R? = nil,
                                         success: @escaping Success<T>,
                                         fail: @escaping Fail) -> GenericObjectRequest<R, T> {
        let fullPath = (NetworkConfig.shared.getURL() ?? "") + url
        let request = GenericObjectRequest<R, T>(url: fullPath, method: .post, inputModel: bodyParameters, inputType: R.self, outputType: T.self, jsonKeys: getJsonKey())
        request.setLearning(learning: learning)
        request.successCallback = success
        request.errorCallback = fail
        if self.isEnableSSLCertificate{
            request.delegate.sessionDidReceiveChallenge = { session, challenge in
                if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
                    return (URLSession.AuthChallengeDisposition.useCredential, self.ssl!.urlCredential());
                }
                if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                    return (URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!));
                }
                return (URLSession.AuthChallengeDisposition.performDefaultHandling, Optional.none);
            }
        }
        return request
    }
    
    // MARK: BASIC GET REQUEST
    public func basicGet(_ url: String, success: @escaping (String?) -> Void) {
        let simpleRequest = SimpleRequest(url:url, method: HTTPMethod.get)
        simpleRequest.parseNetworkResponse { resultModel in
            success(resultModel.getJson())
        }
    }
    
    // MARK: BASIC POST REQUEST
    public func basicPost(_ url: String, success: @escaping (String?) -> Void) {
        let simpleRequest = SimpleRequest(url: url, method: .post)
        simpleRequest.parseNetworkResponse { resultModel in
            success(resultModel.getModel(type : String.self))
        }
    }
    
    public func getData<T:Serializable>(_ url: String, headers: [String:String], success: @escaping DownloadSuccess<T>,fail: @escaping Fail)
        -> DownloadRequest<T> where T : Serializable {
            
            let downloadRequest = DownloadRequest(url: url, method: HTTPMethod.get, outputType: T.self, headers:headers)
            downloadRequest.successCallback = success
            downloadRequest.errorCallback = fail
            if self.isEnableSSLCertificate{
                downloadRequest.delegate.sessionDidReceiveChallenge = { session, challenge in
                    if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
                        return (URLSession.AuthChallengeDisposition.useCredential, self.ssl!.urlCredential());
                    }
                    if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                        return (URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!));
                    }
                    return (URLSession.AuthChallengeDisposition.performDefaultHandling, Optional.none);
                }
            }
            return downloadRequest
    }
    
    // MARK: SET CUSTOM JSON KEY
    public func setJsonKey(_ keys: [String]?) {
        self.keys = keys
    }
    
    internal func getJsonKey() -> [String]? {
        return keys
    }
    
    // MARK: SET NETWORK LEARNING
    public func setNetworkLearning(learning : NetworkLearning) {
        self.learning = learning
    }
  

    //SSL creditianl
    public func enableCertificatePinning(pkcs12Certificate:PKCS12){
        self.ssl = pkcs12Certificate
        self.isEnableSSLCertificate = true
    }
    public func disableCertificatePinning(){
        self.ssl = nil
        self.isEnableSSLCertificate = false
  
    }
}
