//
//  FileTableViewCell.swift
//  FileManager
//
//  Created by Master on 2022/6/4.
//

import UIKit

class FileTableViewCell: UITableViewCell {
    
    var file: File? {
        didSet {
            if let file = file {
                self.textLabel?.text = file.name
                self.imageView?.image = UIImage(systemName: file.isDirectory ? "folder" : "doc.richtext")
                self.accessoryType = file.isDirectory ? .disclosureIndicator : .none
            } else {
                self.textLabel?.text = ".."
                self.imageView?.image = UIImage(systemName: "folder")
                self.accessoryType = .disclosureIndicator
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
