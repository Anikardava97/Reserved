//
//  CustomAnnotationView.swift
//  Reserved
//
//  Created by Ani's Mac on 04.02.24.
//

import MapKit

final class CustomAnnotationView: MKAnnotationView {
    // MARK: - Init
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.image = UIImage(systemName: "fork.knife.circle.fill")
        self.frame.size = CGSize(width: 32, height: 32)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
