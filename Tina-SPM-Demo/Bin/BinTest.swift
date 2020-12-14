//
//  BinTest.swift
//  Tina-Demo
//
//  Created by 罗树新 on 2020/12/14.
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
