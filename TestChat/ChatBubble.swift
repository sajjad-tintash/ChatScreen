//
//  ChatBubble.swift
//  TestChat
//
//  Created by Sajjad  on 09/10/2018.
//  Copyright © 2018 Sajjad . All rights reserved.
//

import UIKit

let MIN_BUBBLE_HEIGHT   : CGFloat = 32
let MAX_BUBBLE_WIDTH    : CGFloat = UIScreen.main.bounds.width * 0.6
let SCREEN_WIDTH        : CGFloat = UIScreen.main.bounds.width
let BUBBLE_X_PADDING    : CGFloat = 28
let BUBBLE_Y_PADDING    : CGFloat = 8
let BUBBLE_SENDER_SPACE : CGFloat = 40
let FONT                : UIFont  = UIFont.systemFont(ofSize: 18)

enum ChatType {
    case sender, recepient
}

enum MediaType {
    case text, image
}

class ChatBubble: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var senderImage: UIImageView!
    
    var outgoingMessageLayer: CAShapeLayer? = nil
    var dataText: String? = nil
    var label: UILabel? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
        backgroundView = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if outgoingMessageLayer != nil {
            outgoingMessageLayer?.removeFromSuperlayer()
            outgoingMessageLayer = nil
        }
        if dataText != nil {
            dataText = nil
        }
        if label != nil {
            label?.removeFromSuperview()
            label = nil
        }
    }
    
    func setup(_ text: String) {
        dataText = text
        senderImage.layer.cornerRadius = senderImage.frame.width/2
        senderImage.clipsToBounds = true
        showBubble()
    }

    
    
    func showBubble() {
        guard let text = dataText else { return }
        
        
        var height = text.height(withConstrainedWidth: MAX_BUBBLE_WIDTH, font: FONT)
        var width = MAX_BUBBLE_WIDTH
        
        if height < MIN_BUBBLE_HEIGHT {
            height = MIN_BUBBLE_HEIGHT
            width = text.width(withConstrainedHeight: height, font: FONT)
        }
        
        label =  UILabel()
        label?.numberOfLines = 0
        label?.font = FONT
        label?.textColor = .white
        label?.textAlignment = .right
        label?.text = text
        
        label?.frame = CGRect(x: SCREEN_WIDTH - (width + BUBBLE_X_PADDING/2) - BUBBLE_SENDER_SPACE,y:2,
                             width: width,
                             height: height)
        
        height += BUBBLE_Y_PADDING
        width  += BUBBLE_X_PADDING
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: width - 22, y: height))
        bezierPath.addLine(to: CGPoint(x: 17, y: height))
        bezierPath.addCurve(to: CGPoint(x: 0, y: height - 17), controlPoint1: CGPoint(x: 7.61, y: height), controlPoint2: CGPoint(x: 0, y: height - 7.61))
        bezierPath.addLine(to: CGPoint(x: 0, y: 17))
        bezierPath.addCurve(to: CGPoint(x: 17, y: 0), controlPoint1: CGPoint(x: 0, y: 7.61), controlPoint2: CGPoint(x: 7.61, y: 0))
        bezierPath.addLine(to: CGPoint(x: width - 21, y: 0))
        bezierPath.addCurve(to: CGPoint(x: width - 4, y: 17), controlPoint1: CGPoint(x: width - 11.61, y: 0), controlPoint2: CGPoint(x: width - 4, y: 7.61))
        bezierPath.addLine(to: CGPoint(x: width - 4, y: height - 11))
        bezierPath.addCurve(to: CGPoint(x: width, y: height), controlPoint1: CGPoint(x: width - 4, y: height - 1), controlPoint2: CGPoint(x: width, y: height))
        bezierPath.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
        bezierPath.addCurve(to: CGPoint(x: width - 11.04, y: height - 4.04), controlPoint1: CGPoint(x: width - 4.07, y: height + 0.43), controlPoint2: CGPoint(x: width - 8.16, y: height - 1.06))
        bezierPath.addCurve(to: CGPoint(x: width - 22, y: height), controlPoint1: CGPoint(x: width - 16, y: height), controlPoint2: CGPoint(x: width - 19, y: height))
        bezierPath.close()
        
        outgoingMessageLayer = CAShapeLayer()
        outgoingMessageLayer?.path = bezierPath.cgPath
        outgoingMessageLayer?.frame = CGRect(x: SCREEN_WIDTH - width - BUBBLE_SENDER_SPACE,y:0,
                                                         width: width,
                                                         height: height)
        outgoingMessageLayer?.fillColor = UIColor.random().cgColor
        
        if let bubbleLayer = outgoingMessageLayer {
            mainView.layer.addSublayer(bubbleLayer)
        }
        if let textlabel = label {
            mainView.addSubview(textlabel)
            mainView.addConstraint(NSLayoutConstraint(item: textlabel, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1, constant: BUBBLE_Y_PADDING/2))
            mainView.addConstraint(NSLayoutConstraint(item: textlabel, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1, constant: -BUBBLE_Y_PADDING/2))
        }

    }
}
