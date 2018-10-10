//
//  ChatBubble.swift
//  TestChat
//
//  Created by Sajjad  on 09/10/2018.
//  Copyright © 2018 Sajjad . All rights reserved.
//

import UIKit

class ChatBubble: UITableViewCell,BezierBubbleService {

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
        dataText     = nil
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
        var height      : CGFloat
        var width       : CGFloat
        var bezierPath  : UIBezierPath
        switch mediaType {
        case .image:
            guard let image = imageContent else { return }
            var messageLayer : CAShapeLayer
            (height,width)  = getHeightAndWidth(image)
            bezierPath      = getBezierPath(width: width, height: height)
            messageLayer    = getShapeLayer(bezierPath, width: width, height: height)
            chatImageView   = getBubbleImageView(image, width: width, height: height)
            chatImageView?.layer.mask = messageLayer
            if let chatImageView = chatImageView {
                mainView.addSubview(chatImageView)
                mainView.addConstraint(getConstraint(item: chatImageView, attribute: .top, toItem: mainView))
                mainView.addConstraint(getConstraint(item: chatImageView, attribute: .bottom, toItem: mainView))
            }
        case .text:
            guard let text  = dataText else { return }
            (height,width)  = getHeightAndWidth(text)
            label           = getTextLabel(text, width: width, height: height)
            height         += BUBBLE_Y_PADDING
            width          += BUBBLE_X_PADDING
            bezierPath      = getBezierPath(width: width, height: height)
            messageLayer    = getShapeLayer(bezierPath, width: width, height: height)
            if let messageLayer = messageLayer {
                mainView.layer.addSublayer(messageLayer)
            }
            if let textlabel = label {
                mainView.addSubview(textlabel)
                mainView.addConstraint(getConstraint(item: textlabel, attribute: .top, toItem: mainView))
                mainView.addConstraint(getConstraint(item: textlabel, attribute: .bottom, toItem: mainView))
            }
        }
    }
}


//MARK:- Top Level Getters
extension ChatBubble {
    
    func getHeightAndWidth<T>(_ data: T) -> (CGFloat,CGFloat) {
        var height  : CGFloat
        var width   : CGFloat
        switch mediaType {
        case .text:
            guard let text = data as? String else { return (0,0) }
            height = text.height(withConstrainedWidth: MAX_BUBBLE_WIDTH, font: FONT)
            width = MAX_BUBBLE_WIDTH
            
            if height < MIN_BUBBLE_HEIGHT {
                height = MIN_BUBBLE_HEIGHT
                width = text.width(withConstrainedHeight: height, font: FONT)
            }
        case .image:
            guard let image = data as? UIImage else { return (0,0) }
            let aspectRatio = image.size.width / image.size.height
            if image.size.width < MAX_BUBBLE_WIDTH {
                width = image.size.width
                height = image.size.height
            } else  {
                width = MAX_BUBBLE_WIDTH
                height = width / aspectRatio
                if height > MAX_BUBBLE_HEIGHT {
                    height = MAX_BUBBLE_HEIGHT
                    width = height * aspectRatio
                }
            }
        }
        return (height,width)
    }
    
    func getConstraint(item: Any, attribute: NSLayoutAttribute, toItem: Any?) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .equal, toItem: toItem, attribute: attribute, multiplier: 1, constant: (attribute == .top ? BUBBLE_Y_PADDING/2 : -BUBBLE_Y_PADDING/2))
        constraint.priority = .defaultHigh
        return constraint
    }
}


//MARK:- Helper Methods
extension ChatBubble {
    func getShapeLayer(_ path: UIBezierPath, width: CGFloat, height: CGFloat) -> CAShapeLayer {
        let shapeLayer  = CAShapeLayer()
        shapeLayer.path = path.cgPath
        switch mediaType {
        case .text:
            shapeLayer.frame = chatType == .sender ? CGRect(x: SCREEN_WIDTH - width - BUBBLE_SENDER_SPACE, y:0,
                                                            width: width,
                                                            height: height) : CGRect(x: BUBBLE_SENDER_SPACE, y:2,
                                                                                     width: width,
                                                                                     height: height)
            shapeLayer.fillColor = chatType == .sender ? UIColor.green.cgColor : UIColor.lightGray.cgColor
        case .image:
            shapeLayer.frame = CGRect(x: 0,y:0, width: width, height: height)
        }
        return shapeLayer
    }
    
    func getBubbleImageView(_ image: UIImage, width: CGFloat, height: CGFloat) -> UIImageView {
        let bubbleImageView             = UIImageView(image: image)
        bubbleImageView.frame           = CGRect(x: (chatType == .sender ? SCREEN_WIDTH - width - BUBBLE_SENDER_SPACE : BUBBLE_SENDER_SPACE), y:                0, width: width, height: height)
        bubbleImageView.contentMode     = .scaleAspectFill
        bubbleImageView.clipsToBounds   = true
        return bubbleImageView
    }
    
    func getTextLabel(_ text: String, width: CGFloat, height: CGFloat) -> UILabel {
        let label           =  UILabel()
        label.numberOfLines = 0
        label.font          = FONT
        label.textColor     = .white
        label.textAlignment = chatType == .sender ? .right : .left
        label.text          = text
        label.frame = CGRect(x: chatType == .sender ? (SCREEN_WIDTH - (width + BUBBLE_X_PADDING/2) - BUBBLE_SENDER_SPACE) : (BUBBLE_SENDER_SPACE +    BUBBLE_X_PADDING / 2),y:2,
                             width: width,
                             height: height)
        return label
    }
}
