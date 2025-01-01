//
//  EventViewModel.swift
//  TaipeiAttraction
//
//  Created by Nicky Y on 2024/12/27.
//

import Foundation
import Alamofire

class EventViewModel {
    @Published var events: [EventData] = []
    @Published var error: Error?

    func fetchEvent(language: String) {
        let baseURL = "https://www.travel.taipei/open-api"
//        let lang = "zh-tw"
        let endPoint = "Events/News"

        var components = URLComponents(string: baseURL)
        components?.path += "/\(language)/\(endPoint)"

        guard let url = components?.url else { return }

        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]

        AF.request(url, headers: headers, requestModifier: { $0.timeoutInterval = 20 })
            .validate()
            .responseDecodable(of: EventWelcome.self) { [weak self] response in
            switch response.result {
            case .success(let events):
                print(response.result)
                self?.events = events.data
            case .failure(let error):
                print("景點解析失敗 \(error)")
                self?.error = error
            }
        }
    }
}
