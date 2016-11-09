//
//  ImageCache.swift
//  BarApp
//
//  Created by hua on 8/18/16.
//  Copyright © 2016 SoftwareMerchant. All rights reserved.
//

import Foundation

class ImageCache {
    
    static let sharedCache:NSCache = {
        
        let cache = NSCache()
        cache.name = "ImageCache"
        cache.countLimit = 100 //max 100 images in memory
        cache.totalCostLimit = 20*1024*1024 // max 20 MB used
        return cache
    }()
    
}
