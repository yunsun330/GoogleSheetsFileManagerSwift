//
//  ViewController.swift
//  FileManager
//
//  Created by Master on 2022/6/4.
//

import UIKit

class FileManagerViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var waitingView: UIView!
    
    @IBOutlet private var newFileBarButton: UIBarButtonItem!
    @IBOutlet private var newDirectoryBarButton: UIBarButtonItem!
    @IBOutlet private var arrangeListBarButton: UIBarButtonItem!
    @IBOutlet private var arrangeTilesBarButton: UIBarButtonItem!
    
    private enum FilesViewModel {
        case list
        case tiles
    }
    private var filesViewMode: FilesViewModel = .list
    private let viewModel = FileManagerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.viewModel.initialize(delegate: self)
        self.viewModel.loadFiles()
    }
}

extension FileManagerViewController {
    @IBAction func onNewFile(_ sender: Any) {
        self.showNewFileDialog(initialName: "")
    }
    
    @IBAction func onNewDirectory(_ sender: Any) {
        self.showNewDirectoryDialog(initialName: "")
    }
    
    @IBAction func onViewModeList(_ sender: Any) {
        self.filesViewMode = .tiles
        
        self.tableView.isHidden = true
        self.collectionView.isHidden = false
        self.navigationItem.setRightBarButtonItems([arrangeTilesBarButton, newDirectoryBarButton, newFileBarButton], animated: true)
    }
    
    @IBAction func onViewModeTiles(_ sender: Any) {
        self.filesViewMode = .tiles
        
        self.tableView.isHidden = false
        self.collectionView.isHidden = true
        self.navigationItem.setRightBarButtonItems([arrangeListBarButton, newDirectoryBarButton, newFileBarButton], animated: true)
    }
}

extension FileManagerViewController {
    private func showNewDirectoryDialog(initialName: String) {
        let alert = UIAlertController(title: "New Directory", message: "Input the name of new directory.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = initialName
        }
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            let name = alert.textFields?.first?.text ?? ""
            if name.isEmpty {
                self.showNewDirectoryDialog(initialName: "")
            } else {
                if self.viewModel.hasDuplicatedFileName(name: name) {
                    self.showAlertDialog(title: "Error", message: "The name already exists. Please try with another name.", buttonTitle: "OK") {
                        self.showNewDirectoryDialog(initialName: name)
                    }
                } else {
                    self.viewModel.createDirectory(name: name)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNewFileDialog(initialName: String) {
        let alert = UIAlertController(title: "New File", message: "Input the name of new file.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = initialName
        }
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            let name = alert.textFields?.first?.text ?? ""
            if name.isEmpty {
                self.showNewFileDialog(initialName: "")
            } else {
                if self.viewModel.hasDuplicatedFileName(name: name) {
                    self.showAlertDialog(title: "Error", message: "The name already exists. Please try with another name.", buttonTitle: "OK") {
                        self.showNewFileDialog(initialName: name)
                    }
                } else {
                    self.viewModel.createFile(name: name)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    private func showAlertDialog(title: String, message: String, buttonTitle: String, handler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
            handler?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension FileManagerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.viewModel.canGoBack() ? 1 : 0) + self.viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var index: Int = indexPath.row
        
        if self.viewModel.canGoBack() {
            if index == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FileTableViewCell") as! FileTableViewCell
                cell.file = nil
                return cell
            }
            index -= 1
        }
        
        if let file = self.viewModel.fileForIndex(index: index) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FileTableViewCell") as! FileTableViewCell
            cell.file = file
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var index: Int = indexPath.row
        if self.viewModel.canGoBack() {
            if index == 0 {
                self.viewModel.goBack()
                return
            }
            
            index -= 1
        }
        
        if let file = self.viewModel.fileForIndex(index: index) {
           if file.isDirectory {
               // Open Directory
               self.viewModel.setCurrentDirectory(directory: file)
           } else {
               // Open File
           }
        }
    }
}

extension FileManagerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.viewModel.canGoBack() ? 1 : 0) + self.viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var index: Int = indexPath.row
        
        if self.viewModel.canGoBack() {
            if index == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCollectionViewCell", for: indexPath) as! FileCollectionViewCell
                cell.file = nil
                return cell
            }
            index -= 1
        }
        
        if let file = self.viewModel.fileForIndex(index: index) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCollectionViewCell", for: indexPath) as! FileCollectionViewCell
            cell.file = file
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        var index: Int = indexPath.row
        if self.viewModel.canGoBack() {
            if index == 0 {
                self.viewModel.goBack()
                return
            }
            
            index -= 1
        }
        
        if let file = self.viewModel.fileForIndex(index: index) {
           if file.isDirectory {
               // Open Directory
               self.viewModel.setCurrentDirectory(directory: file)
           } else {
               // Open File
           }
        }
    }
}

extension FileManagerViewController: FileManagerViewModelDelegate {
    func showLoadingActivity(show: Bool) {
        self.waitingView.isHidden = !show
    }
    
    func reloadUI() {
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
    func didGetError(error: Error) {
        self.showAlertDialog(title: "Error", message: error.localizedDescription, buttonTitle: "Reload") {
            self.viewModel.loadFiles()
        }
    }
}
