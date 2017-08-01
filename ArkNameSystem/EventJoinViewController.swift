//
//  EventJoinViewController.swift
//  ArkNameSystem
//
//  Created by Qing Jiao on 31/7/17.
//  Copyright © 2017 ArkName. All rights reserved.
//

import UIKit
import SnapKit

class EventJoinViewController: ANEventJoinViewController {
  let joinedView = JoinedView()
  let notJoinedView = NotJoinedView()
  
  var joinedUp = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(joinedView)
    view.addSubview(notJoinedView)
    setUpLayoutConstraints()
    
    joinedView.saveCallBack = {
      self.saveBtnDidClick()
    }
    
    notJoinedView.selectNameCallBack = { [unowned self] name in
      self.didEdit = true

      self.notJoinedView.removeName(name)
      self.joinedView.addName(name)
      
      self.notJoinedArray.remove(name)
      self.joinedArray.add(name)
    }
    
    joinedView.selectNameCallBack = { [unowned self] name in
      self.didEdit = true
      
      self.joinedView.removeName(name)
      self.notJoinedView.addName(name)
      
      self.joinedArray.remove(name)
      self.notJoinedArray.add(name)
    }
    
    notJoinedView.pullCallBack = { [unowned self] _ in
      self.joinedUp = !self.joinedUp
      self.showNotJoined(self.joinedUp)
    }
  }
  
  func showNotJoined(_ up: Bool) {
    let joinedFrame = joinedView.frame
    
    if up {
      var upFrame = joinedFrame
      upFrame.origin.y += 200
      
      UIView.animate(withDuration: 0.3, animations: {
        self.notJoinedView.frame = upFrame
      })
    } else {
      var downFrame = joinedFrame
      downFrame.origin.y = view.frame.size.height - 64 - 70
      
      UIView.animate(withDuration: 0.3, animations: {
        self.notJoinedView.frame = downFrame
      })
    }
  }

  override func refreshJoinedMember(_ members: NSMutableArray!) {
    let castMembers = members as! [String]
    joinedView.resetNames(castMembers)
  }
  
  override func refreshNotJoinedMember(_ members: NSMutableArray!) {
    let castMembers = members as! [String]
    notJoinedView.resetNames(castMembers)
  }
}

extension EventJoinViewController {
  fileprivate func setUpLayoutConstraints() {
    dateBGView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(64)
      make.leading.trailing.equalToSuperview()
    }
    
    selectDateBtn.snp.makeConstraints { make in
      make.height.equalTo(20)
      make.top.equalToSuperview().offset(12)
      make.bottom.equalToSuperview().offset(-12)
      make.leading.trailing.equalToSuperview()
    }
    
    joinedView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().offset(-70)
      make.top.equalTo(selectDateBtn.snp.bottom).offset(12)
    }
    
    notJoinedView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
      make.top.equalTo(joinedView).offset(200)
    }
  }
}

