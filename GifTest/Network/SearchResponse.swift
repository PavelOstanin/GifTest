//
//  SearchResponse.swift
//  GifTest
//
//  Created by admin on 04.10.17.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit

class SearchResponse: ServerResponse {
    
    var gifs: Array<GifModel> = []
    
    public override func parseFromResponse(object: Any) {
        super.parseFromResponse(object: object)
        if complete{
            if object is Dictionary<String, Any> {
                let json = object as! Dictionary<String, AnyObject>
                if let data = json["data"] as? [[String:AnyObject]] {
                    for d in data{
                        if let info = d["images"] as? [String:[String:AnyObject]] {
                            if let gifModel = GifModel(dict: info["fixed_height"]) {
                                gifs.append(gifModel)
                            }
                        }
                    }
                    
                } else if let data = json["data"] as? [String:AnyObject] {
                    if let info = data["images"] as? [String:[String:AnyObject]] {
                        if let gifModel = GifModel(dict: info["fixed_height"]) {
                            gifs.append(gifModel)
                        }
                    }
                }
            }
        }
    }
    
}
