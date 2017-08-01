//
//  UIViewSizesExtension.swift
//  Driver
//
//  Created by 陈扬 on 15/9/16.
//  Copyright © 2015年 陈扬. All rights reserved.
//

import UIKit

extension UIView {
  var left: CGFloat {
    get { return self.frame.origin.x }
    set {
      var frame: CGRect = self.frame
      frame.origin.x = newValue
      self.frame = frame
    }
  }
  
  var top: CGFloat {
    get { return self.frame.origin.y }
    set {
      var frame: CGRect = self.frame
      frame.origin.y = newValue
      self.frame = frame
    }
  }
  
  var right: CGFloat {
    get { return self.frame.origin.x + self.frame.size.width }
    set {
      var frame: CGRect = self.frame
      frame.origin.x = newValue - frame.size.width
      self.frame = frame
    }
  }
  
  var bottom: CGFloat {
    get { return self.frame.origin.y + self.frame.size.height }
    set {
      var frame: CGRect = self.frame
      frame.origin.y = newValue - frame.size.height
      self.frame = frame
    }
  }
  
  var width: CGFloat {
    get { return self.frame.size.width }
    set {
      var frame: CGRect = self.frame
      frame.size.width = newValue
      self.frame = frame
    }
  }
  
  var height: CGFloat {
    get { return self.frame.size.height }
    set {
      var frame: CGRect = self.frame
      frame.size.height = newValue
      self.frame = frame
    }
  }
  
  var origin: CGPoint {
    get { return self.frame.origin }
    set {
      var frame: CGRect = self.frame
      frame.origin = newValue
      self.frame = frame
    }
  }
  
  var size: CGSize {
    get { return self.frame.size }
    set {
      var frame: CGRect = self.frame
      frame.size = newValue
      self.frame = frame
    }
  }
  
  var centerX : CGFloat {
    get { return self.center.x }
    set {
      var center = self.center
      center.x = newValue
      self.center = center
    }
  }
  
  var centerY : CGFloat {
    get { return self.center.y }
    set {
      var center = self.center
      center.y = newValue
      self.center = center
    }
  }
  
  var rightToSuper : CGFloat {
    get { return (self.superview?.frame.size.width ?? 0) - self.right }
    set {
      var frame = self.frame
      frame.origin.x = (self.superview?.frame.size.width)! - newValue - frame.size.width
      self.frame = frame
    }
  }
  
  var bottomToSuper : CGFloat {
    get { return (self.superview?.frame.size.height ?? 0) - self.bottom }
    set {
      var frame = self.frame
      frame.origin.y = (self.superview?.frame.size.height)! - newValue - frame.size.height
      self.frame = frame
    }
  }
  
  func roundBorder(_ color: UIColor = .white, radius: CGFloat = 4.0, width: CGFloat = 0.5) {
    self.layer.cornerRadius = radius
    self.layer.borderWidth  = width
    self.layer.borderColor  = color.cgColor
    self.clipsToBounds      = true
  }
}

extension UIView {
  
  func corner(_ topLeft: UIRectCorner? = nil, topRight: UIRectCorner? = nil, bottomLeft: UIRectCorner? = nil, bottomRight: UIRectCorner? = nil,  cornerRadius:CGFloat) {
    var cornerValue : UInt?
    if let topLeft = topLeft {
      cornerValue = topLeft.rawValue
    }
    if let topRight = topRight {
      if let cornerValue_ = cornerValue {
        cornerValue = cornerValue_ | topRight.rawValue
      } else {
        cornerValue = topRight.rawValue
      }
    }
    if let bottomLeft = bottomLeft {
      if let cornerValue_ = cornerValue {
        cornerValue = cornerValue_ | bottomLeft.rawValue
      } else {
        cornerValue = bottomLeft.rawValue
      }
    }
    if let bottomRight = bottomRight {
      if let cornerValue_ = cornerValue {
        cornerValue = cornerValue_ | bottomRight.rawValue
      } else {
        cornerValue = bottomRight.rawValue
      }
    }
    let notNilCornerValue = cornerValue ?? UIRectCorner.allCorners.rawValue
    let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: UIRectCorner(rawValue: notNilCornerValue), cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
    let maskLayer = CAShapeLayer()
    maskLayer.frame = self.bounds
    maskLayer.path = maskPath.cgPath
    self.layer.mask = maskLayer
  }
  
  func toImage() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    layer.render(in: context)
    let viewImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return viewImage
  }
}

extension UIView {
  func removeAllSubViews() {
    let theSubViews = self.subviews
    for one in theSubViews {
      one.removeFromSuperview()
    }
  }
}

extension UIView {
  func setHighContentCompressionResistancePriority(for axis: UILayoutConstraintAxis) {
    self.setContentCompressionResistancePriority(1000, for: axis)
  }
  
  func setLowContentCompressionResistancePriority(for axis: UILayoutConstraintAxis) {
    self.setContentCompressionResistancePriority(500, for: axis)
  }
  
  func setHighContentHuggingPriority(for axis: UILayoutConstraintAxis) {
    self.setContentHuggingPriority(1000, for: axis)
  }
  
  func setLowContentHuggingPriority(for axis: UILayoutConstraintAxis) {
    self.setContentHuggingPriority(500, for: axis)
  }
}
