//
//  ListViewRefresh.swift
//  HongyuanProperty
//
//  Created by 刘洪彬 on 2019/1/19.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

class UIAOListViewRefresh: UIAOListView {
    private var isRefresh = true;
    fileprivate var refreshOperate :(_ page :Int ,_ pageSize :Int)->() = {page,pageSize in }
    fileprivate var moreOperate:(_ page :Int ,_ pageSize :Int)->() = {page,pageSize in }
    
    func setRefreshOperate(_ opt : @escaping (_ page :Int ,_ pageSize :Int)->()){
        self.refreshOperate=opt
    }
    
    func setMoreOperate(_ opt : @escaping (_ page :Int ,_ pageSize :Int)->()){
        self.moreOperate=opt
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let options = PullToRefreshOption()
        options.backgroundColor = UIColor.white
        self.listView.addPullToRefresh(options, refreshCompletion: { [weak self] in
            if(self?.isRefresh ?? true){
                return;
            }
            self?.isRefresh = true;
            self?.rows.removeAll()
            self?.page=1
            self?.refreshOperate(self!.page,self!.pageSize)
            self?.isRefresh = false
        })
        
        let moreOptions = PullToMoreOption()
         moreOptions.backgroundColor = UIColor.white
        self.listView.addPullToMore(moreOptions) { [weak self] in
            self?.page  = self?.page ?? 0 + 1
            self?.refreshOperate(self!.page,self!.pageSize)
        }
        
    }
    
    

}
