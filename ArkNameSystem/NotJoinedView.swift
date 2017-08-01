//
//  NotJoinedView.swift
//  ArkNameSystem
//
//  Created by Qing Jiao on 1/8/17.
//  Copyright © 2017 ArkName. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NotJoinedView: UIView {
  private let nameViews = NameScrollView()
  
  var selectNameCallBack: ((String) -> Void)? {
    set {
      nameViews.selectCallBack = newValue
    } get {
      return nameViews.selectCallBack
    }
  }
  
  fileprivate var notJoinedNames: [String] = []
  fileprivate var searchArray: [String] = []
  
  var inSearch: Bool {
    set {
      if newValue {
        nameViews.names = searchArray
      } else {
        nameViews.names = notJoinedNames
      }
    } get {
      return false //fake
    }
  }
  
  var pullCallBack: (() -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let pullBtn = UIButton()
    addSubview(pullBtn)
    pullBtn.setImage(UIImage(named: "pull"), for: .normal)
    pullBtn.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
      make.width.height.equalTo(50)
    }
    _ = pullBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.pullCallBack?()
    })
    
    let contentView = UIView()
    addSubview(contentView)
    contentView.backgroundColor = DesignColor.Gray_XS
    contentView.snp.makeConstraints { make in
      make.top.equalTo(pullBtn.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    let titleLabel = UILabel()
    contentView.addSubview(titleLabel)
    titleLabel.text = "可选人员"
    titleLabel.textColor = DesignColor.Gray_XXXL
    titleLabel.font = UIFont.systemFont(ofSize: 22)
    titleLabel.textAlignment = .center
    titleLabel.isUserInteractionEnabled = true
    
    let searchNameTF = UITextField()
    contentView.addSubview(searchNameTF)
    searchNameTF.placeholder = "搜索名字"
    searchNameTF.textColor = DesignColor.Gray_XXXL
    searchNameTF.returnKeyType = .done
    searchNameTF.delegate = self
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(5)
      make.leading.trailing.equalToSuperview()
    }
    
    searchNameTF.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().offset(5)
      make.height.equalTo(22)
      make.width.equalTo(150)
    }
    
    let tapG = UITapGestureRecognizer()
    titleLabel.addGestureRecognizer(tapG)
    _ = tapG.rx.event.subscribe(onNext: { [unowned self] _ in
      self.inSearch = false
      searchNameTF.text = nil
    })
    
    contentView.addSubview(nameViews)
    nameViews.backgroundColor = DesignColor.Gray_XS
    nameViews.layer.borderWidth = 1
    nameViews.layer.borderColor = DesignColor.Black.cgColor
    nameViews.snp.makeConstraints { make in
      make.top.equalTo(searchNameTF.snp.bottom).offset(5)
      make.trailing.equalToSuperview().offset(-5)
      make.leading.equalToSuperview().offset(5)
      make.bottom.equalToSuperview().offset(-10)
    }
  }
  
  func addName(_ name: String) {
    notJoinedNames.insert(name, at: 0)
    nameViews.names = notJoinedNames
  }
  
  func removeName(_ name: String) {
    guard let index = notJoinedNames.index(of: name) else { return }
    notJoinedNames.remove(at: index)
    nameViews.names = notJoinedNames
  }
  
  func resetNames(_ names: [String]) {
    notJoinedNames = names
    nameViews.names = notJoinedNames
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension NotJoinedView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    showSearchResult(textField.text)
    return true
  }
  
  func showSearchResult(_ key: String?) {
    guard let text = key, !text.isEmpty else {
      inSearch = false
      return
    }
    
    let trimedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
    
    searchArray.removeAll()
    for one in notJoinedNames {
      if (one.range(of: trimedText) != nil) {
        searchArray.append(one)
      }
    }
    inSearch = true
    return
  }
}
