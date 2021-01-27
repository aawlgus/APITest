//
//  Model.swift
//  MyTranslate
//
//  Created by 정지현 on 2021/01/27.
//

import Foundation

struct Translated: Codable {
    let translatedText: [[String]]?
    
    enum CodingKeys: String, CodingKey {
        case translatedText = "translated_text"
    }
}

