//
//  File.swift
//  FileManager
//
//  Created by Master on 2022/6/4.
//

import Foundation

class File {
    var id: String
    var parentId: String
    var type: String // f: file, d: directory
    var name: String
    
    init(id: String, parentId: String, type: String, name: String) {
        self.id = id
        self.parentId = parentId
        self.type = type
        self.name = name
    }
    
    var isDirectory: Bool {
        return self.type == "d"
    }
}

extension File: Equatable {
    static func == (lhs: File, rhs: File) -> Bool {
        return lhs.id == rhs.id
    }
}

extension File: Comparable {
    static func < (lhs: File, rhs: File) -> Bool {
        return (lhs.isDirectory ? 0 : 1) < (rhs.isDirectory ? 0 : 1) || (lhs.isDirectory == rhs.isDirectory && lhs.name < rhs.name)
    }
}
