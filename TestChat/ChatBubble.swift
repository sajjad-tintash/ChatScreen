//
//  ChatBubble.swift
//  TestChat
//
//  Created by Sajjad  on 09/10/2018.
//  Copyright © 2018 Sajjad . All rights reserved.
//

import UIKit
let BUBBLE_SCREEN_RATIO : CGFloat = 0.6
let MIN_BUBBLE_HEIGHT   : CGFloat = 32
let MAX_BUBBLE_WIDTH    : CGFloat = UIScreen.main.bounds.width * BUBBLE_SCREEN_RATIO
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

    @IBOutlet weak var mainView         : UIView!
    @IBOutlet weak var senderImage      : UIImageView!
    @IBOutlet weak var recieverImage    : UIImageView!
    
    var messageLayer    : CAShapeLayer?     = nil
    var chatImageView   : UIImageView?      = nil

    var dataText        : String? = nil
    var label           : UILabel? = nil
    var imageContent    : UIImage? = nil
    
    var chatType    = ChatType.sender
    var mediaType   = MediaType.text
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
        backgroundView = nil
        
        senderImage.clipsToBounds        = true
        senderImage.layer.cornerRadius   = senderImage.frame.width/2
        recieverImage.clipsToBounds      = true
        recieverImage.layer.cornerRadius = recieverImage.frame.width/2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataText = nil
        imageContent = nil
        if messageLayer != nil {
            messageLayer?.removeFromSuperlayer()
            messageLayer = nil
        }
        if label != nil {
            label?.removeFromSuperview()
            label = nil
        }
        if chatImageView != nil {
            chatImageView?.removeFromSuperview()
            chatImageView = nil
        }
    }

    func setup<T>(_ data: T, messageOrigin: ChatType) {
        chatType                = messageOrigin
        recieverImage.isHidden  = chatType == .sender
        senderImage.isHidden    = chatType == .recepient
        if let text = data as? String {
            dataText    = text
            mediaType   = .text
        } else if let image = data as? UIImage {
            imageContent = image
            mediaType    = .image
        }
        showBubble()
    }
    
    
    func showBubble() {
        var height: CGFloat
        var width: CGFloat
        var bezierPath: UIBezierPath
        switch mediaType {
        case .image:
            guard let image = imageContent else { return }
            let aspectRatio = image.size.width / image.size.height
            if image.size.width < MAX_BUBBLE_WIDTH {
                width = image.size.width
                height = image.size.height
            } else  {
                width = MAX_BUBBLE_WIDTH
                height = width / aspectRatio
            }
            switch chatType {
            case .sender:
                bezierPath = senderBazierPath(width: width, height: height)
                let messageLayer = CAShapeLayer()
                messageLayer.path = bezierPath.cgPath
                messageLayer.frame = CGRect(x: 0,y:0,
                                            width: width,
                                            height: height)
                chatImageView = UIImageView(image: image)
                chatImageView?.frame = CGRect(x: SCREEN_WIDTH - width - BUBBLE_SENDER_SPACE, y: 0, width: width, height: height)
                chatImageView?.contentMode = .scaleAspectFill
                chatImageView?.clipsToBounds = true
                chatImageView?.layer.mask = messageLayer
                if let chatImageView = chatImageView {
                    mainView.addSubview(chatImageView)
                    mainView.addConstraint(NSLayoutConstraint(item: chatImageView, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1, constant: BUBBLE_Y_PADDING/2))
                    mainView.addConstraint(NSLayoutConstraint(item: chatImageView, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1, constant: -BUBBLE_Y_PADDING/2))
                }
             

            case .recepient:
                bezierPath = recieverBazierPath(width: width, height: height)
                let messageLayer = CAShapeLayer()
                 messageLayer.path = bezierPath.cgPath
                messageLayer.frame = CGRect(x: 0,y:0,
                                            width: width,
                                            height: height)
                chatImageView = UIImageView(image: image)
                chatImageView?.frame = CGRect(x: BUBBLE_SENDER_SPACE, y: 0, width: width, height: height)
                chatImageView?.contentMode = .scaleAspectFill
                chatImageView?.clipsToBounds = true
                chatImageView?.layer.mask = messageLayer
                
                if let chatImageView = chatImageView {
                    mainView.addSubview(chatImageView)
                    mainView.addConstraint(NSLayoutConstraint(item: chatImageView, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1, constant: BUBBLE_Y_PADDING/2))
                    mainView.addConstraint(NSLayoutConstraint(item: chatImageView, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1, constant: -BUBBLE_Y_PADDING/2))
                }
            }
            
        case .text:
            guard let text = dataText else { return }
            height = text.height(withConstrainedWidth: MAX_BUBBLE_WIDTH, font: FONT)
            width = MAX_BUBBLE_WIDTH
            
            if height < MIN_BUBBLE_HEIGHT {
                height = MIN_BUBBLE_HEIGHT
                width = text.width(withConstrainedHeight: height, font: FONT)
            }
            label =  UILabel()
            label?.numberOfLines = 0
            label?.font = FONT
            switch chatType {
            case .sender:
                label?.textColor = .white
                label?.textAlignment = .right
                label?.text = text
                label?.frame = CGRect(x: SCREEN_WIDTH - (width + BUBBLE_X_PADDING/2) - BUBBLE_SENDER_SPACE,y:2,
                                      width: width,
                                      height: height)
                height += BUBBLE_Y_PADDING
                width  += BUBBLE_X_PADDING
                
                bezierPath = senderBazierPath(width: width, height: height)
                messageLayer = CAShapeLayer()
                messageLayer?.path = bezierPath.cgPath
                messageLayer?.frame = CGRect(x: SCREEN_WIDTH - width - BUBBLE_SENDER_SPACE,y:0,
                                                     width: width,
                                                     height: height)
                messageLayer?.fillColor = UIColor.green.cgColor
                if let messageLayer = messageLayer {
                    mainView.layer.addSublayer(messageLayer)
                }
                if let textlabel = label {
                    mainView.addSubview(textlabel)
                    mainView.addConstraint(NSLayoutConstraint(item: textlabel, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1, constant: BUBBLE_Y_PADDING/2))
                    mainView.addConstraint(NSLayoutConstraint(item: textlabel, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1, constant: -BUBBLE_Y_PADDING/2))
                }
            case .recepient:
                label?.textColor = .black
                label?.textAlignment = .left
                label?.text = text
                label?.frame = CGRect(x: BUBBLE_SENDER_SPACE + BUBBLE_X_PADDING / 2,y:2,
                                      width: width,
                                      height: height)
                height += BUBBLE_Y_PADDING
                width  += BUBBLE_X_PADDING
                bezierPath = recieverBazierPath(width: width, height: height)
                messageLayer = CAShapeLayer()
                messageLayer?.path = bezierPath.cgPath
                messageLayer?.frame = CGRect(x: BUBBLE_SENDER_SPACE, y:0,
                                                    width: width,
                                                    height: height)
                messageLayer?.fillColor = UIColor.lightGray.cgColor
                if let messageLayer = messageLayer {
                    mainView.layer.addSublayer(messageLayer)
                }
                if let textlabel = label {
                    mainView.addSubview(textlabel)
                    mainView.addConstraint(NSLayoutConstraint(item: textlabel, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1, constant: BUBBLE_Y_PADDING/2))
                    mainView.addConstraint(NSLayoutConstraint(item: textlabel, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1, constant: -BUBBLE_Y_PADDING/2))
                }
            }
        }
    }
    
    func senderBazierPath(width: CGFloat, height: CGFloat) -> UIBezierPath {
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
        return bezierPath
    }
    
    func recieverBazierPath(width: CGFloat, height: CGFloat) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 22, y: height))
        bezierPath.addLine(to: CGPoint(x: width - 17, y: height))
        bezierPath.addCurve(to: CGPoint(x: width, y: height - 17), controlPoint1: CGPoint(x: width - 7.61, y: height), controlPoint2: CGPoint(x: width, y: height - 7.61))
        bezierPath.addLine(to: CGPoint(x: width, y: 17))
        bezierPath.addCurve(to: CGPoint(x: width - 17, y: 0), controlPoint1: CGPoint(x: width, y: 7.61), controlPoint2: CGPoint(x: width - 7.61, y: 0))
        bezierPath.addLine(to: CGPoint(x: 21, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 4, y: 17), controlPoint1: CGPoint(x: 11.61, y: 0), controlPoint2: CGPoint(x: 4, y: 7.61))
        bezierPath.addLine(to: CGPoint(x: 4, y: height - 11))
        bezierPath.addCurve(to: CGPoint(x: 0, y: height), controlPoint1: CGPoint(x: 4, y: height - 1), controlPoint2: CGPoint(x: 0, y: height))
        bezierPath.addLine(to: CGPoint(x: -0.05, y: height - 0.01))
        bezierPath.addCurve(to: CGPoint(x: 11.04, y: height - 4.04), controlPoint1: CGPoint(x: 4.07, y: height + 0.43), controlPoint2: CGPoint(x: 8.16, y: height - 1.06))
        bezierPath.addCurve(to: CGPoint(x: 22, y: height), controlPoint1: CGPoint(x: 16, y: height), controlPoint2: CGPoint(x: 19, y: height))
        bezierPath.close()
        return bezierPath
    }
}
