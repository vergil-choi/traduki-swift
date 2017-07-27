//
//  Traduki.swift
//  Traduki
//
//  Created by Vergil Choi on 2017/7/25.
//  Copyright © 2017年 Vergil Choi. All rights reserved.
//

import UIKit

typealias Translation = [String: Any]

class Traduki: NSObject {
    
    static let sharedInstance = Traduki()
    
    let configFileURL = Bundle.main.url(forResource: "traduki", withExtension: "json")
    var cache: Translation = [:]
    var lang = Locale.current.languageCode ?? "en_US"
    
    private override init() {
        super.init()
    }
    
    func translate(key: String, lang: String?, params: [String: String]) -> String {
        let dict = loadFile(lang ?? self.lang)
        let string = getValue(dict: dict, dotkey: key)
        return replace(trans: string, params: params)
    }
    
    private func loadFile(_ lang: String) -> Translation {
        
        if let value = cache[lang] {
            return value as! Translation
        }
        
        if let fileURL = Bundle.main.url(forResource: lang, withExtension: "json", subdirectory: "Languages") {
            if let data = try? Data.init(contentsOf: fileURL) {
                if let value = try? JSONSerialization.jsonObject(with: data, options: []) {
                    cache[lang] = value
                    return value as! [String : Any]
                }
            }
        }
        
        return [:]
    }
    
    private func getValue(dict: Translation, dotkey: String) -> String {
        if dict.count == 0 {
            return dotkey
        }
        if let value = getValue(dict: dict, keys: dotkey.components(separatedBy: ".")) {
            return value
        }
        return dotkey
    }
    
    private func getValue(dict: Translation, keys: [String]) -> String? {
        if keys.count == 1 {
            if let value = dict[keys.first!] {
                if let trans = value as? String {
                    return trans
                } else if let inner = value as? Translation {
                    return inner["_"] as? String
                } else {
                    return nil
                }
            }
        }
        return getValue(dict: dict[keys.first!] as! Translation, keys: Array(keys[1..<keys.count]))
    }
    
    private func replace(trans: String, params: [String: String]) -> String {
        var new = String(trans)!
        for (key, value) in params {
            new = new.replacingOccurrences(of: "{" + key + "}", with: value)
        }
        return new
    }
}

func __(_ key: String, _ desc: String = "", _ params: [String: String] = [:]) -> String {
    return Traduki.sharedInstance.translate(key: key, lang: nil, params: params)
}
