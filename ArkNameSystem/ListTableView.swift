//
//  ListTableView.swift
//  ColourMemory
//
//  Created by jiao qing on 27/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit
import SnapKit

let UserScoreTableCellIdentity = "UserScoreTableCellIdentity"

class ListTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
  private var users: [String] = []
  var names: [String] {
    set {
      users = newValue
      reloadData()
    }
    get {
      return users
    }
  }

  var selectCallBack: ((String) -> Void)?
  
  init() {
    super.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    
    contentInset = UIEdgeInsetsMake(0, 0, 30, 0)
    backgroundColor = UIColor.white
    self.delegate = self
    self.dataSource = self
    self.separatorStyle = .none
    self.showsVerticalScrollIndicator = false
    self.register(ListTableCell.self, forCellReuseIdentifier: UserScoreTableCellIdentity)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    return users.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UserScoreTableCellIdentity) as! ListTableCell
    let name = users[indexPath.row]
    cell.selectionStyle = .none
    cell.setName(name)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectCallBack?(users[indexPath.row])
  }
}

class ListTableCell: UITableViewCell {
  fileprivate let nameLabel = UILabel()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubview(nameLabel)
    nameLabel.textColor = UIColor.black
    nameLabel.font = UIFont.systemFont(ofSize: 18)
    nameLabel.textAlignment = .center
    
    let border = UIView()
    border.backgroundColor = UIColor.white
    addSubview(border)
    
    nameLabel.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalToSuperview()
    }
  }
  
  func setName(_ name : String){
    nameLabel.text = name
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


