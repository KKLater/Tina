//
//  Session.swift
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

public protocol Sessionable {}

public class Session {
    
    /// 单例
    public static let shared = Session()
    
    /// 所有执行任务
    private(set) var tasks = [Task]()
    
    var sessionManager: Alamofire.Session!
        
    init() {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 20
        config.timeoutIntervalForResource = 20
        sessionManager = Alamofire.Session(configuration: config)
    }
    
    /// 发起请求
    /// - Parameters:
    ///   - task: 任务
    ///   - completionHandler: 请求回调
    public func execute(_ task: Task, completionHandler: @escaping (Response) -> Void) {
        let requst = task.request
        let tUrl = task.url()
        let tMethod = self.method(requst.method)
        let tParameters = task.parameters()
        
        var tHeader: HTTPHeaders?
        if let tHeaders = requst.headers {
            tHeader = HTTPHeaders(tHeaders)
        }

        /// 网络连接错误
        if NetworkReachabilityManager.default?.isReachable == false {
            var response = Response()
            response.error = Tina.NetReachabilityError.unReachable
            completionHandler(response)
            return
        }
        
        sessionManager.sessionConfiguration.timeoutIntervalForRequest = task.requestContext?.timeoutIntervalForRequest ?? 20
        sessionManager.sessionConfiguration.timeoutIntervalForResource = task.requestContext?.timeoutIntervalForResource ?? 20
        
        /// 发起网络请求
        let afRequest = sessionManager.request(tUrl, method: tMethod, parameters: tParameters, headers: tHeader).validate().responseJSON { [unowned self] (dataResponse) in
            var response = Response()

            response.afResponse = dataResponse
            response.response = dataResponse.response
            response.data = dataResponse.data
            response.metrics = dataResponse.metrics
            response.serializationDuration = dataResponse.serializationDuration
            switch dataResponse.result {
            case let .success(result):
                response.result = result
            case let .failure(error):
                response.error = error
            }
            task.response = response
            response.task = task
            
            if let index = tasks.firstIndex(of: task) {
                tasks.remove(at: index)
            }
            completionHandler(response)

        }
        task.afRequest = afRequest
        tasks.append(task)

    }
    
    /// 取消所有请求
    public func cancelAll()  {
        tasks = []
        sessionManager.cancelAllRequests()
    }
    
    /// 取消单个请求
    /// - Parameter request: 需要取消的请求
    public func cancel(_ request: Request) {
        var needRemoveTask: Task? = nil
        for task in tasks {
            if task.request == request {
                needRemoveTask = task
                break
            }
        }
        
        if let sessionTask =  needRemoveTask{
            if let index = tasks.firstIndex(of: sessionTask) {
                sessionTask.afRequest?.cancel()
                tasks.remove(at: index)
            }
        }
    }
        
    private func method(_ method: Method) -> HTTPMethod {
        var m: HTTPMethod = .get
        switch method {
        case .connect:
            m = .connect
        case .delete:
            m = .delete
        case .get:
            m = .get
        case .head:
            m = .head
        case .options:
            m = .options
        case .patch:
            m = .patch
        case .post:
            m = .post
        case .put:
            m = .put
        case .trace:
            m = .trace
        }
        return m
    }
}
