//
//  MainController.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/11/28.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit
import TFPopup
import SnapKit

class MainController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var tableView:UITableView?
    let dataSource:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itTableView()
        self.itDataSource()
        self.tableView?.reloadData();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId:String = "UITableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellId);
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        }
        cell?.textLabel?.text = self.dataSource.object(at: indexPath.row) as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func itTableView(){
        self.tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.separatorStyle = UITableViewCell.SeparatorStyle.singleLine

        self.view.addSubview(self.tableView!)
        self.tableView?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.view)
            make.left.bottom.right.equalToSuperview()
        })
    }
    
    @objc func itDataSource(){
        self.dataSource.add("0")
        self.dataSource.add("1")
        self.dataSource.add("2")
        self.dataSource.add("3")
        self.dataSource.add("4")
        self.dataSource.add("5")
        self.dataSource.add("6")
        self.dataSource.add("7")
        self.dataSource.add("8")
        self.dataSource.add("9")
        self.dataSource.add("10")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let view = UIButton()
        view.backgroundColor = UIColor.red
        view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300)
        view.tf_showSlide(self.view, direction: PopupDirection.bottom)
    }
}

