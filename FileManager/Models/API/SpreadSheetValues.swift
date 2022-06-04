//
//  SpreadSheet.swift
//  FileManager
//
//  Created by Master on 2022/6/4.
//

import Foundation

struct SpreadSheetValues: Decodable {
    let range: String
    let majorDimension: String
    let values: [[String]]
    
    enum CodingKeys: String, CodingKey {
        case range
        case majorDimension
        case values
    }
    
    func parseFiles() -> [File] {
        var files: [File] = []
        
        for row in self.values {
            if row.count != 4 {
                continue
            }
        
            let id = row[0]
            let parentId = row[1]
            let type = row[2]
            let name = row[3]
            
            files.append(File(id: id, parentId: parentId, type: type, name: name))
        }
        
        return files
    }
}
