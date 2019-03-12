//
//  NoteModel.swift
//  KNotes
//
//  Created by Ky Nguyen on 3/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

final class KNote {
    var id: String
    var rawText: String? { didSet {
        title = getTitle()
        firstLine = getFirstLine()
    }}

    var jsonText: String?
    var title: String?
    var firstLine: String?
    var timestamp: Double = 0

    init(rawText: String? = nil, jsonText: String? = nil) {
        id = UUID.init().uuidString
        self.rawText = rawText
        self.jsonText = jsonText
        title = getTitle()
        firstLine = getFirstLine()
        timestamp = Date().timeIntervalSince1970
    }

    init(rawData: AnyObject) {
        id = rawData["id"] as? String ?? ""
        rawText = rawData["rawText"] as? String
        jsonText = rawData["jsonText"] as? String
        title = rawData["title"] as? String
        firstLine = rawData["firstLine"] as? String
        timestamp = rawData["timestamp"] as? Double ?? 0
    }

    func toDict() -> [String: Any] {
        var dict = [String: Any]()
        dict["id"] = id

        if let data = title {
            dict["title"] = data
        }

        if let data = rawText {
            dict["rawText"] = data
        }

        if let data = jsonText {
            dict["jsonText"] = data
        }

        if let data = firstLine {
            dict["firstLine"] = data
        }

        dict["timestamp"] = timestamp
        return dict
    }

    private func getTitle() -> String? {
        let sentences = getSentences()
        return sentences.first
    }

    private func getSentences() -> [String] {
        let newText = rawText?.replace("\n", with: ".")
        let sentences = newText?.splitString(".") ?? []
        return sentences
    }

    private func getFirstLine() -> String? {
        let sentences = getSentences()
        return sentences.count < 2 ? nil : sentences[1]
    }
}
