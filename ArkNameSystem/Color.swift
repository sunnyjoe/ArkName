//
//  Driver-Color.swift
//  Driver
//
//  Created by 陈扬 on 15/12/9.
//  Copyright © 2015 GrabTaxi Pte Ltd. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

struct DesignColor {
  static let Green_S = UIColor(hex6: 0x38C564)
  static let Green   = UIColor(hex6: 0x00B140) //0 177 64
  static let Green_L = UIColor(hex6: 0x008d33)
  static let Green_XL = UIColor(hex6: 0x33C066)
  static let Green_XXL  = UIColor(hex6: 0x1AB53D)
  static let Green_A_87 = UIColor(hex6: 0x00B140, alpha: 0.87)
  static let Green_BUBBLE  = UIColor(hex6: 0x3DCA61)
  static let Green_MSG  = UIColor(hex6: 0x39CB60)
  static let Green_NOTIFICATION = UIColor(hex6: 0x33C066, alpha: 0.85)
  static let Green_FARE  = UIColor(hex6: 0x1DBB35)
  static let Green_FONT  = UIColor(hex6: 0x12B63B)
  
  static let Red_F05D3F = UIColor(hex6: 0xf05d3f)
  static let Red_S   = UIColor(hex6: 0xE95E41)
  static let Red     = UIColor(hex6: 0xD64425) //214 68 37
  static let Red_L   = UIColor(hex6: 0xBD3D22)
  static let Red_Orange = UIColor(hex6: 0xE94F1D)//233 94 65 orangeyRed
  static let Red_XL = UIColor(hex6: 0xFF5E3C) // 255 94 60
  static let Red_Disqualified = UIColor(hex6: 0xFF6260)
  static let Red_FARE = UIColor(hex6: 0xD54123) // 255 94 60

  static let Gray_XS  = UIColor(hex6: 0xF7F9FB) //247 249 251
  static let Gray_S   = UIColor(hex6: 0xEAEFF2) //234 239 242
  static let Gray_M   = UIColor(hex6: 0xCCD6DD) //204 214 221
  static let Gray_XM   = UIColor(hex6: 0x6C7180) //108 113 128
  static let Gray     = UIColor(hex6: 0x898D97) //137 141 151
  static let Gray_L   = UIColor(hex6: 0x565D6B) //86 93 107
  static let Gray_L_A_75  = UIColor(hex6: 0x565D6B, alpha: 0.75) //86 93 107
  static let Gray_XL  = UIColor(hex6: 0x363A45) //54 58 69
  static let Gray_XXL = UIColor(hex6: 0x252831) //37 40 49
  static let Gray_XXXL = UIColor(hex6: 0x212327) //33 35 39
  static let Gray_NOTIFICATION = UIColor(hex6: 0x898D97, alpha: 0.85)
  static let Gray_Outline = UIColor(hex6: 0xAEC4D3)
  static let Gray_OddLine = UIColor(hex6: 0xEAEFF2)
  static let Gray_EvenLine = UIColor(hex6: 0xD2DDE6)
  static let Gray_SEPARATOR = UIColor(hex6: 0x4F5360)

  static let Blue_XS  = UIColor(hex6: 0xEAEFF2)
  static let Blue_S   = UIColor(hex6: 0x5E9BF2)
  static let Blue     = UIColor(hex6: 0x488BE4)
  static let Blue_L   = UIColor(hex6: 0x326BBF)
  static let Blue_XL  = UIColor(hex6: 0x4A90E2)
  static let Blue_4489E7  = UIColor(hex6: 0x4489e7)
  static let Blue_XXL = UIColor(hex6: 0x7CB8FF)
  static let Blue_B   = UIColor(hex6: 0x478AE7) //71, 138, 231
  static let Blue_A_87  = UIColor(hex6: 0x488BE4, alpha: 0.87)
  static let Blue_B_GRABSHARE = UIColor(hex6: 0x336EBF)
  static let Blue_B_NORMAL    = UIColor(hex6: 0x363A45)
  static let Blue_NOTIFICATION  = UIColor(hex6: 0x478BE3, alpha: 0.85)

  static let Yellow_S = UIColor(hex6: 0xF8D367)
  static let Yellow   = UIColor(hex6: 0xF7C942)
  static let Yellow_L = UIColor(hex6: 0xE6AC23)
  static let Yellow_B = UIColor(hex6: 0xFDCF41)

  static let White    = UIColor.white
  static let White_S  = UIColor(hex6: 0xFAFAFA)
  static let White_Arrow = UIColor(hex6: 0xC7C7CC)
  static let Black    = UIColor.black
  static let Black_A_60 = UIColor(hex6: 0x000000, alpha: 0.6)
  static let Black_A_80 = UIColor(hex6: 0x000000, alpha: 0.8)
  static let Black_4A = UIColor(hex6: 0x4A4A4A)

  static let White_Alpha_40 = UIColor(hex6: 0xFFFFFF, alpha: 0.4)
  static let White_Alpha_50 = UIColor(hex6: 0xFFFFFF, alpha: 0.5)
  static let White_Alpha_80 = UIColor(hex6: 0xFFFFFF, alpha: 0.8)
  static let White_Alpha_15 = UIColor(hex6: 0xFFFFFF, alpha: 0.15)
  static let White_Alpha_30 = UIColor(hex6: 0xFFFFFF, alpha: 0.3)
  static let White_S_X        = UIColor(hex6: 0xBDBDBD)
  static let Gray_M_50 = UIColor(hex6: 0xCCD6DD, alpha: 0.5)
  static let Blue_S_40 = UIColor(hex6: 0x5E9BF2, alpha: 0.4)
  static let Green_XXL_40 = UIColor(hex6: 0x1AB53D, alpha: 0.4)


  static let coolGreen2 = UIColor(hex6: 0x33c066, alpha: 1.0)
  static let lighterGrey = UIColor(hex6: 0xDCDCDC, alpha: 1.0)
  static let charcoalGrey = UIColor(hex6: 0x363A45, alpha: 1.0)

  //Colors from zeplin style guide
  static let grayishBrown = UIColor(hex6: 0x4A4A4A, alpha: 1.0)
  static let grayishBrownTwo = UIColor(hex6: 0x5A5A5A, alpha: 1.0)
  static let cloudyBlue = UIColor(hex6: 0x4A4A4A, alpha: 1.0)
  static let darkSkyBlue = UIColor(hex6: 0x4A90E2, alpha: 1.0)
  static let shamrock = UIColor(hex6: 0x00B140, alpha: 1.0)
  static let paleGray = UIColor(hex6: 0xEAEFF2, alpha: 1.0)
  static let paleGrayTwo = UIColor(hex6: 0xEFEEF1, alpha: 1.0)
  static let lighterGray = UIColor(hex6: 0xDCDCDC)
  static let silver = UIColor(hex6: 0xE6E7E8, alpha: 1.0)
  static let blendedGray = UIColor(hex6: 0x4d4d4d, alpha: 1.0)
  static let blendedGrayLigher = UIColor(hex6: 0x666666, alpha: 1.0)
  static let blendedPaleGrayTwo = UIColor(hex6: 0xF5F5F7, alpha: 1.0)
  static let scarlet = UIColor(hex6: 0xD0021B, alpha: 1.0)
  static let brownishGrey = UIColor(hex6: 0x666666, alpha: 1.0)
  static let slateGrey = UIColor(hex6: 0x565D6B, alpha: 1.0)
  static let paleGrey3 = UIColor(hex6: 0xF7F9FB, alpha: 1.0)
  static let paleRed = UIColor(hex6: 0xD74D2F, alpha: 1.0)
  static let battleshipGrey = UIColor(hex6: 0x767a85, alpha: 1.0)
  static let paleGrey = UIColor(hex6: 0xe5ebef, alpha: 1.0)
  static let black50 = UIColor(hex6: 0x000000, alpha: 0.5)
  static let coolGreen = UIColor(hex6: 0x2eb753, alpha: 1.0)
  static let orangish = UIColor(hex6: 0xF77658, alpha: 1.0)
  static let orangishAlpha40 = UIColor(hex6: 0xF77658, alpha: 0.4)
  static let dustyOrange = UIColor(hex6: 0xEC5F3B, alpha: 1.0)
  static let charcoalGreyThree = UIColor(hex6: 0x363A45, alpha: 1.0)
  static let steel = UIColor(hex6: 0x898D97, alpha: 1.0)
  static let cloudyBlue2 = UIColor(hex6: 0xCCD6DD, alpha: 1.0)
  static let maizeTwo = UIColor(hex6: 0xF7C942, alpha: 1.0)
  static let paleGrayThree = UIColor(hex6: 0xF7F9FB, alpha: 1.0)
  static let slateGreyText = UIColor(hex6: 0x565D6B, alpha: 1.0)
  //
  static let dark = UIColor(hex6: 0x16171C)

  static let cloudyBlue3 = UIColor(hex6: 0xCCD6DD, alpha: 1.0)
  static let maize = UIColor(hex6: 0xF7C942, alpha: 1.0)
  static let darkSkyBlue2 = UIColor(hex6: 0x488BE4, alpha: 1.0)
  static let darkSkyBlueText = UIColor(hex6: 0x4788E4, alpha: 1.0)
  static let warmGrey = UIColor(hex6: 0x979797, alpha: 1.0)
}
