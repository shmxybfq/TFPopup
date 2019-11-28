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
        let model:MainModel = self.dataSource.object(at: indexPath.row) as! MainModel
        cell?.textLabel?.text = model.title
        cell?.detailTextLabel?.text = model.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:MainModel = self.dataSource.object(at: indexPath.row) as! MainModel
       
        let controller:UIViewController = (model.name?.e_initController())!
    
        self.navigationController?.pushViewController(controller, animated: true)
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
        
        self.dataSource.add(MainModel.init(title: "普通弹框", name: "NormalController0"))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let view = UIButton()
        view.backgroundColor = UIColor.red
        view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300)
        view.tf_showSlide(self.view, direction: PopupDirection.bottom)
    }
}

class MainModel: NSObject {
    
    public init(title:String,name:String) {
        self.title = title
        self.name = name
    }
    
    public var title:String?
    public var  name:String?
}


extension String{
    
     public func e_initController() -> UIViewController{
        guard let spaceName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("获取命名空间失败")
            return UIViewController()
        }
        //self:表示试图控制器的类名
        let controllerClass: AnyClass? = NSClassFromString(spaceName + "." + self)
        //Swift中如果想通过一个Class来创建一个对象,必须告诉系统这个Class的确切类型
        guard let typeClass = controllerClass as? UIViewController.Type else {
            print("vcClass不能当做UIViewController")
            return UIViewController()
        }
        let controller = typeClass.init()
        return controller
    }
}
