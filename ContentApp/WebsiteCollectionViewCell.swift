//
//  WebsiteCollectionViewCell.swift
//  ContentApp
//
//  Created by Rishav Gupta on 17/07/21.
//

import UIKit

class WebsiteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var checkBox: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.dropShadow(color: .gray, opacity: 0.10, offSet: CGSize(width: 1, height: 1), radius: 15, scale: true)
        shadowView.layer.cornerRadius = 15
        
    }

}

extension UIView{
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        //layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = false
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    //MARK:- return view's frame
    func frameExcludingSafeArea(x : CGFloat) -> CGRect {
        let topSafeArea : CGFloat
        let bottomSafeArea : CGFloat
        if #available(iOS 11.0, *) {
            topSafeArea = safeAreaInsets.top
            bottomSafeArea = safeAreaInsets.bottom
        } else {
            topSafeArea = 0.0
            bottomSafeArea = 0.0
        }
        let height = frame.height - (topSafeArea+bottomSafeArea)
        return CGRect(x: x, y: topSafeArea, width: bounds.width, height: height)
    }
    
}
