# saveDataDemo	
写在前面,由于苹果公司对CoreData的改动，使得在Xcode8.0和ios10.0以上环境下使用新语法使用CoreData不兼容ios9以下系统，本实例主要简单介绍Swift3.0中CoreData的使用，同时处理了不兼容ios9以下版本系统的问题。
	开发环境：Xcode8.1，iOS10.0
     说明：本实例为swift纯代码编写
下面为实例的主要实现代码
AppDelegate.swift
//
//  AppDelegate.swift
//  saveDataDemo
//
//  Created by pankx on 2016/12/2.
//  Copyright © 2016年 pankx. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame:UIScreen.main.bounds);
        window?.backgroundColor = UIColor.white;
        let nav = UINavigationController(rootViewController: ViewController());
        window?.rootViewController = nav;
        window?.makeKeyAndVisible();
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }

    // MARK: - Core Data stack
    @available(iOS 10.0 , *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "saveDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "saveDataDemo", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support
    @available(iOS 10.0 , *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

ViewController.swift
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

showViewController.swift

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






