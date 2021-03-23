//
//  Request.swift
//  RRCNetwork
//
//  Created by 罗树新 on 2020/10/2.
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

public protocol Requestable: JSONable {
    
    /// 请求域名
    var host: String? { get }
    
    /// 请求路径
    var path: String? { get }
    
    /// 请求方法
    var method: Method { get }
    
    /// 请求header信息
    var header: Header? { get }
        
    /// 请求响应链
    var requestHandlers: [RequestHandleable]? { get }
    
    /// 请求结果处理响应链
    var responseHandlers: [ResponseHandleable]? { get }

    /// 请求发起前的校验
    func validate() -> Error?
    
    /// 配置请求
    func configRequest() -> Request?
    
}

public extension Requestable {
    
    var host: String? { nil }
    var path: String? { nil }
    var method: Method { .get }
    var header: Header? { nil }
    var requestHandlers: [RequestHandleable]? { nil }
    var responseHandlers: [ResponseHandleable]? { nil }
    

    
    func parameters() -> Parameters {
        if let dic = jsonDictionary() {
            return dic
        }
        return [:]
    }
    func configRequest() -> Request? {
        return nil
    }
}

public extension Requestable {
    func validate() -> Error? {
        guard let _ = host else {
            return Tina.RequestError.hostEmptyError(self)
        }
        return nil
    }
}



public extension Requestable where Self: Sessionable {
    func configRequest() -> Request? {
        guard let host = host ?? Self.host() else {
            return nil
        }
        
        /// request
        let request = Request(host: host)
        
        /// path
        request.path = path
        
        /// headers
        var headers: Headers = Headers()
        if let sHeader = header {
            headers.append(sHeader.headers())
        }
        request.headers = headers
        
        /// method
        request.method = method
        
        /// queryParameters
        /// bodyParameters
        switch method {
        case .get, .delete, .head:
            request.parameters = parameters()
            request.queryParameters = parameters()
        case .connect, .put, .post, .patch, .options, .trace:
            request.parameters = parameters()
            request.bodyParameters = parameters()
        }
    
        /// requestHandlers
        var allRequestHandlers = Self.requestHandlers()
        if let tHandlers = requestHandlers {
            allRequestHandlers += tHandlers
        }
        request.requestHandlers = allRequestHandlers
        
        /// responseHandlers
        var allResponseHandlers = Self.responseHandlers()
        if let tHandlers = responseHandlers {
            allResponseHandlers += tHandlers
        }
        request.responseHandlers = allResponseHandlers
        
        /// session
        request.session = Session.shared

        return request
    }
    
    func validate() -> Error? {
        guard let _ = host ?? Self.host() else {
            return Tina.RequestError.hostEmptyError(self)
        }
 
        return nil
    }
}

/// MARK - Requestable
public extension Requestable {
    func request(_ completion: @escaping CompletionClosure) -> Request? {
        
        /// check
        var response = Response()

        if let error = validate() {
            response.error = error
            completion(response)
            return nil
        }
  
        guard let request = configRequest() else {
            response.error = Tina.RequestError.requestEmptyError
            completion(response)
            return nil
        }
         
        let task = Task(request: request)
        task.completion = completion
        return task.fetch()        
    }
}

/// MARK - Getable
public protocol Getable: Requestable {
    func get(_ completion: @escaping CompletionClosure) -> Request?
}

public extension Getable {
    var method: Method {
        return .get
    }
    
    @discardableResult
    func get(_ completion: @escaping CompletionClosure) -> Request? {
        return request(completion)
    }
}

/// MARK - Postable
public protocol Postable: Requestable {
    func post(_ completion: @escaping CompletionClosure) -> Request?
}

public extension Postable {
    var method: Method {
        return .post
    }
    
    @discardableResult
    func post(_ completion: @escaping CompletionClosure) -> Request? {
        return request(completion)
    }
}

/// MARK - Deletable
public protocol Deletable: Requestable {
    func delete(_ completion: @escaping CompletionClosure) -> Request?
}

public extension Deletable {
    var method: Method {
        return .delete
    }
    
    @discardableResult
    func delete(_ completion: @escaping CompletionClosure) -> Request? {
        return request(completion)
    }
}

/// MARK - Headable
public protocol Headable: Requestable {
    func head(_ completion: @escaping CompletionClosure) -> Request?
}

public extension Headable {
    var method: Method {
        return .head
    }
    
    @discardableResult
    func head(_ completion: @escaping CompletionClosure) -> Request? {
        return request(completion)
    }
}

/// MARK - Connectable
public protocol Connectable: Requestable {
    func connect(_ completion: @escaping CompletionClosure) -> Request?
}

public extension Connectable {
    var method: Method {
        return .connect
    }
    
    @discardableResult
    func connect(_ completion: @escaping CompletionClosure) -> Request? {
        return request(completion)
    }
}

/// MARK - Putable
public protocol Putable: Requestable {
    func put(_ completion: @escaping CompletionClosure) -> Request?
}

public extension Putable {
    var method: Method {
        return .put
    }
    
    @discardableResult
    func put(_ completion: @escaping CompletionClosure) -> Request? {
        return request(completion)
    }
}

/// MARK - Patchable
public protocol Patchable: Requestable {
    func patch(_ completion: @escaping CompletionClosure) -> Request?
}

public extension Patchable {
    var method: Method {
        return .patch
    }
    
    @discardableResult
    func patch(_ completion: @escaping CompletionClosure) -> Request? {
        return request(completion)
    }
}

/// MARK - Optionsable
public protocol Optionsable: Requestable {
    func options(_ completion: @escaping CompletionClosure) -> Request?
}

public extension Optionsable {
    var method: Method {
        return .options
    }
    
    @discardableResult
    func options(_ completion: @escaping CompletionClosure) -> Request? {
        return request(completion)
    }
}

/// MARK - Traceable
public protocol Traceable: Requestable {
    func trace(_ completion: @escaping CompletionClosure) -> Request?
}

public extension Traceable {
    var method: Method {
        return .trace
    }
    
    @discardableResult
    func trace(_ completion: @escaping CompletionClosure) -> Request? {
        return request(completion)
    }
}

public typealias CompletionClosure =  (_ response: Response) -> Void

@objcMembers
@objc(TinaRequest)
open class Request: NSObject {
        
    init(host: String) {
        self.host = host
    }
    
    public var host: String
    public var path: String?
    public var parameters: Parameters?
    public var queryParameters: Parameters?
    public var bodyParameters: Parameters?
    public var method: Method = .get
    public var headers: Headers?
    
    public var requestHandlers: [RequestHandleable]?
    public var responseHandlers: [ResponseHandleable]?
    
    public var session: Session?
    
    public var request: URLRequest?
    public var afRequest: Alamofire.Request?
    
    public weak var task: Task?
}


extension Request {
    /// Returns a Boolean value indicating whether two values are equal.
    public static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.afRequest?.id == rhs.afRequest?.id
    }
}

public extension Request {
    func cancel() {
        Session.shared.cancel(self)
    }
}



