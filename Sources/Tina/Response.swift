//
//  Response.swift
//  Tina
//
//  Created by 罗树新 on 2020/10/3.
//

import Foundation
import Alamofire

public protocol Responseable : JSONable { }

public struct Response {
    
    /// 请求结果
    public var result: Any?
    
    /// 错误
    public var error: Error?
    
    /// 请求返回结果
    public var response: HTTPURLResponse?

    /// 请求数据流
    public var data: Data?

    /// The final metrics of the response.
    ///
    /// - Note: Due to `FB7624529`, collection of `URLSessionTaskMetrics` on watchOS is currently disabled.`
    ///
    public var metrics: URLSessionTaskMetrics?

    /// The time taken to serialize the response.
    public var serializationDuration: TimeInterval = 0.0
    
    /// 底层（AF）返回数据对象
    public var afResponse: Alamofire.AFDataResponse<Any>?
    
    /// 任务
    public weak var task: Task?
}
