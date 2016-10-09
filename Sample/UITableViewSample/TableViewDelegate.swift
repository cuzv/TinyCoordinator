//
//  TableViewDelegate.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/14/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit
import TinyCoordinator

open class TableViewDelegate: TCDelegate {
    open func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {        
        return heightForRow(at: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader(in: section)
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeader(in: section)
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooter(in: section)
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooter(in: section)
    }
}
