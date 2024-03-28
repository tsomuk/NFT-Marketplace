//
//  StatisticService.swift
//  FakeNFT
//
//  Created by mihail on 27.03.2024.
//

import Foundation

protocol StatisticService {
    func fetchUsersNextPage()
}

final class StatisticServiceImpl: StatisticService {
    static let didChangeNotification = Notification.Name(rawValue: "StatisticServiceDidChange")
    private  let usersRequest = UsersRequest(id: "users")
    private  let session = URLSession.shared

    private var lastLoadedPage: Int? = nil
    private var prevTask: URLSessionTask?
    private(set) var users = [User]()
    
    func fetchUsersNextPage() {
        guard prevTask == nil else {
            return
        }
        let nextPage = lastLoadedPage == nil ? 0 : lastLoadedPage! + 1
        lastLoadedPage = nextPage
        
        guard let urlUsersRequest = usersRequest.endpoint,
              var components = URLComponents(url: urlUsersRequest, resolvingAgainstBaseURL: true)
        else { return }
        
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)"),
            URLQueryItem(name: "size", value: "15")
        ]
        
        guard let url = components.url else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("b351241e-2dec-4598-9abd-083d84e52843", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        prevTask?.cancel()
        
        prevTask = URLSession.shared.objectTask(for: urlRequest) { (result: Result<[User], Error>) in
            defer {
                self.prevTask = nil
            }
            
            switch result {
            case .success(let users):
                if !users.isEmpty {
                    self.users += users
                    NotificationCenter.default.post(name: StatisticServiceImpl.didChangeNotification,
                                                    object: self,
                                                    userInfo: nil)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        prevTask?.resume()
    }
}

