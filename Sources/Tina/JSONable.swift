//
//  JSONable.swift
//  RRCNetwork
//
//  Created by 罗树新 on 2020/10/2.
//

import Foundation

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
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(Self.self, from: data)
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
