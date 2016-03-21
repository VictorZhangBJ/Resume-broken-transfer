//
//  DownloadManager.swift
//  ResumeBrokenTransfer
//
//  Created by 张佳宾 on 16/3/17.
//  Copyright © 2016年 victor. All rights reserved.
//

import UIKit

public enum Method: String{
    case GET,POST
}

public protocol URLStringConvertible{
    var URLString: String{ get }
}

extension String: URLStringConvertible{
    public var URLString: String{
        return self
    }
}

extension NSURL: URLStringConvertible{
    public var URLString: String{
        return absoluteString
    }
}

extension NSURLComponents: URLStringConvertible{
    public var URLString: String{
        return URL!.URLString
    }
}

extension NSURLRequest: URLStringConvertible{
    public var URLString: String{
        return URL!.URLString
    }
}

public protocol URLRequestConvertible {
    var URLRequest: NSMutableURLRequest { get }
    
}

extension NSURLRequest :URLRequestConvertible{
    public var URLRequest: NSMutableURLRequest{
        return self.mutableCopy() as! NSMutableURLRequest
    }
}

//MARK: - Convenience

func URLRequest(
    method: Method,
    _ URLString: URLStringConvertible,
    headers: [String: String]? = nil)
-> NSMutableURLRequest
{
    let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: URLString.URLString)!)
    mutableURLRequest.HTTPMethod = method.rawValue
    if let headers = headers{
        for(headerField, headerValue) in headers{
            mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
        }
    }
    return mutableURLRequest
}


class DownloadManager: NSObject {
    
    static let sharedInstance = DownloadManager();
    
    
    
    //将init 方法私有化，防止其他对象通过默认构造函数直接创建这个对象
    private override init() {
        super.init()
    }
    
}
