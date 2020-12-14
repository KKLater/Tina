//
//  Session.swift
//  Tina
//
//  Created by 罗树新 on 2020/10/3.
//

import Foundation
import Alamofire

public protocol Sessionable {
    /// 服务器域名地址
    ///
    /// 请求的服务器域名地址
    ///
    /// - returns: 配置所有请求的请求域名地址
    ///
    /// - Note: 此处配置请求的域名地址，Network 发起请求时，域名全部为该处配置的域名；不同域名的请求，可以由不同的 Network 实例操作
    ///
    static func host() -> String?
    
    /// 请求适配器响应链
    static func requestHandlers() -> [RequestHandleable]
    
    /// 请求结果适配器响应链
    static func responseHandlers() -> [ResponseHandleable]
}

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

        let afRequest = sessionManager.request(tUrl, method: tMethod, parameters: tParameters, headers: tHeader).responseJSON { [unowned self] (dataResponse) in
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
        task.request.afRequest = afRequest
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
                sessionTask.request.afRequest?.cancel()
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
