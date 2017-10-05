//
//  ServerResponse.swift
//  GifTest
//
//  Created by admin on 04.10.17.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit

class ServerResponse: NSObject {
    public var complete: Bool = false
    public var message: String!
    public var errorMessage: String!
    public var errorCode: Int = 0
    public var total: Int = 0
    
    public func parseFromResponse(object: Any) {
        if object is Dictionary<String, Any> {
            let data = object as! Dictionary<String, Any>
            if let complete = data["complete"] as? Bool {
                self.complete = complete
            }
            
            if let pagination = data["pagination"] as? Dictionary<String, Any> {
                if let total = pagination["total_count"] as? Int {
                    self.total = total
                }
            }
            
            if let message = data["message"] as? String {
                self.message = message
            }
            if let errorMessage = data["error_message"] as? String {
                self.errorMessage = errorMessage
            }
            if let errorCode = data["error_code"] as? Int {
                self.errorCode = errorCode
            }
        }
    }
}

