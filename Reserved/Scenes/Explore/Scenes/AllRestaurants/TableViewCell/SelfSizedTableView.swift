//
//  SelfSizedTableView.swift
//  Reserved
//
//  Created by Ani's Mac on 23.01.24.
//

import UIKit

final class SelfSizedTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
