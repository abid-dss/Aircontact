//
//  UserTableViewCell.swift
//  AirContact
//
//  Created by MacBook on 13/11/2018.
//  Copyright © 2018 abc. All rights reserved.
//

import UIKit



protocol shareCellDelegate: class {
    func shareButton(_ sender: UIButton)
}


class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
     weak var delegate: shareCellDelegate?
    
    @IBAction func onClickShare(_ sender: Any) {
        delegate?.shareButton(sender as! UIButton)
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
