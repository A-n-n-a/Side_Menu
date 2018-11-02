//
//  ViewController.swift
//  Side Menu
//
//  Created by Anna on 10/30/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var sideMenuView: UIView!
    var menu: MenuView!

    let screenBounds = UIScreen.main.bounds
    var menuWidth: CGFloat!
    var menuIsOpened = Bool()
    var menuContent = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Main Menu"
        menuWidth = screenBounds.width * 0.7
        menu = MenuView(frame: CGRect(x: screenBounds.maxX, y: 0, width: menuWidth, height: screenBounds.height))
        menu.closeButton.addTarget(self, action: #selector(closeMenu), for: .touchUpInside)
        menu.delegate = self
        fetchMenuData()
        UIApplication.shared.keyWindow?.addSubview(menu)
    }
    
    @objc func closeMenu() {
        UIView.animate(withDuration: 0.5) {
            self.menu.center.x += self.menuWidth
        }
        menuIsOpened = false
    }
    
    func openMenu() {
        UIView.animate(withDuration: 0.5) {
            self.menu.center.x -= self.menuWidth
        }
    }

    @IBAction func menuWasTapped(_ sender: Any) {
        openMenu()
        menuIsOpened = true
    }
    
    func fetchMenuData() {
        
        if let path = Bundle.main.path(forResource: "menu", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String:AnyObject] {
                    parseJson(jsonResult)
                }
            } catch {
                
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func parseJson(_ jsonDictionary: [String:AnyObject]) {

        guard let menu = jsonDictionary["data"] as? [String : AnyObject]    else { return }
        guard let menuItems = menu["data"] as? [[String : AnyObject]]    else { return }
            for menuItem in menuItems {
                guard let itemTitle = menuItem["label"] as? String else { return }
                if let children = menuItem["children"] as? [[String:AnyObject]] {
                    let childrenItems = parseChildren(children)
                    let menuItem = MenuItem(name: itemTitle, children: childrenItems)
                    menuContent.append(menuItem)
                } else {
                    let menuItem = MenuItem(name: itemTitle)
                    menuContent.append(menuItem)
                }
            }
        self.menu.menuContent = menuContent
    }
    
    func parseChildren(_ children: [[String:AnyObject]]) -> [String] {
        var childrenLabels = [String]()
        for child in children {
            if let label = child["label"] as? String {
                childrenLabels.append(label)
            }
        }
        return childrenLabels
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SubMenuViewController {
            vc.subMenuContent = menu.subMenu
        }
    }
}

extension MainMenuViewController: CellTapped {
    func cellGotTapped() {
        closeMenu()
        self.performSegue(withIdentifier: "toSubMenu", sender: self)
    }
}
