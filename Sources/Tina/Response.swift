//
//  Response.swift
//  Tina
//
//  Created by 罗树新 on 2020/10/3.
//
//
// MIT License
//
// Copyright (c) 2020 Later
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


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
