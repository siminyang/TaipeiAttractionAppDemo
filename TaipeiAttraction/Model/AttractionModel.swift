//
//  AttractionModel.swift
//  TaipeiAttraction
//
//  Created by Nicky Y on 2024/12/27.
//

import Foundation

// MARK: - Welcome
struct AttractionWelcome: Codable {
    let total: Int
    let data: [AttractionData]
}

// MARK: - Datum
struct AttractionData: Codable {
    let id: Int
    let name: String
    let nameZh: String?
    let openStatus: Int
    let introduction: String
    let openTime: String?
    let zipcode: String
    let distric: String
    let address: String
    let tel: String
    let fax: String?
    let email: String?
    let months: String
    let nlat: Double
    let elong: Double
    let officialSite: String
    let facebook: String
    let ticket: String?
    let remind: String?
    let staytime: String?
    let modified: String
    let url: String
    let category: [Category]
    let target: [Category]
    let service: [Category]
    let friendly: [Category]
    let images: [Image]
    let files: [File]
    let links: [Link]

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameZh = "name_zh"
        case openStatus = "open_status"
        case introduction
        case openTime = "open_time"
        case zipcode, distric, address, tel, fax, email, months, nlat, elong
        case officialSite = "official_site"
        case facebook, ticket, remind, staytime, modified, url, category, target, service, friendly, images, files, links
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name: String?
}

// MARK: - Image
struct Image: Codable {
    let src: String?
    let subject: String?
    let ext: String?
}
