//
//  WHC_StackView.swift
//  WHC_Layout
//
//  Created by WHC on 16/7/7.
//  Copyright © 2016年 吴海超. All rights reserved.

//  Github <https://github.com/netyouli/WHC_Layout>

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

fileprivate struct WHC_StackViewAssociatedObjectKey {
    static var kWidthWeight            = "widthWeight"
    static var kHeightWeight           = "heightWeight"
    static var kLeftPadding            = "leftPadding"
    static var kRightPadding           = "rightPadding"
    static var kTopPadding             = "topPadding"
    static var kBottomPadding          = "bottomPadding"
    
    static var kFieldLeftPadding       = "fieldLeftPadding"
    static var kFieldRightPadding      = "fieldRightPadding"
    static var kFieldTopPadding        = "fieldTopPadding"
    static var kFieldBottomPadding     = "fieldBottomPadding"
}

#if os(iOS) || os(tvOS)
    
    extension UITextField {
        open override class func initialize() {
            struct WHC_TextFieldLoad {
                static var token: Int = 0
            }
            if WHC_TextFieldLoad.token == 0 {
                WHC_TextFieldLoad.token = 1
                let editingRectForBounds = class_getInstanceMethod(self, #selector(UITextField.editingRect(forBounds:)))
                let myEditingRectForBounds = class_getInstanceMethod(self, #selector(UITextField.myEditingRectForBounds(_:)))
                method_exchangeImplementations(editingRectForBounds, myEditingRectForBounds)
                
                let textRectForBounds =  class_getInstanceMethod(self, #selector(UITextField.textRect(forBounds:)))
                let myTextRectForBounds =  class_getInstanceMethod(self, #selector(UITextField.myTextRectForBounds(_:)))
                method_exchangeImplementations(textRectForBounds, myTextRectForBounds)
            }
        }
        
        /// 文字左边距
        public var whc_LeftPadding: CGFloat {
            set {
                objc_setAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kFieldLeftPadding, NSNumber(value: Float(newValue) as Float), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            get {
                let value = objc_getAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kFieldLeftPadding)
                if value != nil {
                    return CGFloat((value as! NSNumber).floatValue)
                }
                return 0
            }
        }
        
        /// 文字右边距
        public var whc_RightPadding: CGFloat {
            set {
                objc_setAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kFieldRightPadding, NSNumber(value: Float(newValue) as Float), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            get {
                let value = objc_getAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kFieldRightPadding)
                if value != nil {
                    return CGFloat((value as! NSNumber).floatValue)
                }
                return 0
            }
        }
        
        /// 文字顶边距
        public var whc_TopPadding: CGFloat {
            set {
                objc_setAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kFieldTopPadding, NSNumber(value: Float(newValue) as Float), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            get {
                let value = objc_getAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kFieldTopPadding)
                if value != nil {
                    return CGFloat((value as! NSNumber).floatValue)
                }
                return 0
            }
        }
        
        /// 文字底边距
        public var whc_BottomPadding: CGFloat {
            set {
                objc_setAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kFieldBottomPadding, NSNumber(value: Float(newValue) as Float), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            get {
                let value = objc_getAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kFieldBottomPadding)
                if value != nil {
                    return CGFloat((value as! NSNumber).floatValue)
                }
                return 0
            }
        }
        
        @objc fileprivate func myEditingRectForBounds(_ bounds: CGRect) -> CGRect {
            
            return self.myEditingRectForBounds(CGRect(x: self.whc_LeftPadding, y: self.whc_TopPadding, width: bounds.width - self.whc_LeftPadding - self.whc_RightPadding, height: bounds.height - whc_TopPadding - whc_BottomPadding))
        }
        
        @objc fileprivate func myTextRectForBounds(_ bounds: CGRect) -> CGRect {
            return self.myTextRectForBounds(CGRect(x: self.whc_LeftPadding, y: self.whc_TopPadding, width: bounds.width - self.whc_LeftPadding - self.whc_RightPadding, height: bounds.height - whc_TopPadding - whc_BottomPadding))
        }
        
    }
    
    
    extension UIButton {
        
        fileprivate func calcTextSize() -> CGSize {
            if self.titleLabel?.text != nil {
                let value = (self.titleLabel?.text!)! as NSString
                return value.size(attributes: [NSFontAttributeName: (self.titleLabel?.font)!])
            }
            return CGSize.zero
        }
        
        @discardableResult
        public override func whc_WidthAuto() -> UIView {
            if self.titleEdgeInsets.left + self.titleEdgeInsets.right != 0 {
                return self.whc_Width(calcTextSize().width + self.titleEdgeInsets.left + self.titleEdgeInsets.right + 0.5)
            }
            return super.whc_WidthAuto()
        }
        
        @discardableResult
        public override func whc_HeightAuto() -> UIView {
            if self.titleEdgeInsets.top + self.titleEdgeInsets.bottom != 0 {
                return self.whc_Height(calcTextSize().height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom  + 0.5)
            }
            return super.whc_HeightAuto()
        }
        
    }
    
    extension UILabel {
        
        /// 文字左边距
        public var whc_LeftPadding: CGFloat {
            set {
                objc_setAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kLeftPadding, NSNumber(value: Float(newValue) as Float), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            get {
                let value = objc_getAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kLeftPadding)
                if value != nil {
                    return CGFloat((value as! NSNumber).floatValue)
                }
                return 0
            }
        }
        
        /// 文字右边距
        public var whc_RightPadding: CGFloat {
            set {
                objc_setAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kRightPadding, NSNumber(value: Float(newValue) as Float), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            get {
                let value = objc_getAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kRightPadding)
                if value != nil {
                    return CGFloat((value as! NSNumber).floatValue)
                }
                return 0
            }
        }
        
        /// 文字顶边距
        public var whc_TopPadding: CGFloat {
            set {
                objc_setAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kTopPadding, NSNumber(value: Float(newValue) as Float), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            get {
                let value = objc_getAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kTopPadding)
                if value != nil {
                    return CGFloat((value as! NSNumber).floatValue)
                }
                return 0
            }
        }
        
        /// 文字底边距
        public var whc_BottomPadding: CGFloat {
            set {
                objc_setAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kBottomPadding, NSNumber(value: Float(newValue) as Float), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            get {
                let value = objc_getAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kBottomPadding)
                if value != nil {
                    return CGFloat((value as! NSNumber).floatValue)
                }
                return 0
            }
        }
        
        open override class func initialize() {
            struct WHC_LabelLoad {
                static var token: Int = 0
            }
            if WHC_LabelLoad.token == 0 {
                WHC_LabelLoad.token = 1
                let drawTextInRect = class_getInstanceMethod(self, #selector(UILabel.drawText(in:)))
                let myDrawTextInRect = class_getInstanceMethod(self, #selector(UILabel.myDrawTextInRect(_:)))
                method_exchangeImplementations(drawTextInRect, myDrawTextInRect)
            }
        }
        
        fileprivate func calcTextSize() -> CGSize {
            if self.text != nil {
                let value = self.text! as NSString
                return value.size(attributes: [NSFontAttributeName: self.font])
            }
            return CGSize.zero
        }
        
        @discardableResult
        public override func whc_WidthAuto() -> UIView {
            if whc_LeftPadding + whc_RightPadding != 0 {
                return self.whc_Width(calcTextSize().width + whc_LeftPadding + whc_RightPadding + 1)
            }
            return super.whc_WidthAuto()
        }
        
        @discardableResult
        public override func whc_HeightAuto() -> UIView {
            if whc_TopPadding + whc_BottomPadding != 0 {
                return self.whc_Height(calcTextSize().height + whc_TopPadding + whc_BottomPadding + 1)
            }
            return super.whc_HeightAuto()
        }
        
        @objc fileprivate func myDrawTextInRect(_ rect: CGRect) {
            self.myDrawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(whc_TopPadding, whc_LeftPadding, whc_BottomPadding, whc_RightPadding)))
        }
    }
    
#endif

extension WHC_VIEW {
    /// 宽度权重
    public var whc_WidthWeight: CGFloat {
        set {
            objc_setAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kWidthWeight, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let id = objc_getAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kWidthWeight) as? NSNumber
            if id != nil {
                return CGFloat(id!.floatValue)
            }
            return 1
        }
    }
    
    /// 高度权重
    public var whc_HeightWeight: CGFloat {
        set {
            objc_setAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kHeightWeight, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let id = objc_getAssociatedObject(self, &WHC_StackViewAssociatedObjectKey.kHeightWeight) as? NSNumber
            if id != nil {
                return CGFloat(id!.floatValue)
            }
            return 1
        }
    }
}

public enum WHC_LayoutOrientationOptions {
    /// StackView垂直布局
    case vertical
    /// StackView横向布局
    case horizontal
    /// StackView垂直横向混合布局
    case all
}

public class WHC_StackView: WHC_VIEW {
    fileprivate class WHC_StackViewLineView: WHC_VIEW {}
    fileprivate class WHC_VacntView: WHC_VIEW {}
    
    fileprivate lazy var lastRowVacantCount = 0
    /// 自动高度
    public lazy var autoHeight = false
    /// 自动宽度
    public lazy var autoWidth = false
    
    /// StackView列数
    public lazy var whc_Column = 1
    /// StackView内边距
    #if os(iOS) || os(tvOS)
    public lazy var whc_Edge = UIEdgeInsets.zero
    #else
    public lazy var whc_Edge = NSEdgeInsetsZero
    #endif
    /// StackView子视图横向间隙
    public lazy var whc_HSpace = CGFloat(0)
    /// StackView子视图垂直间隙
    public lazy var whc_VSpace = CGFloat(0)
    /// StackView布局方向
    public lazy var whc_Orientation = WHC_LayoutOrientationOptions.horizontal
    /// StackView子视图个数
    public var whc_SubViewCount: Int {
        if self.whc_Orientation == .all {
            return self.subviews.count - lastRowVacantCount
        }
        return self.subviews.count
    }
    
    /// 子元素高宽比
    public lazy var whc_ElementHeightWidthRatio: CGFloat = 0
    /// 子元素宽高比
    public lazy var whc_ElementWidthHeightRatio: CGFloat = 0
    
    /// 子视图固定宽度
    public lazy var whc_SubViewWidth: CGFloat = 0
    /// 子视图固定高度
    public lazy var whc_SubViewHeight: CGFloat = 0
    /// 设置分割线尺寸
    public lazy var whc_SegmentLineSize: CGFloat = 0
    /// 设置分割线内边距
    public lazy var whc_SegmentLinePadding: CGFloat = 0
    /// 设置分割线的颜色
    public lazy var whc_SegmentLineColor = WHC_COLOR(white: 0.9, alpha: 1.0)
    
    @discardableResult
    public override func whc_WidthAuto() -> WHC_VIEW {
        autoWidth = true
        return super.whc_WidthAuto()
    }
    
    @discardableResult
    public override func whc_HeightAuto() -> WHC_VIEW {
        autoHeight = true
        return super.whc_HeightAuto()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        #if os(iOS) || os(tvOS)
            self.backgroundColor = WHC_COLOR.white
        #else
            self.makeBackingLayer().backgroundColor = WHC_COLOR.white.cgColor
        #endif
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        #if os(iOS) || os(tvOS)
            self.backgroundColor = WHC_COLOR.white
        #else
            self.makeBackingLayer().backgroundColor = WHC_COLOR.white.cgColor
        #endif
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// 开始布局
    public func whc_StartLayout() {
        runStackLayoutEngine()
    }
    
    /// 移除StackView上所有子视图
    public func whc_RemoveAllSubviews() {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
    
    fileprivate func makeLine() -> WHC_StackViewLineView {
        let lineView = WHC_StackViewLineView()
        #if os(iOS) || os(tvOS)
            lineView.backgroundColor = whc_SegmentLineColor
        #else
            lineView.makeBackingLayer().backgroundColor = whc_SegmentLineColor.cgColor
        #endif
        return lineView
    }
    
    fileprivate func removeAllSegmentLine() {
        for subView in self.subviews {
            if subView is WHC_StackViewLineView {
                subView.removeFromSuperview()
            }
        }
    }
    
    /// 布局引擎
    fileprivate func runStackLayoutEngine() {
        var currentSubViews = self.subviews
        var count = currentSubViews.count
        if count == 0 {return}
        var toView: WHC_VIEW!
        switch whc_Orientation {
        case .horizontal: /// 横向布局
            for i in 0 ..< count {
                let view = currentSubViews[i]
                let nextView: WHC_VIEW! = i < count - 1 ? currentSubViews[i + 1] : nil
                if i == 0 {
                    view.whc_Left(whc_Edge.left)
                }else {
                    if whc_SegmentLineSize > 0 {
                        let lineView = makeLine()
                        self.addSubview(lineView)
                        lineView.whc_Top(whc_SegmentLinePadding)
                        lineView.whc_Bottom(whc_SegmentLinePadding)
                        lineView.whc_Left(whc_HSpace / 2.0 , toView: toView)
                        lineView.whc_Width(whc_SegmentLineSize)
                        view.whc_Left(whc_HSpace / 2.0, toView: lineView)
                    }else {
                        view.whc_Left(whc_HSpace, toView: toView)
                    }
                }
                view.whc_Top(whc_Edge.top)
                if nextView != nil {
                    if whc_SubViewWidth > 0 {
                        view.whc_Width(whc_SubViewWidth)
                    }else {
                        if whc_ElementWidthHeightRatio > 0 {
                            view.whc_WidthHeightRatio(whc_ElementWidthHeightRatio)
                        }else {
                            if autoWidth {
                                view.whc_WidthAuto()
                            }else {
                                view.whc_WidthEqual(nextView, ratio: view.whc_WidthWeight / nextView.whc_WidthWeight)
                            }
                        }
                    }
                    if whc_SubViewHeight > 0 {
                        view.whc_Height(whc_SubViewHeight)
                    }else {
                        if whc_ElementHeightWidthRatio > 0 {
                            view.whc_HeightWidthRatio(whc_ElementHeightWidthRatio)
                        }else {
                            if autoHeight {
                                view.whc_HeightAuto()
                            }else {
                                view.whc_Bottom(whc_Edge.bottom)
                            }
                        }
                    }
                }else {
                    if whc_SubViewWidth > 0 {
                        view.whc_Width(whc_SubViewWidth)
                        if autoWidth {
                            view.whc_Right(whc_Edge.right)
                        }
                    }else {
                        if whc_ElementWidthHeightRatio > 0 {
                            view.whc_WidthHeightRatio(whc_ElementWidthHeightRatio)
                            if autoWidth {
                                view.whc_Right(whc_Edge.right)
                            }
                        }else {
                            if autoWidth {
                                view.whc_WidthAuto()
                            }
                            view.whc_Right(whc_Edge.right)
                        }
                    }
                    if whc_SubViewHeight > 0 {
                        view.whc_Height(whc_SubViewHeight)
                        if autoHeight {
                            view.whc_Bottom(whc_Edge.bottom)
                        }
                    }else {
                        if whc_ElementHeightWidthRatio > 0 {
                            view.whc_HeightWidthRatio(whc_ElementHeightWidthRatio)
                            if autoHeight {
                                view.whc_Bottom(whc_Edge.bottom)
                            }
                        }else {
                            if autoHeight {
                                view.whc_HeightAuto()
                            }
                            view.whc_Bottom(whc_Edge.bottom)
                        }
                    }
                }
                toView = view;
                if toView is WHC_StackView {
                    (toView as! WHC_StackView).whc_StartLayout()
                }
            }
        case .vertical: /// 垂直布局
            for i in 0 ..< count {
                let view = currentSubViews[i];
                let nextView: WHC_VIEW! = i < count - 1 ? currentSubViews[i + 1] : nil;
                if i == 0 {
                    view.whc_Top(whc_Edge.top)
                }else {
                    if whc_SegmentLineSize > 0.0 {
                        let lineView = makeLine()
                        self.addSubview(lineView)
                        lineView.whc_Left(whc_SegmentLinePadding)
                        lineView.whc_Right(whc_SegmentLinePadding)
                        lineView.whc_Height(whc_SegmentLineSize)
                        lineView.whc_Top(whc_VSpace / 2.0 , toView:toView)
                        view.whc_Top(whc_VSpace / 2.0 , toView:lineView)
                    }else {
                        view.whc_Top(whc_VSpace ,toView:toView)
                    }
                }
                view.whc_Left(whc_Edge.left)
                if nextView != nil {
                    if whc_SubViewWidth > 0 {
                        view.whc_Width(whc_SubViewWidth)
                    }else {
                        if whc_ElementWidthHeightRatio > 0 {
                            view.whc_WidthHeightRatio(whc_ElementWidthHeightRatio)
                        }else {
                            if autoWidth {
                                view.whc_WidthAuto()
                            }else {
                                view.whc_Right(whc_Edge.right)
                            }
                        }
                    }
                    if whc_SubViewHeight > 0 {
                        view.whc_Height(whc_SubViewHeight)
                    }else {
                        if whc_ElementHeightWidthRatio > 0 {
                            view.whc_HeightWidthRatio(whc_ElementHeightWidthRatio)
                        }else {
                            if autoHeight {
                                view.whc_HeightAuto()
                            }else {
                                view.whc_HeightEqual(nextView, ratio: view.whc_HeightWeight / nextView.whc_HeightWeight)
                            }
                        }
                    }
                }else {
                    if whc_SubViewWidth > 0 {
                        view.whc_Width(whc_SubViewWidth)
                        if autoWidth {
                            view.whc_Right(whc_Edge.right)
                        }
                    }else {
                        if whc_ElementWidthHeightRatio > 0 {
                            view.whc_WidthHeightRatio(whc_ElementWidthHeightRatio)
                            if autoWidth {
                                view.whc_Right(whc_Edge.right)
                            }
                        }else {
                            if autoWidth {
                                view.whc_WidthAuto()
                            }
                            view.whc_Right(whc_Edge.right)
                        }
                    }
                    if whc_SubViewHeight > 0 {
                        view.whc_Height(whc_SubViewHeight)
                        if autoHeight {
                            view.whc_Bottom(whc_Edge.bottom)
                        }
                    }else {
                        if whc_ElementHeightWidthRatio > 0 {
                            view.whc_HeightWidthRatio(whc_ElementHeightWidthRatio)
                            if autoHeight {
                                view.whc_Bottom(whc_Edge.bottom)
                            }
                        }else {
                            if autoHeight {
                                view.whc_HeightAuto()
                            }
                            view.whc_Bottom(whc_Edge.bottom)
                        }
                    }
                }
                toView = view;
                if toView is WHC_StackView {
                    (toView as! WHC_StackView).whc_StartLayout()
                }
            }
        case .all: // 横向垂直很混布局
            for view in self.subviews {
                if view is WHC_VacntView {
                    view.removeFromSuperview()
                }
            }
            currentSubViews = self.subviews;
            count = currentSubViews.count;
            let rowCount = count / self.whc_Column + (count % self.whc_Column == 0 ? 0 : 1);
            var index = 0;
            lastRowVacantCount = rowCount * whc_Column - count;
            for _ in 0 ..< lastRowVacantCount {
                let view = WHC_VacntView()
                #if os(iOS) || os(tvOS)
                    view.backgroundColor = WHC_COLOR.clear
                #else
                    view.makeBackingLayer().backgroundColor = WHC_COLOR.clear.cgColor
                #endif
                self.addSubview(view)
            }
            if lastRowVacantCount > 0 {
                currentSubViews = self.subviews
                count = currentSubViews.count
            }
            var frontRowView: WHC_VIEW!
            var frontColumnView: WHC_VIEW!
            
            var columnLineView: WHC_StackViewLineView!
            for row in 0 ..< rowCount {
                var nextRowView: WHC_VIEW!
                let rowView = currentSubViews[row * self.whc_Column]
                let nextRow = (row + 1) * self.whc_Column
                if nextRow < count {
                    nextRowView = currentSubViews[nextRow]
                }
                var rowLineView: WHC_StackViewLineView!
                if whc_SegmentLineSize > 0.0 && row > 0 {
                    rowLineView = makeLine()
                    self.addSubview(rowLineView)
                    rowLineView.whc_Left(whc_SegmentLinePadding)
                    rowLineView.whc_Right(whc_SegmentLinePadding)
                    rowLineView.whc_Height(whc_SegmentLineSize)
                    rowLineView.whc_Top(whc_VSpace / 2.0 , toView:frontRowView)
                }
                for column in 0 ..< whc_Column {
                    index = row * self.whc_Column + column
                    let view  = currentSubViews[index]
                    var nextColumnView: WHC_VIEW!
                    if column > 0 && whc_SegmentLineSize > 0.0 {
                        columnLineView = makeLine()
                        self.addSubview(columnLineView)
                        columnLineView.whc_Left(whc_HSpace / 2.0 ,toView:frontColumnView)
                        columnLineView.whc_Top(whc_SegmentLinePadding)
                        columnLineView.whc_Bottom(whc_SegmentLinePadding)
                        columnLineView.whc_Width(whc_SegmentLineSize)
                    }
                    if column < self.whc_Column - 1 && index < count {
                        nextColumnView = currentSubViews[index + 1]
                    }
                    if row == 0 {
                        view.whc_Top(whc_Edge.top)
                    }else {
                        if rowLineView != nil {
                            view.whc_Top(whc_VSpace / 2.0, toView:rowLineView)
                        }else {
                            view.whc_Top(whc_VSpace , toView:frontRowView)
                        }
                    }
                    if column == 0 {
                        view.whc_Left(whc_Edge.left)
                    }else {
                        if columnLineView != nil {
                            view.whc_Left(whc_HSpace / 2.0, toView:columnLineView)
                        }else {
                            view.whc_Left(whc_HSpace , toView:frontColumnView)
                        }
                        
                    }
                    if nextRowView != nil {
                        if whc_SubViewHeight > 0 {
                            view.whc_Height(whc_SubViewHeight)
                        }else {
                            if whc_ElementHeightWidthRatio > 0 {
                                view.whc_HeightWidthRatio(whc_ElementHeightWidthRatio)
                            }else {
                                if autoHeight {
                                    view.whc_HeightAuto()
                                }else {
                                    view.whc_HeightEqual(nextRowView ,
                                                         ratio:view.whc_HeightWeight / nextRowView.whc_HeightWeight)
                                }
                            }
                        }
                    }else {
                        if whc_SubViewHeight > 0 {
                            view.whc_Height(whc_SubViewHeight)
                        }else {
                            if whc_ElementHeightWidthRatio > 0 {
                                view.whc_HeightWidthRatio(whc_ElementHeightWidthRatio)
                            }else {
                                if autoHeight {
                                    view.whc_HeightAuto()
                                }else {
                                    view.whc_Bottom(whc_Edge.bottom)
                                }
                            }
                        }
                    }
                    if nextColumnView != nil {
                        if whc_SubViewWidth > 0 {
                            view.whc_Width(whc_SubViewWidth)
                        }else {
                            if whc_ElementWidthHeightRatio > 0 {
                                view.whc_WidthHeightRatio(whc_ElementWidthHeightRatio)
                            }else {
                                if autoWidth {
                                    view.whc_WidthAuto()
                                }else {
                                    view.whc_WidthEqual(nextColumnView ,
                                                        ratio:view.whc_WidthWeight / nextColumnView.whc_WidthWeight)
                                }
                            }
                        }
                    }else {
                        if whc_SubViewWidth > 0 {
                            view.whc_Width(whc_SubViewWidth)
                        }else {
                            if whc_ElementWidthHeightRatio > 0 {
                                view.whc_WidthHeightRatio(whc_ElementWidthHeightRatio)
                            }else {
                                if autoWidth {
                                    view.whc_WidthAuto()
                                }else {
                                    view.whc_Right(whc_Edge.right)
                                }
                            }
                        }
                    }
                    frontColumnView = view
                    if frontColumnView is WHC_StackView {
                        (frontColumnView as! WHC_StackView).whc_StartLayout()
                    }
                }
                frontRowView = rowView;
            }
            if autoWidth {
                #if os(iOS) || os(tvOS)
                    self.layoutIfNeeded()
                #else
                    self.makeBackingLayer().layoutIfNeeded()
                #endif
                var rowLastColumnViewMaxX: CGFloat = 0
                var rowLastColumnViewMaxXView: WHC_VIEW!
                for r in 1 ... rowCount {
                    let index = r * whc_Column - 1
                    let maxWidthView = subviews[index]
                    #if os(iOS) || os(tvOS)
                        maxWidthView.layoutIfNeeded()
                    #else
                        maxWidthView.makeBackingLayer().layoutIfNeeded()
                    #endif
                    if maxWidthView.whc_maxX > rowLastColumnViewMaxX {
                        rowLastColumnViewMaxX = maxWidthView.whc_maxX
                        rowLastColumnViewMaxXView = maxWidthView
                    }
                }
                rowLastColumnViewMaxXView.whc_Right(whc_Edge.right)
            }
            
            if autoHeight {
                #if os(iOS) || os(tvOS)
                    self.layoutIfNeeded()
                #else
                    self.makeBackingLayer().layoutIfNeeded()
                #endif
                var columnLastRowViewMaxY: CGFloat = 0
                var columnLastRowViewMaxYView: WHC_VIEW!
                for r in 1 ... rowCount {
                    let index = r * whc_Column - 1
                    let maxHeightView = subviews[index]
                    #if os(iOS) || os(tvOS)
                        maxHeightView.layoutIfNeeded()
                    #else
                        maxHeightView.makeBackingLayer().layoutIfNeeded()
                    #endif
                    if maxHeightView.whc_maxY > columnLastRowViewMaxY {
                        columnLastRowViewMaxY = maxHeightView.whc_maxY
                        columnLastRowViewMaxYView = maxHeightView
                    }
                }
                columnLastRowViewMaxYView.whc_Bottom(whc_Edge.bottom)
            }
        }
    }
}
