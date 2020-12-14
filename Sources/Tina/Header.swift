//
//  Header.swift
//  RRCNetwork
//
//  Created by 罗树新 on 2020/10/2.
//

import Foundation

public typealias Headers = [String: String]

public extension Headers {
    
    /// 以 dic 方式补充头信息
    /// - Parameter dic: 头信息dic
    mutating func append(_ dic: [String : String]) {
        for (key, value) in dic {
            self[key] = value
        }
    }
}

public struct Header: JSONable {

    public var accept: String?
    
    public var acceptCharset: String?
    
    public var acceptLanguage: String?
    
    public var acceptEncoding: String?
    
    public var authorization: String?
    
    public var contentDisposition: String?
    
    public var contentType: String?
    
    public var userAgent: String?
        
    public func headers() -> Headers {
        return jsonDictionary() as? Headers ?? [:]
    }
    
    public init() {}
}

private extension Header {
     enum CodingKeys: String, CodingKey {
        case accept = "Accept"
        case acceptCharset = "Accept-Charset"
        case acceptLanguage = "Accept-Language"
        case acceptEncoding = "Accept-Encoding"
        case authorization = "Authorization"
        case contentDisposition = "Content-Disposition"
        case contentType = "Content-Type"
        case userAgent = "User-Agent"
    }
}
