//
//  PKCS12.swift
//  Networking
//
//  Created by umut on 20.12.2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation
public class PKCS12  {
    var label:String?
    var keyID:Data?
    var trust:SecTrust?
    var certChain:[SecTrust]?
    var identity:SecIdentity?
    
    let securityError:OSStatus
    
    public init(data:Data, password:String) {
        
        //self.securityError = errSecSuccess
        
        var items:CFArray?
        let certOptions:NSDictionary = [kSecImportExportPassphrase as NSString:password as NSString]
        
        // import certificate to read its entries
        self.securityError = SecPKCS12Import(data as NSData, certOptions, &items);
        
        if securityError == errSecSuccess {
            let certItems:Array = (items! as Array)
            let dict:Dictionary<String, AnyObject> = certItems.first! as! Dictionary<String, AnyObject>;
            
            self.label = dict[kSecImportItemLabel as String] as? String;
            self.keyID = dict[kSecImportItemKeyID as String] as? Data;
            self.trust = dict[kSecImportItemTrust as String] as! SecTrust?;
            self.certChain = dict[kSecImportItemCertChain as String] as? Array<SecTrust>;
            self.identity = dict[kSecImportItemIdentity as String] as! SecIdentity?;
        }
        
        
    }
    
    
    public convenience init(mainBundleResource:String, resourceType:String, password:String) {
        
        let environments =  ProcessInfo.processInfo.environment
        let isRunningTestsValue = environments["APPS_IS_RUNNING_TEST"]
        if isRunningTestsValue != nil && isRunningTestsValue == "YES"{
            let testBundle = Bundle(for: type(of: self))
        
            //let bundleName = testBundle.bundleURL.lastPathComponent
            let path  = testBundle.path(forResource: mainBundleResource, ofType:resourceType)!
             self.init(data: NSData(contentsOfFile: path)! as Data, password: password);
           
        }else{
             self.init(data: NSData(contentsOfFile: Bundle.main.path(forResource: mainBundleResource, ofType:resourceType)!)! as Data, password: password);
        }
       
    }
    
    public func urlCredential()  -> URLCredential  {
        return URLCredential(
            identity: self.identity!,
            certificates: self.certChain!,
            persistence: URLCredential.Persistence.forSession);
        
    }
    
    
    
}
