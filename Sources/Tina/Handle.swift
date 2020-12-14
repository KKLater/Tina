//
//  Adapt.swift
//  RRCNetwork
//
//  Created by 罗树新 on 2020/10/2.
//

import Foundation

public typealias HandleableCallBack = (continue: Bool, error: Error?)

public protocol Handleable {}

public protocol RequestHandleable {
    
    /// 请求发起前的处理
    /// - Parameter request: 需要做处理的请求
    func handle(_ request: Request) -> HandleableCallBack?
}

public protocol ResponseHandleable {
    
    /// 请求响应的处理
    /// - Parameter response: 请求响应
    func handle(_ response: Response) -> HandleableCallBack?
}
