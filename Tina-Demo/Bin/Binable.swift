//
//  Binable.swift
//  Tina-Demo
//
//  Created by 罗树新 on 2020/12/14.
//

import Foundation
import Tina

protocol Binable: Sessionable {}

extension Binable {
    static func host() -> String? {
        return "httpbin.org"
    }
    
    static func requestHandlers() -> [RequestHandleable] {
        return []
    }
    
    static func responseHandlers() -> [ResponseHandleable] {
        return []
    }
}
