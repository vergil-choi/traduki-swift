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
    
    lazy var config:[String: Any] = {
        return self.loadFile("traduki")
    }()
    
    var cache: Translation = [:]
    var lang = Locale.current.languageCode ?? "en_US"
    var directory = "Languages"
    
    private override init() {
        super.init()
    }
    
    func translate(key: String, lang: String?, params: [String: String]) -> String {
        let dict = loadLang(lang ?? self.lang)
        if let string = getValue(dict: dict, dotkey: key) {
            return replace(trans: string, params: params)
        } else if let languages = config["languages"] as? [String], let fallback = languages.first {
            let dict = loadLang(fallback)
            if let string = getValue(dict: dict, dotkey: key) {
                return replace(trans: string, params: params)
            }
        }
        return key
    }
    
    private func loadLang(_ lang: String) -> Translation {
        
        if let value = cache[lang] {
            return value as! Translation
        }
        
        let trans = loadFile(lang)
        cache[lang] = trans
        return trans
    }
    
    private func loadFile(_ name: String) -> [String: Any] {
        
        if let fileURL = Bundle.main.url(forResource: name, withExtension: "json", subdirectory: directory) {
            if let data = try? Data.init(contentsOf: fileURL) {
                if let value = try? JSONSerialization.jsonObject(with: data, options: []) {
                    
                    return value as! [String : Any]
                }
            }
        }
        
        return [:]
    }
    
    private func getValue(dict: Translation, dotkey: String) -> String? {
        if dict.count == 0 {
            return nil
        }
        let keys = dotkey.components(separatedBy: ".")
        if let value = getValue(dict: dict, keys: keys) {
            return value
        }
        return nil
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
        if let value = dict[keys.first!] as? Translation {
            return getValue(dict: value, keys: Array(keys[1..<keys.count]))
        }
        return nil
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
