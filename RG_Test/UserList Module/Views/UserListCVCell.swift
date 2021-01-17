//
//  UserListCVCell.swift
//  RG_Test
//
//  Created by Sushobhit.Jain on 17/01/21.
//

import UIKit
import SDWebImage

class UserListCVCell: UICollectionViewCell {
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    
    static let identifier = "UserListCVCell"
    static let nibName = "UserListCVCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpView() {
        self.imageV?.layer.borderWidth = 2
        self.imageV?.layer.borderColor = UIColor(red: 80/255, green: 150/255, blue: 247/255, alpha: 1).cgColor
        self.imageV?.layer.cornerRadius = (self.imageV?.frame.height ?? 1.0)/2.0
        self.imageV?.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        self.setUpView()
    }
    
    func setData(data:Any? = nil) {
        if let userData = data as? UserResponseModel {
            if let imgUrl = URL(string: userData.avatar) {
                self.imageV?.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "userPlaceholder"))
                self.layoutIfNeeded()
            }
            self.nameL.text = "\(userData.firstName)"
        }
    }

    

}
