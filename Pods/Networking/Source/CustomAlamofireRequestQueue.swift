//
//  CustomAlamofireRequestQueue.swift
//  Networking
//
//  Created by Halil İbrahim YILMAZ on 02/03/2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation

open class CustomAlamofireRequestQueue {
    
    private static var mInstance: CustomAlamofireRequestQueue?
    private static var mCtx: String?
    private var mRequestQueue: DispatchQueue?
    
}
