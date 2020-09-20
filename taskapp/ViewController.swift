//
//  ViewController.swift
//  taskapp
//
//  Created by 仲井宏紀 on 2020/09/19.
//  Copyright © 2020 hiroki.nakai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    //データの数(=セルの数)を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    //各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    return cell
    }
    
    //各セルを選択したときに実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil) //←追加する
    }
    
    //セルが削除可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) {
    }
    
    //Delete ボタンが押されたときに呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITabelViewCell.EditingStyle, ForRowAt indexPath: IndexPath) {
    }


}

