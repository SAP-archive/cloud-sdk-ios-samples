//
//  ViewController.swift
//
//  Copyright © 2019 SAP SE or an SAP affiliate company. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dummyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.view.backgroundColor = UIColor.white
        dummyView = LeakingObservingView()
        self.view.addSubview(dummyView)
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        dummyView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        dummyView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
        dummyView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        dummyView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
    }
    
}
