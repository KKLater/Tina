//
//  BinTest.swift
//  Tina-Demo
//
//  Created by 罗树新 on 2020/12/14.
//

import Foundation

struct Bin {
    
    func startTest() {
        getTest()
        postTest()
        headTest()
    }
    
    func getTest() {
        let get = GetRequest(foo: "bar")
        get.get { (response) in
            guard let result = response.result else {
                if let err = response.error {
                    print("Get: error =\(err)")
                }
                return
            }
            print("Get: result =\(result)")
        }
    }

    func postTest() {
        let post = PostRequest()
        post.post { (response) in
            guard let result = response.result else {
                if let err = response.error {
                    print("Post: error =\(err)")
                }
                return
            }
            print("Post: result =\(result)")
        }
    }
    
    func headTest() {
        let head = HeadRequest()
        head.head { (response) in
            guard let result = response.result else {
                if let err = response.error {
                    print("Head: error =\(err)")
                }
                return
            }
            print("Head: result =\(result)")
        }
    }
}
