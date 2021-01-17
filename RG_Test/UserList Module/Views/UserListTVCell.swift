//
//  UserListTVCell.swift
//  RG_Test
//
//  Created by Sushobhit.Jain on 17/01/21.
//

import UIKit
import SDWebImage

class UserListTVCell: UITableViewCell {
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var subTitleL: UILabel!
    static let identifier = "UserListTVCell"
    static let nibName = "UserListTVCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpView() {
        self.imageV?.layer.cornerRadius = (self.imageV?.bounds.height ?? 1.0)/2.0
        self.imageV?.layer.masksToBounds = true
    }
   
    func setData(data:Any? = nil) {
        if let userData = data as? UserResponseModel {
            if let imgUrl = URL(string: userData.avatar) {
                self.imageV?.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "userPlaceholder"))
                self.imageV?.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "userPlaceholder"), options: .continueInBackground, completed: { [weak self](image, error, cache, url) in
                    self?.imageV?.image = image
                    self?.setUpView()
                })
            }
            self.titleL.text = "\(userData.firstName) \(userData.lastName)"
            self.subTitleL.text = userData.email
        }
    }
    
}
