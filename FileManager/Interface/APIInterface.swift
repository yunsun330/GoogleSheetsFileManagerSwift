//
//  APIInterface.swift
//  FileManager
//
//  Created by Master on 2022/6/4.
//

import Foundation
import Alamofire

class APIInterface {
    static let shared: APIInterface = APIInterface()

    func getAllFiles(completion: @escaping([File]?, Error?) -> Void) {
        assert(!Constants.kGoogleApiKey.isEmpty)
        
        let url = URL(string: Constants.kBaseURL + "/spreadsheets/\(Constants.kGoogleSheetId)/values/Sheet1!A:D?key=\(Constants.kGoogleApiKey)")!
        AF.request(url,
                   method: .get)
            .responseDecodable(of: SpreadSheetValues.self) { response in
                switch response.result {
                case .success(let value):
                    completion(value.parseFiles(), nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
