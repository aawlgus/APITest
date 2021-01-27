//
//  Model.swift
//  MyTranslate
//
//  Created by 정지현 on 2021/01/27.
//

import Foundation

struct Translated: Codable {
    //let translatedText: [TranslatedText]?
    let translatedText: [[String]]?
}

struct TranslatedText: Codable {
    let objectText: [Line]?
}

struct Line: Codable {
    let textLine: String?
}

enum CodingKeys: String, CodingKey {
    case translatedText = "translated_text"
}

/*
 { (Translated)
    translated_text (translatedText): [
        [ "Kakaka" ] (TranslatedText)
        [ "Kakao Talk" ]
    ]
 }
 
 
 */
