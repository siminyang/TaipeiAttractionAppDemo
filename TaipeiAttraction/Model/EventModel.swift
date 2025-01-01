//
//  EventModel.swift
//  TaipeiAttraction
//
//  Created by Nicky Y on 2024/12/27.
//

import Foundation

// MARK: - Welcome
struct EventWelcome: Codable {
    let total: Int
    let data: [EventData]
}

// MARK: - Datum
struct EventData: Codable {
    let id: Int
    let title: String
    let description: String
    let begin: String? // null
    let end: String? // null
    let posted: String // 時間
    let modified: String // 時間
    let url: String
    let files: [File]
    let links: [Link]
}

// MARK: - File
struct File: Codable {
    let src: String? // 網址
    let subject: String?
    let ext: String? // 檔案格式
}

// MARK: - Link
struct Link: Codable {
    let src: String?
    let subject: String?
}
