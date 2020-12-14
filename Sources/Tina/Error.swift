//
//  TinaError.swift
//  Tina
//
//  Created by 罗树新 on 2020/10/3.
//

import Foundation

struct Tina {
    enum RequestError: Error {
        case hostEmptyError(Requestable)
        case requestEmptyError
    }
    
    enum ResponseError: Error {

    }
}
