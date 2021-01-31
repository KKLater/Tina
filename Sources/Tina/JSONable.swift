//
//  JSONable.swift
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
import SmartCodable

public protocol JSONable: Codable {
    func jsonString() -> String?
    func jsonDictionary() -> [String: Any]?
    static func object(from json: Any?) -> Self?
}

public extension JSONable {
    
    /// 解析为jsonString
    /// - Returns: json string
    func jsonString() -> String? {
        let encode = JSONEncoder()
        encode.outputFormatting = .prettyPrinted
        guard let data = try? encode.encode(self) else {
            return nil
        }
        
        guard let jsonString = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return jsonString
    }
    
    /// 解析为 json dic
    /// - Returns: json dic
    func jsonDictionary() -> [String: Any]? {
        let encode = JSONEncoder()
        encode.outputFormatting = .prettyPrinted
        guard let data = try? encode.encode(self) else {
            return nil
        }
        
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String : Any] else {
            return nil
        }
        
        return dict
    }
    
    /// 将可以解析为 object 的json 解析为 object
    /// - Parameter json: 需要解析的json
    /// - Returns: 解析成功的object
    static func object(from json: Any?) -> Self? {
        guard let tJson = json, let data = getJsonData(with: tJson) else {
            print("\(Self.Type.self) Entity 转换失败")
            return nil
        }
        do {
            let model = try data.decoded() as Self
            return model
        } catch {
            print(error)
        }
    
        return nil
    }
    
    private static func getJsonData(with parameters: Any) -> Data? {
        if JSONSerialization.isValidJSONObject(parameters) == false {
            return nil
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return nil
        }
        
        return data
    }
}
