//
//  JoinedView.swift
//  ArkNameSystem
//
//  Created by Qing Jiao on 1/8/17.
//  Copyright © 2017 ArkName. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class JoinedView: UIView {
  private let joinNumberLb = UILabel()
  private let nameViews = NameScrollView()

  var saveCallBack: (() -> Void)?
  
  var selectNameCallBack: ((String) -> Void)? {
    set {
      nameViews.selectCallBack = newValue
    } get {
      return nameViews.selectCallBack
    }
  }

  fileprivate var numbers: Int {
    set {
      joinNumberLb.text = "\(newValue)"
    } get {
      let text = joinNumberLb.text ?? "0"
      return Int(text) ?? 0
    }
  }
  
  fileprivate var joinedNames: [String] = []
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let joinedLabel = UILabel()
    addSubview(joinedLabel)
    joinedLabel.text = "参加的人员"
    joinedLabel.textColor = DesignColor.Gray_XXXL
    joinedLabel.font = UIFont.systemFont(ofSize: 22)
    joinedLabel.textAlignment = .center
    
    addSubview(joinNumberLb)
    joinNumberLb.text = "0"
    joinNumberLb.textColor = DesignColor.Gray_XXXL
    joinNumberLb.font = UIFont.systemFont(ofSize: 22)
    joinNumberLb.textAlignment = .center
    
    joinedLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(5)
      make.leading.trailing.equalToSuperview()
    }
    
    joinNumberLb.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(joinedLabel.snp.bottom).offset(5)
    }
    
    let saveBtn = UIButton()
    addSubview(saveBtn)
    saveBtn.layer.borderColor = DesignColor.Black.cgColor
    saveBtn.setTitle("保存", for: .normal)
    _ = saveBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.saveCallBack?()
    })
    saveBtn.setTitleColor(DesignColor.Blue, for: .normal)
    saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    
    saveBtn.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-22)
      make.top.equalTo(joinNumberLb)
    }
    
    nameViews.cellColor = DesignColor.Green_S
    addSubview(nameViews)
    nameViews.layer.borderWidth = 1
    nameViews.layer.borderColor = DesignColor.Black.cgColor
    nameViews.snp.makeConstraints { make in
      make.top.equalTo(joinNumberLb.snp.bottom).offset(5)
      make.trailing.equalToSuperview().offset(-5)
      make.leading.equalToSuperview().offset(5)
      make.bottom.equalToSuperview().offset(-10)
    }
  }
  
  func resetNames(_ names: [String]) {
    joinedNames = names
    nameViews.names = joinedNames
    numbers = joinedNames.count
  }
  
  func addName(_ name: String) {
    joinedNames.insert(name, at: 0)
    nameViews.names = joinedNames
    numbers = joinedNames.count
  }
  
  func removeName(_ name: String) {
    guard let index = joinedNames.index(of: name) else { return }
    joinedNames.remove(at: index)
    nameViews.names = joinedNames
    numbers = joinedNames.count
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
