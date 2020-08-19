//
//  ScanSever.swift
//  Boyaios
//
//  Created by huasen on 2020/2/27.
//  Copyright © 2020 yind. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
enum ScanServer {
    case fetchData
}

extension ScanServer:TargetType{
    var baseURL: URL {
        return URL(string: scanServerBase)!
    }
    
    var path: String {
        switch self {
        case .fetchData:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchData:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var headers: [String : String]?{
        switch self {
        case .fetchData:
            return ["Content-type" : "application/x-www-form-urlencoded"]
        }
    }
    
    var parameters: [String: Any]? {
        let paramsDict: [String : Any] = [:]
        return paramsDict
    }
    
    var task: Task {
        print("path:\(self.path),params:\(parameters ?? [:])")
        switch self {
        case .fetchData:
            return .requestParameters(parameters: parameters ?? [:], encoding: URLEncoding.default)
        }
    }
}
