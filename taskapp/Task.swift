//
//  Task.swift
//  taskapp
//
//  Created by 仲井宏紀 on 2020/09/20.
//  Copyright © 2020 hiroki.nakai. All rights reserved.
//
import RealmSwift

class Task: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0

    // タイトル
    @objc dynamic var title = ""

    // 内容
    @objc dynamic var contents = ""

    // 日時
    @objc dynamic var date = Date()
    
    //カテゴリー
    @objc dynamic var category = ""

    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
