//
//  KSNetworkCancellation.swift
//  Networking
//
//  Created by Umut BOZ on 22/05/2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation
import Alamofire
public class NetworkCancellation {
   public static var taggedRequests: [NetworkCancelObject] = [NetworkCancelObject]()
    

    public static func addRequest(_ tag : String, request : DataRequest )
    {
        let cancelRequet = NetworkCancelObject()
        cancelRequet.request = request
        cancelRequet.tag = tag
        NetworkCancellation.taggedRequests.append(cancelRequet)
        print("taged request %@",tag)
    }
    public static func removeRequest(_ tag : String) throws -> Void
    {
        do{
            guard let index = try? NetworkCancellation.taggedRequests.index(where : {$0.tag == tag}) else {
                print("tag not found")
            }
           let taggedRequest = NetworkCancellation.taggedRequests.filter( { return $0.tag == tag } ).first
            taggedRequest?.request?.cancel()
            NetworkCancellation.taggedRequests.remove(at : index as! Int)
            print("%@ request cancelled",tag)
        }catch let error as Error{
            print(error.localizedDescription)
            throw error
        }
    }
    
    public static func hasRequest(_ tag : String) -> Bool
    {
        if taggedRequests.contains(where: { $0.tag == tag }){
            return true
        }
        else{
            return false
        }
    }
    public static func cancel(_ tag :String) throws  -> Void
    {
        if(hasRequest(tag))
        {
            try NetworkCancellation.removeRequest(tag)
        }
        else
        {
            print("%@ request cancel tag not found",tag)
            
        }
        
    }
}
