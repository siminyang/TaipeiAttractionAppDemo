//
//  AttractionViewModel.swift
//  TaipeiAttraction
//
//  Created by Nicky Y on 2024/12/27.
//

import Foundation
import Alamofire

class AttractionViewModel {
    @Published var attractions: [AttractionData] = []
    @Published var error: Error?

    func fetchAttractions(language: String) {
        let baseURL = "https://www.travel.taipei/open-api"
//        let lang = "zh-tw"
        let endPoint = "Attractions/All"

        var components = URLComponents(string: baseURL)
        components?.path += "/\(language)/\(endPoint)"

        guard let url = components?.url else { return }

        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]

        AF.request(url, headers: headers, requestModifier: { $0.timeoutInterval = 20 })
            .validate()
            .responseDecodable(of: AttractionWelcome.self) { [weak self] response in
            switch response.result {
            case .success(let attractions):
                print(response.result)
                self?.attractions = attractions.data
            case .failure(let error):
                print("景點解析失敗 \(error)")
                self?.error = error
            }
        }
    }
}
