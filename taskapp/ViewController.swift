//
//  ViewController.swift
//  taskapp
//
//  Created by 仲井宏紀 on 2020/09/19.
//  Copyright © 2020 hiroki.nakai. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications


class ViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let realm = try! Realm()
    
    //DB内のタスクが格納されるリスト。
    //日付の近い順でソート：昇順
    //以降内容をアップデートするとリスト内は自動的に更新される。
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        //検索バーのデリゲート先をselfに設定する
        searchBar.delegate = self
        //何も入力されていなくてもReturnキーを押せるようにする。
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.showsSearchResultsButton = false
        searchBar.placeholder = "カテゴリーを検索"
        searchBar.tintColor = UIColor.gray
    }
    
   
    
    
    //データの数(=セルの数)を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    //各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
         // Cellに値を設定する.
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    //テキスト変更時の呼び出しメソッド
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
         guard !searchText.isEmpty else{
           taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
             tableView.reloadData()
             return
         }
        print("/---------------")
        print(searchText)
        print("---------------/")
        
        let predicate = NSPredicate(format: "category = %@", searchText)
        taskArray = realm.objects(Task.self).filter(predicate)
            
        tableView.reloadData()
    }

    
    //キャンセルボタンが押されたときに呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        searchBar.showsCancelButton = false
        taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
        self.view.endEditing(true)
        searchBar.text = ""
        self.tableView.reloadData()
    }
    
    //テキストフィールド入力開始前に呼ばれる
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        searchBar.showsCancelButton = true
        return true
    }
    
    //各セルを選択したときに実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil) //←追加する
    }
    
    //セルが削除可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    //Delete ボタンが押されたときに呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            // 削除するタスクを取得する
            let task = self.taskArray[indexPath.row]

            // ローカル通知をキャンセルする
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])

            // データベースから削除する
            try! realm.write {
                self.realm.delete(task)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            // 未通知のローカル通知一覧をログ出力
            center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                for request in requests {
                    print("/---------------")
                    print(request)
                    print("---------------/")
                }
        }
    }
    }
    
    // segue で画面遷移する時に呼ばれる
       override func prepare(for segue: UIStoryboardSegue, sender: Any?){
           let inputViewController:InputViewController = segue.destination as! InputViewController

           if segue.identifier == "cellSegue" {
               let indexPath = self.tableView.indexPathForSelectedRow
               inputViewController.task = taskArray[indexPath!.row]
           } else {
               let task = Task()

               let allTasks = realm.objects(Task.self)
               if allTasks.count != 0 {
                   task.id = allTasks.max(ofProperty: "id")! + 1
               }

               inputViewController.task = task
           }

     }
    
    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

}
