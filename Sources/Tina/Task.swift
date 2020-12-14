//
//  Tasj.swift
//  Tina
//
//  Created by 罗树新 on 2020/10/8.
//

import Foundation

public class Task: Equatable {
    
    init(request: Request) {
        self.request = request
        request.task = self
    }
    
    public var request: Request
    public var response: Response?
    public var completion: CompletionClosure?
}
public extension Task {
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.request == rhs.request
    }
}


extension Task {
    
    @discardableResult
    public func fetch() -> Request {
        
        if let handlers = request.requestHandlers {
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
        
        
        request.session?.execute(self) { (response) in
            self.handle(response)
        }

        return request
    }
    
    
    func url() -> String {
        var url = "https://\(request.host)"                            // url -> https://www.example.com
        if let tPath = request.path {
            url.append("/\(tPath)")
        }
        if let tQuery = request.queryParameters {
            let queryString = tQuery.queryFormatted()
            url.append("?\(queryString)")
        }
        return url
    }
    
    func parameters() -> Parameters? {
        var parameters: Parameters?
        switch request.method {
        case .get, .delete, .head:
            parameters = request.queryParameters
        case .connect, .put, .post, .patch, .options, .trace:
            parameters = request.bodyParameters
        }
        return parameters
    }
    
    private func handle(_ response: Response) {
        var res = response
        res.task = self
        if let handlers = request.responseHandlers {
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
            
            
            completion?(res)
        }
    }

}
