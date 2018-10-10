//
//  ViewController.swift
//  TestChat
//
//  Created by Sajjad  on 09/10/2018.
//  Copyright © 2018 Sajjad . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let dataSource : [String] = ["App Design","App layout - Backend - Responsive design","The purpose of this product specification is to product an app that host text style chat stories similar to Hooked by Telepathic, Yarn by Science Mobile & Tap by Wattpad.","The ranking of series depends on which section we are looking at. For example, the carousel section will mostly likely be a curated list and the order of series is the same for all users. We will change the content and the order of the list manually from time to time. Later we will develop logic on how the series should be ranked, could be a combination of user data, popularity, publishing date and manual curation","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."]
    
    var imageDataScore = ["potrait", "gameBackground", "smallImage"]
    
    
    func setup(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = tableView.frame.height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "ChatBubble", bundle: nil), forCellReuseIdentifier: "ChatBubble")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension ViewController: UITableViewDelegate {
}


extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatBubble") as? ChatBubble else {
            let cell = UITableViewCell()
            cell.backgroundColor = .black
            return cell
        }
        
        if indexPath.row % 2 == 0 {
            cell.setup(dataSource[indexPath.row], messageOrigin: indexPath.row % 4 == 0 ? .sender : .recepient)
        } else {
            cell.setup(UIImage(named: imageDataScore[Int.random() % 3]) ?? UIImage(), messageOrigin: indexPath.row % 3 == 0 ? .recepient : .sender)
        }
        return cell
    }
}




extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension Int {
    static func random() -> Int {
        return Int(arc4random())
    }
}


extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
