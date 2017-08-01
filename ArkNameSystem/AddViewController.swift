//
//  AddViewController.swift
//  ArkNameSystem
//
//  Created by Qing Jiao on 31/7/17.
//  Copyright © 2017 ArkName. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
  fileprivate let eventView = ListTableView()
  fileprivate let memberView = NameScrollView()
  fileprivate let segmentedControl = UISegmentedControl(items: ["管理活动", "管理人员"])

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "添加活动&人员"
    view.backgroundColor = UIColor.white
    
    segmentedControl.addTarget(self, action: #selector(segmentControlAction(segment:)), for: .valueChanged)
    view.addSubview(segmentedControl)
    segmentedControl.selectedSegmentIndex = 0
    
    segmentedControl.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalToSuperview().offset(64)
      make.height.equalTo(44)
    }
    
    view.addSubview(eventView)
    view.addSubview(memberView)
    
    eventView.selectCallBack = { [unowned self] eventName in
      let evc = ANEventEditorViewController()
      evc.eventName = eventName
      self.navigationController?.pushViewController(evc, animated: true)
    }
    
    memberView.selectCallBack = { [unowned self] eventName in
      let evc = ANEditorMemberViewController()
      evc.memberName = eventName
      self.navigationController?.pushViewController(evc, animated: true)
    }
    
    eventView.isHidden = false
    memberView.isHidden = true
    
    eventView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(segmentedControl.snp.bottom).offset(5)
      make.bottom.equalToSuperview().offset(-35)
    }
    memberView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(segmentedControl.snp.bottom).offset(5)
      make.bottom.equalToSuperview().offset(5)
    }
    
    let addBtn = UIButton()
    view.addSubview(addBtn)
    addBtn.setImage(UIImage(named: "add"), for: .normal)
    addBtn.snp.makeConstraints { make in
      make.width.height.equalTo(55)
      make.bottom.right.equalToSuperview()
    }
    addBtn.addTarget(self, action: #selector(addClicked), for: .touchUpInside)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    refetchEvents()
    refetchMember()
  }
  
  func addClicked() {
    if segmentedControl.selectedSegmentIndex == 0 {
      let evc = ANEventEditorViewController()
      self.navigationController?.pushViewController(evc, animated: true)
    } else {
      let evc = ANEditorMemberViewController()
      self.navigationController?.pushViewController(evc, animated: true)
    }
  }
  
  func refetchEvents() {
    var names: [String] = []
    let eventObject = ArkNameDataContainer.instance().fetchEvents(nil)
    guard let events = eventObject else {
      eventView.names = []
      return
    }
    for one in events {
      let name = Dataconvert.convertNameEvent(one as! NSManagedObject)!
      names.append(name)
    }
    eventView.names = names
  }
  
  func refetchMember() {
    var names: [String] = []
    let eventObject = ArkNameDataContainer.instance().fetchMember(nil)
    guard let events = eventObject else {
      memberView.names = []
      return
    }
    for one in events {
      let name = Dataconvert.convertNameEvent(one as! NSManagedObject)!
      names.append(name)
    }
    memberView.names = names
  }
  
  func segmentControlAction(segment: UISegmentedControl) {
    let selectedIndex = segment.selectedSegmentIndex
    eventView.isHidden = selectedIndex == 1
    memberView.isHidden = selectedIndex == 0
    
    if !eventView.isHidden {
      refetchEvents()
    } else {
      refetchMember()
    }
  }
}
