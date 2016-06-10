//
//  FirstTableViewController.swift
//  UIPageViewControllerSample
//
//  Created by sugimon on 2016/06/10.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class FirstTableViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // tableCell の ID で UITableViewCell のインスタンスを生成
        let cell = table.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        return cell
    }


}
