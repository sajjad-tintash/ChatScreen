//
//  Constants.swift
//  TestChat
//
//  Created by Sajjad  on 10/10/2018.
//  Copyright © 2018 Sajjad . All rights reserved.
//

import UIKit

let BUBBLE_WIDTH_RATIO  : CGFloat = 0.6
let BUBBLE_HEIGHT_RATIO : CGFloat = 0.4
let MIN_BUBBLE_HEIGHT   : CGFloat = 32
let MAX_BUBBLE_WIDTH    : CGFloat = UIScreen.main.bounds.width * BUBBLE_WIDTH_RATIO
let MAX_BUBBLE_HEIGHT   : CGFloat = UIScreen.main.bounds.height * BUBBLE_HEIGHT_RATIO
let SCREEN_WIDTH        : CGFloat = UIScreen.main.bounds.width
let FONT                : UIFont  = UIFont.systemFont(ofSize: 18)
let BUBBLE_X_PADDING    : CGFloat = 28
let BUBBLE_Y_PADDING    : CGFloat = 8
let BUBBLE_SENDER_SPACE : CGFloat = 40


enum ChatType {
    case sender, recepient
}

enum MediaType {
    case text, image
}
