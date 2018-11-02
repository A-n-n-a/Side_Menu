//
//  MenuView.swift
//  Side Menu
//
//  Created by Anna on 10/30/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit

class MenuView: UIView {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var menuContent = [MenuItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    var subMenu = [String]()
    var delegate: CellTapped!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initFromNib()
    }
    
    private func initFromNib() {
        let nib =  UINib(nibName: "MenuView", bundle: Bundle(for: type(of: self)))
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        self.tableView.register(UINib(nibName: "MenuCell", bundle: Bundle.main), forCellReuseIdentifier: "MenuCell")
        self.addSubview(view)
    }
}

extension MenuView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        let menuItem = menuContent[indexPath.row]
        cell.name.text = menuItem.name
        if menuItem.children.count > 0 {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let menuItem = menuContent[indexPath.row]
        if(delegate != nil) {
            self.subMenu = menuItem.children
            self.delegate.cellGotTapped()
        }
    }
}

protocol CellTapped: class {
    
    func cellGotTapped()
}
