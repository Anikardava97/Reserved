//
//  ConfirmationBanner.swift
//  Reserved
//
//  Created by Ani's Mac on 20.01.24.
//

import UIKit

final class ConfirmationBanner {
    static func show(in view: UIView, message: String) {
        let bannerView = UIView()
        bannerView.backgroundColor = UIColor.white
        bannerView.layer.cornerRadius = 8
        bannerView.clipsToBounds = true
        
        let screenWidth = view.frame.size.width
        let bannerWidth = screenWidth - 32
        let bannerHeight: CGFloat = 40
        
        bannerView.frame = CGRect(x: 16,
                                  y: view.frame.size.height - bannerHeight - 16,
                                  width: bannerWidth,
                                  height: bannerHeight)
        bannerView.alpha = 0
        
        let checkmarkImageView = UIImageView()
        checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.tintColor = .black
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        messageLabel.textColor = .black
        messageLabel.textAlignment = .left
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bannerView.addSubview(checkmarkImageView)
        bannerView.addSubview(messageLabel)
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            checkmarkImageView.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor, constant: 16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: bannerView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24),
            
            messageLabel.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 6),
            messageLabel.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor),
            messageLabel.topAnchor.constraint(equalTo: bannerView.topAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
        ])
        
        UIView.animate(withDuration: 0.5) {
            bannerView.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.5, animations: {
                bannerView.alpha = 0
            }) { _ in
                bannerView.removeFromSuperview()
            }
        }
    }
}
