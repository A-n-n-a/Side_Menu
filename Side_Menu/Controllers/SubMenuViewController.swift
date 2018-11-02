//
//  SubMenuViewController.swift
//  Side Menu
//
//  Created by Anna on 11/2/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit

class SubMenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var subMenuContent = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "SubMenu"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.tableView.register(UINib(nibName: "MenuCell", bundle: Bundle.main), forCellReuseIdentifier: "MenuCell")
    }
}


extension SubMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subMenuContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        cell.name.text = subMenuContent[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
