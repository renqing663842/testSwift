//
//  RequestUtils.swift
//  TestSwift
//
//  Created by 任卿 on 2020/8/18.
//  Copyright © 2020 任卿. All rights reserved.
//

import UIKit
import Moya

class RequestUtils: NSObject {
    func fetchData(suc:@escaping (_ resultStr:String)->Void){
        let provider = MoyaProvider<ScanServer>()
        provider.request(.fetchData) { result in
            switch result{
            case let .success(moyaResponse):
                let jsonMap = try? moyaResponse.mapJSON()
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    guard let dic = jsonMap as? [String : Any] else{
                        return
                    }
                    suc(String(format: "%@", dic))
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

