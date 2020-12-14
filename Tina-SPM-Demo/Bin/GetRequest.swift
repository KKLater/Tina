//
//  Get.swift
//  Tina-Demo
//
//  Created by 罗树新 on 2020/12/14.
//

import Foundation
import Tina

class GetRequest: Getable, Binable {
    var foo: String?
    init(foo: String?) {
        self.foo = foo
    }
    
    var path: String? { "get" }
}

