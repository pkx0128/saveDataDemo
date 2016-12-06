//
//  ViewController.swift
//  saveDataDemo
//
//  Created by pankx on 2016/12/2.
//  Copyright © 2016年 pankx. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITextFieldDelegate{
    var mycontext : NSManagedObjectContext!;
    var  mynum , myname , myage : UITextField!;

    override func viewDidLoad() {
        if #available(iOS 10.0, *) {
            mycontext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
        } else {
            print("IOS9");
            mycontext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
        super.viewDidLoad()
        self.title = "首页";
        let rightButton = UIBarButtonItem(title: "显示", style: .plain, target: self, action: #selector(showData));
        navigationItem.rightBarButtonItem = rightButton;
        
        //屏幕大小
        let fullsize = UIScreen.main.bounds.size;
        //学号
        mynum = UITextField(frame: CGRect(x: 0, y: 0, width: fullsize.width, height: 40));
        mynum.center = CGPoint(x: fullsize.width * 0.5, y: fullsize.height * 0.3);
        mynum.placeholder = "请入学号";
        mynum.textAlignment = .center;
        mynum.keyboardType = .numberPad;
        mynum.clearButtonMode = .whileEditing
        mynum.delegate = self;
        self.view.addSubview(mynum);
        //姓名
        myname = UITextField(frame: CGRect(x: 0, y: 0, width: fullsize.width, height: 40));
        myname.center = CGPoint(x: fullsize.width * 0.5, y: fullsize.height * 0.35);
        myname.placeholder = "请输入名字";
        myname.textAlignment = .center;
        myname.keyboardType = .default;
        myname.clearButtonMode = .whileEditing;
        myname.delegate = self;
        self.view.addSubview(myname);
        //年龄
        myage = UITextField(frame: CGRect(x: 0, y: 0, width: fullsize.width, height: 40));
        myage.center = CGPoint(x: fullsize.width * 0.5, y: fullsize.height * 0.4);
        myage.placeholder = "请输入年龄";
        myage.textAlignment = .center;
        myage.keyboardType = .numberPad;
        myage.clearButtonMode = .whileEditing;
        myage.delegate = self;
        self.view.addSubview(myage);
        //保存数据按钮
        let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 40));
        myButton.center = CGPoint(x: fullsize.width * 0.5, y: fullsize.height * 0.5);
        myButton.setTitle("新增", for: .normal);
        myButton.backgroundColor = UIColor.blue;
        myButton.alpha = 0.5;
        myButton.addTarget(self, action: #selector(SavaDataToCoredata), for: .touchUpInside);
        self.view.addSubview(myButton);
        
        //删除CoreData中的数据
        let myButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 40));
        myButton2.center = CGPoint(x: fullsize.width * 0.5, y: fullsize.height * 0.6);
        myButton2.setTitle("删除", for: .normal);
        myButton2.backgroundColor = UIColor.blue;
        myButton2.alpha = 0.5;
        myButton2.addTarget(self, action: #selector(delCoreData), for: .touchUpInside);
        self.view.addSubview(myButton2);
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(G:)));
        self.view.addGestureRecognizer(tap);
        
        

    }
    func showData(){
        navigationController?.pushViewController(showViewController(), animated: true);
    }
    
    //隐藏键盘
    func tap(G:UITapGestureRecognizer) {
        self.view.endEditing(true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return true;
    }
    
    //保存数据到CoreData
    func SavaDataToCoredata(){
        do{
            let inserInfo = NSEntityDescription.insertNewObject(forEntityName: "MyStudents", into: mycontext);
            if(mynum.text != "" && myname.text != "" && myage.text != ""){
                inserInfo.setValue(Int(mynum.text!), forKey: "num");
                inserInfo.setValue("\(myname.text!)", forKey: "name");
                inserInfo.setValue(Int(myage.text!), forKey: "age");
                try mycontext.save()
                mynum.text = "";
                myname.text = "";
                myage.text = "";
                let myAlert = UIAlertController(title: "提示", message: "保存成功", preferredStyle: .alert);
                let myokAction = UIAlertAction(title: "确定", style: .default, handler: nil);
                myAlert.addAction(myokAction);
                self.present(myAlert, animated: true, completion: nil);
                
            }else{
                let myAlert = UIAlertController(title: "提示", message: "请输入完整的信息", preferredStyle: .alert);
                let myOkAction = UIAlertAction(title: "确定", style: .default, handler: nil);
                myAlert.addAction(myOkAction);
                self.present(myAlert, animated: true, completion: nil);
                
            }
            
        }catch{
            fatalError();
        }
    }
    //清除coreData中的数据
    func delCoreData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyStudents");
        do{
            let rels = try mycontext.fetch(request) as! [NSManagedObject];
            for rel in rels{
                mycontext.delete(rel);
            }
            try mycontext.save();
            let myAlert = UIAlertController(title: "提示", message: "清空数据库成功", preferredStyle: .alert);
            let myOkAction = UIAlertAction(title: "确定", style: .default, handler: nil);
            myAlert.addAction(myOkAction);
            present(myAlert, animated: true, completion: nil);
        }catch{
            fatalError();
        }
        
    }
    


}

