//
//  FileCollectionViewCell.swift
//  FileManager
//
//  Created by Master on 2022/6/4.
//

import UIKit

class FileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    var file: File? {
        didSet {
            if let file = file {
                self.nameLabel.text = file.name
                self.imageView.image = UIImage(systemName: file.isDirectory ? "folder" : "doc.richtext")
            } else {
                self.nameLabel.text = ".."
                self.imageView.image = UIImage(systemName: "folder")
            }
        }
    }
}
