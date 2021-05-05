//
//  Tasj.swift
//  Tina
//
//  Created by 罗树新 on 2020/10/8.
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

public class Task: Equatable {
    
    public var requestHandlers: [RequestHandleable]?
    public var responseHandlers: [ResponseHandleable]?
    
    
    init(context: Requestable) {
        self.requestContext = context
    }
    public var requestContext: Requestable?
    public var request: Request = Request(host: "")
    public var response: Response?
    public var completion: CompletionClosure?
    
    public var urlRequest: URLRequest?
    public var afRequest: Alamofire.Request?
}
public extension Task {
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.request == rhs.request
    }
}


extension Task {
    
    @discardableResult
    public func fetch() -> Request? {
        
        guard let rq = requestContext?.configRequest() else {
            print("Config Request fialed")
            return nil
        }
        
        request = rq
        request.task = self
        requestHandlers = requestContext?.requestHandlers
        responseHandlers = requestContext?.responseHandlers
        
        
        if let handlers = requestHandlers {
            var con = true
            var error: Error?
            for handler in handlers {
                if let callBack = handler.handle(request) {
                    con = callBack.continue
                    error = callBack.error
                }
                if con == false {
                    var response = Response()
                    response.error = error
                    self.response = response
                    completion?(response)
                    return request
                }
            }
        }
        
        
        Session.shared.execute(self) { (response) in
            self.handle(response)
        }

        return request
    }
    
    
    func url() -> String {
        var url = "https://\(request.host)"                            // url -> https://www.example.com
        if let tPath = request.path {
            url.append("/\(tPath)")
        }
        return url
    }
    
    func parameters() -> Parameters? {
        return request.parameters
    }
    
    private func handle(_ response: Response) {
        var res = response
        res.task = self
        if let handlers = responseHandlers {
            var con = true
            var error: Error?
            for handle in handlers {
                if let callBack = handle.handle(res) {
                    con = callBack.continue
                    error = callBack.error
                }
        
                if con == false {
                    if let error = error {
                        res.error = error
                        completion?(res)
                    }
                    break
                }
            }
            
            if con == true {
                completion?(res)
            }
        }
    }

}
