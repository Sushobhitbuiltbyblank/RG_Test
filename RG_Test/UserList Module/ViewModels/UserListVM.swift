//
//  UserListVM.swift
//  RG_Test
//
//  Created by Sushobhit.Jain on 17/01/21.
//

import Foundation

class UserListVM {
    
    var collectionDataList:[UserResponseModel] = []
    var tableDataList:[UserResponseModel] = []
    var animateLoader: ((Bool) -> Void)?
    var showAlert: ((String, String) -> Void)?
    var successAPI: (()->Void)?
    var collectionPage = 1
    var tablePage = 1
    var filteredData = [UserResponseModel]()
    
    func initalSetup() {
        self.callUserList(page: 1) { [weak self] (list) in
            self?.tableDataList.append(contentsOf: list)
            self?.collectionDataList.append(contentsOf: list)
            self?.filteredData = self?.tableDataList ?? []
        }
    }
    
    func callUserList(page:Int, CompletionHandler: @escaping (([UserResponseModel])-> Void)) {
        let param = ["page":page]
        self.animateLoader?(true)
        UserListRemoteDataProvider().getUserListData(param: param) {[weak self] (response, isSuccess, error) in
            self?.animateLoader?(false)
            if error != ""  {
                self?.showAlert?("Message",error)
                print(error)
            }
            else {
                guard let res = response else {
                    self?.showAlert?("Message",error)
                    return
                }
                CompletionHandler(res.data)
            }
        }
    }
    
    func updateTableData() {
        self.callUserList(page: tablePage+1) { (list) in
            if list.count > 0 {
                self.successAPI?()
                self.tablePage += 1
                self.tableDataList.append(contentsOf: list)
                self.filteredData = self.tableDataList
            }
        }
    }
    
    func updateCollectionData() {
        self.callUserList(page: collectionPage+1) { (list) in
            if list.count > 0 {
                self.successAPI?()
                self.collectionPage += 1
                self.collectionDataList.append(contentsOf: list)
            }
        }
    }
    
}
