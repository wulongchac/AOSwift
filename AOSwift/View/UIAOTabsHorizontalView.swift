//
//  TabsHorizontalView.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/16.
//  Copyright © 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import UIKit
import AOCocoa
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


@objc protocol UIAOTabsHorizontalViewDataSource{
    func tabsHorizontalViewCellCount(_ tabsHorizontalView : UIAOTabsHorizontalView)->Int
    @objc optional func tabsHorizontalViewCellWidth(_ tabsHorizontalView : UIAOTabsHorizontalView)->CGFloat
    @objc optional func tabsHorizontalViewForCellSelectStyle(_ tabsHorizontalView : UIAOTabsHorizontalView, cell :UIButton,index: Int)
    @objc optional func tabsHorizontalViewForCellUnSelectStyle(_ tabsHorizontalView : UIAOTabsHorizontalView, cell :UIButton,index: Int)
    func tabsHorizontalViewForCell(_ tabsHorizontalView : UIAOTabsHorizontalView,cell : UIButton,index: Int)
    @objc optional func tabsHorizontalViewLineView(_ tabsHorizontalView : UIAOTabsHorizontalView)->UIView
}

@objc protocol UIAOTabsHorizontalViewDelegate{
    @objc optional func tabsHorizontalViewDidSelectedCell(_ tabsHorizontalView : UIAOTabsHorizontalView,index: Int)
    @objc optional func tabsHorizontalViewWillSelectCell(_ tabsHorizontalView : UIAOTabsHorizontalView,index: Int)->Bool
}


class UIAOTabsHorizontalView: UIScrollView {
    var lineView : UIView?
    var tabData :[Dictionary<String,String>] = []
    var allWith :CGFloat = 0
    var tabDelegate : UIAOTabsHorizontalViewDelegate?
    var dataSource : UIAOTabsHorizontalViewDataSource?
    
    var tagStart : Int{
        get{
            return 10100
        }
    }

    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.showsHorizontalScrollIndicator=false
        self.showsVerticalScrollIndicator=false
    }
    
    func reload(didSelected sindex:Int){
        self.backgroundColor = UIColor.clear
        self.clear()
        if self.dataSource == nil {
            return
        }
        var width :CGFloat = 0
        if let tmp = self.dataSource!.tabsHorizontalViewCellWidth?(self){
            width = tmp
        }
        
        for index in 0 ..< self.dataSource!.tabsHorizontalViewCellCount(self){
            let view = UIButton(frame: CGRect(x: allWith,y: 0,width: width,height: frame.height))
            self.dataSource?.tabsHorizontalViewForCell(self, cell: view, index: index)
            view.setTag(tagStart+index)
            view.addTarget(self, action: #selector(UIAOTabsHorizontalView.btnOnClick(_:)), for: UIControl.Event.touchUpInside)
            allWith += view.frame.width
            self.addSubview(view);
        }
        self.contentSize=CGSize(width: allWith, height: frame.height)
        lineView = self.dataSource!.tabsHorizontalViewLineView?(self)
        if lineView != nil{
            self.addSubview(lineView!)
            lineView!.isHidden = true
        }
        if self.dataSource!.tabsHorizontalViewCellCount(self)>0{
            self.selectItem(sindex, isDelegateSelect: false)
        }
    }
    
    func clear(){
        allWith=0;
        for view in self.subviews{
            view.removeFromSuperview()
        }
        tabData.removeAll()
    }
    
    @objc func btnOnClick(_ sender:UIButton){
        self.selectItem(sender.tag()-tagStart, isDelegateSelect: true)
    }
    
    func selectItem(_ index : Int, isDelegateSelect:Bool){
        if let willSelect = self.tabDelegate?.tabsHorizontalViewWillSelectCell?(self, index: index){
            if !willSelect{
                return
            }
        }
        if let count = self.dataSource?.tabsHorizontalViewCellCount(self){
            for i in 0 ..< count{
                let item = self.viewWithTag(tagStart+i) as! UIButton
                if i==index {
                    if lineView != nil {
                        lineView?.isHidden=false
                        lineView?.center=CGPoint(x: item.center.x, y: lineView!.center.y)
                    }
                    //滚动到中心位置
                    self.dataSource?.tabsHorizontalViewForCellSelectStyle?(self,cell:item, index: i )
                    self.setContentOffViewCenter(view: item)
                }else{
                    self.dataSource?.tabsHorizontalViewForCellUnSelectStyle?(self,cell:item, index: i)
                }
            }
        }
        
        if isDelegateSelect {
            tabDelegate?.tabsHorizontalViewDidSelectedCell?(self, index: index)
        }
        
    }

}
