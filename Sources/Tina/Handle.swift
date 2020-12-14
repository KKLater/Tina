//
//  Adapt.swift
//  RRCNetwork
//
//  Created by 罗树新 on 2020/10/2.
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
