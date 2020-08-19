//
//  HistoryListViewController.swift
//  TestSwift
//
//  Created by 任卿 on 2020/8/18.
//  Copyright © 2020 任卿. All rights reserved.
//

import UIKit

class HistoryListViewController: UIViewController {

    @IBOutlet weak var mainTableView:UITableView!
    lazy var historyList:Array<String> = {
        var historyList = Array<String>()
        return historyList
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "历史记录"
        self.configNav()
        self.configTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchHistoryList()
    }
    
    func  configNav(){
        let button:UIButton = UIButton(type: .custom)
        button.setTitle("返回", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.frame = CGRect.init(x: 0, y: 0, width: 84, height: 44)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 15, left: 0, bottom: 15, right: 70)
        button.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
        let negativeSpacer:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -20;
        self.navigationItem.leftBarButtonItems = [negativeSpacer,UIBarButtonItem(customView: button)]
    }
    
    @objc func leftButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func configTableView(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.register(UINib(nibName: "HistoryListCell", bundle: nil), forCellReuseIdentifier: "HistoryListCell")
        self.mainTableView.estimatedRowHeight = 88;
        self.mainTableView.separatorStyle = .none
        self.mainTableView.tableFooterView = UIView()
    }
    
    func fetchHistoryList(){
        if UserDefaults.standard.string(forKey: historyListKey) != nil {
            let tmpString:String = UserDefaults.standard.string(forKey: historyListKey) ?? ""
            let subStrs:[Substring] = tmpString.split(separator: ",");
            var tmpArray:[String] = [];
            for str in subStrs {
                tmpArray.append(String(str))
            }
            historyList.append(contentsOf: tmpArray)
            self.mainTableView.reloadData()
        }
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HistoryListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HistoryListCell = tableView.dequeueReusableCell(withIdentifier: "HistoryListCell", for: indexPath) as! HistoryListCell
        cell.title?.text = self.historyList[indexPath.row]
        return cell
    }
}
