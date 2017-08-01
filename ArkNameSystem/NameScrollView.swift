//
//  NameScrollView.swift
//  ArkNameSystem
//
//  Created by Qing Jiao on 31/7/17.
//  Copyright © 2017 ArkName. All rights reserved.
//

import UIKit

class NameScrollView: UIScrollView {
  private var users: [String] = []
  var names: [String] {
    set {
      users = newValue
      setNeedsLayout()
    }
    get {
      return users
    }
  }
  
  var cellColor = DesignColor.White
  
  var selectCallBack: ((String) -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    backgroundColor = UIColor.white
  
    removeAllSubViews()
    
    let cellWidth = frame.size.width / 4
    let cellHeight: CGFloat = 50
    var ox = 0
    var oy = 0
    
    for (index, one) in users.enumerated() {
      ox = (index % 4) * Int(cellWidth)
      oy = (index / 4) * Int(cellHeight)
      let cell = NameCell(frame: CGRect(x: CGFloat(ox), y: CGFloat(oy), width: cellWidth, height: cellHeight))
      addSubview(cell)
      cell.nameLabel.backgroundColor = cellColor
      cell.nameLabel.text = one
      cell.tag = index
      
      cell.addTarget(self, action: #selector(cellDidClicked(btn:)), for: .touchUpInside)
    }
    
    contentSize = CGSize(width: frame.size.width, height: CGFloat(oy) + cellHeight + 22)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func cellDidClicked(btn: AnyObject) {
    let tag = (btn as! UIButton).tag
    let name = users[tag]
    
    selectCallBack?(name)
  }
  
}

class NameCell: UIButton {
  let nameLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(nameLabel)
    nameLabel.textColor = UIColor.black
    nameLabel.font = UIFont.systemFont(ofSize: 15)
    nameLabel.textAlignment = .center
    nameLabel.layer.cornerRadius = 4
    nameLabel.layer.borderColor = UIColor.black.cgColor
    nameLabel.layer.borderWidth = 1
    
    nameLabel.snp.makeConstraints { make in
      make.leading.top.equalToSuperview().offset(6)
      make.trailing.bottom.equalToSuperview().offset(-6)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
