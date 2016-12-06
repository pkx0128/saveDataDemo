//
//  showViewController.swift
//  saveDataDemo
//
//  Created by pankx on 2016/12/3.
//  Copyright © 2016年 pankx. All rights reserved.
//

import UIKit;
import CoreData;

class showViewController: UIViewController {
    let fullsize = UIScreen.main.bounds.size;
    let myEntity = "Students";
    var myContext : NSManagedObjectContext!;
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyStudents");
    var myTextView : UITextView!;
    override func viewDidLoad() {
        if #available(iOS 10.0, *) {
            myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
        } else {
            myContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
        super.viewDidLoad()

        self.title = "显示数据";
        self.view.backgroundColor = UIColor.white;
        
        myTextView = UITextView(frame: CGRect(x: 0, y: 0, width: fullsize.width, height: fullsize.height));
        myTextView.center = CGPoint(x: fullsize.width * 0.5, y: fullsize.height * 0.5);
        myTextView.textAlignment = .left;
        myTextView.textColor = UIColor.red;
        myTextView.isEditable = false;
        self.view.addSubview(myTextView);
        show();
    }
    
    func show(){
        do{
            let rels = try myContext.fetch(request) as! [NSManagedObject];
            var re = "";
            for rel in rels {
                if rel.value(forKey: "name") != nil{
                    re += "\n学号：000\(rel.value(forKey: "num")!)\n" + "姓名： \(rel.value(forKey: "name")!)\n" + "年龄： \(rel.value(forKey: "age")!)\n";
                }
            }
            if re != ""{
                myTextView.text = re;
            }else{
                myTextView.text = "未找到相关数据！";
                myTextView.textColor = UIColor.red;
            }
        }catch{
            fatalError();
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
