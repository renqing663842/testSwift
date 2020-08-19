//
//  ViewController.swift
//  TestSwift
//
//  Created by 任卿 on 2020/8/18.
//  Copyright © 2020 任卿. All rights reserved.
//

import UIKit
let lastResultKey = "lastResultKey"
let historyListKey = "historyListKey"
class ViewController: UIViewController {
    var gcdTimer:DispatchSourceTimer!
    lazy var textShow:UITextView = {
        var textShow:UITextView = UITextView(frame: CGRect.init(x: 10, y: 100, width: UIScreen.main.bounds.size.width-20, height: UIScreen.main.bounds.size.height-100))
        if UserDefaults.standard.string(forKey: lastResultKey) != nil {
            textShow.text = UserDefaults.standard.string(forKey: lastResultKey) ?? ""
        }else{
          textShow.text = "";
        }
        textShow.font = UIFont.systemFont(ofSize: 20)
        textShow.isEditable = false
        return textShow
    }()
    lazy var button:UIButton = {
        var button:UIButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2-100/2, y: 50, width: 100, height: 40))
        button.backgroundColor = UIColor.blue
        button.setTitle("历史记录", for: .normal)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return button
    }()
    var labelIndex:Int = 0
    lazy var historyList:[String] = {
        var historyList:[String] = [];
        if UserDefaults.standard.string(forKey: historyListKey) != nil {
            let tmpString:String = UserDefaults.standard.string(forKey: historyListKey) ?? ""
            let subStrs:[Substring] = tmpString.split(separator: ",");
            var tmpArray:[String] = [];
            for str in subStrs {
                tmpArray.append(String(str))
            }
            historyList.append(contentsOf: tmpArray)
        }
        return historyList;
    }()
    lazy var requestUtils:RequestUtils = {
        var requestUtils:RequestUtils = RequestUtils()
        return requestUtils
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(self.textShow)
        self.view.addSubview(self.button)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(requestData), name: Notification.Name("request"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    @objc func requestData(){
        gcdTimer = DispatchSource.makeTimerSource()
        gcdTimer.schedule(wallDeadline: DispatchWallTime.now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.seconds(0))
        gcdTimer.setEventHandler(handler: { [weak self] in
            print("~~~~~~~~~~~~~~~~~~~~~~~~~~~啦啦啦")
            self?.labelIndex += 1;
            self?.fetchData()
        })
        gcdTimer.resume()
    }
    @objc func buttonClick(){
        let vc:HistoryListViewController = HistoryListViewController()
        let nav:UINavigationController = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func fetchData(){
        self.requestUtils.fetchData { [weak self](result) in
            DispatchQueue.main.async {
                self?.textShow.text = result
                UserDefaults.standard.set(result, forKey: lastResultKey)
                self?.historyList.append(Date().format("'日期 'yyyy-MM-dd '时间' a HH:mm:ssZZZZZ '\n'EEEE"))
                UserDefaults.standard.set(self?.historyList.joined(separator: ","), forKey: historyListKey);
                UserDefaults.standard.synchronize()
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~\(self?.historyList)")
            }
        }
    }

}

extension Date {
    func format(_ dateFormat: String, LocalId: String = "zh_CN") -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: LocalId)
        df.dateFormat = dateFormat
        let str = df.string(from: self)
        return str
    }
}

