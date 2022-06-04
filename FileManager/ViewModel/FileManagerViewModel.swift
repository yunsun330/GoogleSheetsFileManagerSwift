//
//  ViewModel.swift
//  FileManager
//
//  Created by Master on 2022/6/4.
//

import Foundation

protocol FileManagerViewModelDelegate: AnyObject {
    func showLoadingActivity(show: Bool)
    func reloadUI()
    
    func didGetError(error: Error)
}

class FileManagerViewModel {
    private var allFiles: [File] = []
    private var files: [File] = []
    private var currentDirectory: File? = nil
    
    private var delegate: FileManagerViewModelDelegate?
    
    func initialize(delegate: FileManagerViewModelDelegate?) {
        self.delegate = delegate
    }
    
    func setCurrentDirectory(directory: File?) {
        self.currentDirectory = directory
        self.files = self.getChildFiles(directory: directory)

        self.delegate?.reloadUI()
    }
    
    func canGoBack() -> Bool {
        return self.currentDirectory != nil
    }
    
    func goBack() {
        self.currentDirectory = self.getParentDirectory()
        self.files = self.getChildFiles(directory: self.currentDirectory)

        self.delegate?.reloadUI()
    }
    
    func numberOfRows() -> Int {
        return self.files.count
    }
    
    func fileForIndex(index: Int) -> File? {
        if self.files.count > index {
            return self.files[index]
        }
        return nil
    }
    
    func hasDuplicatedFileName(name: String) -> Bool {
        for file in self.files {
            if file.name.lowercased() == name.lowercased() {
                return true
            }
        }
        return false
    }

    
    func loadFiles() {
        self.delegate?.showLoadingActivity(show: true)
        
        APIInterface.shared.getAllFiles { files, error in
            self.delegate?.showLoadingActivity(show: false)
            
            if let files = files {
                self.allFiles = files
                self.setCurrentDirectory(directory: nil)
            } else if let error = error {
                self.delegate?.didGetError(error: error)
            }
        }
    }
    
    func createDirectory(name: String) {

    }

    func createFile(name: String) {

    }

    private func getParentDirectory() -> File? {
        if let currentDirectory = currentDirectory {
            return self.allFiles.first(where: { file in
                return file.id == currentDirectory.parentId
            })
        }
        return nil
    }
    
    private func getChildFiles(directory: File?) -> [File] {
        return self.allFiles.filter { file in
            return file.parentId == directory?.id ?? ""
        }.sorted()
    }
}
