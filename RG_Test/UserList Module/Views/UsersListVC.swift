//
//  ViewController.swift
//  RG_Test
//
//  Created by Sushobhit.Jain on 17/01/21.
//

import UIKit

class UsersListVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel = UserListVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.viewModel.initalSetup()
        self.updateUI()
    }
    
    func setUpView() {
        self.collectionView.register(UINib(nibName: UserListCVCell.nibName, bundle: nil), forCellWithReuseIdentifier: UserListCVCell.identifier)
        self.tableView.register(UINib(nibName: UserListTVCell.nibName, bundle: nil), forCellReuseIdentifier:  UserListTVCell.identifier)
        self.tableView.tableFooterView = UIView()
        self.searchBar.placeholder = "Search"
        self.searchBar.delegate = self
    }
    
    func updateUI() {
        self.viewModel.animateLoader = { isShow in
            DispatchQueue.main.async {
                if isShow {
                    showProgressIndicator(view: self.view)
                } else {
                    hideProgressIndicator(view: self.view)
                }
            }
        }
        self.viewModel.successAPI = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
        }
        
        self.viewModel.showAlert = { title, error in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension UsersListVC :UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListTVCell.identifier) as? UserListTVCell
        if self.viewModel.filteredData.count > indexPath.item {
            cell?.setData(data: self.viewModel.filteredData[indexPath.item])
        }
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == self.viewModel.tableDataList.count-1 {
            self.viewModel.updateTableData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension UsersListVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.collectionDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserListCVCell.identifier, for: indexPath) as? UserListCVCell
        if self.viewModel.collectionDataList.count > indexPath.item {
            cell?.setData(data: self.viewModel.collectionDataList[indexPath.item])
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.viewModel.collectionDataList.count-1 {
            self.viewModel.updateCollectionData()
        }
    }
}

extension UsersListVC :UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 110)
    }
}

extension UsersListVC:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.filteredData = searchText.isEmpty ? self.viewModel.tableDataList : self.viewModel.tableDataList.filter({(dataModel: UserResponseModel) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return dataModel.firstName.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
}
