//
//  ResultViewController.swift
//  What is that
//
//  Created by André Schäfer on 19.04.21.
//

import UIKit


class ResultViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    var resultImage: UIImage?
    var resultTitle: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = resultTitle {
            navigationItem.title =  title
        }
        
        if let image = resultImage {
            imageView.image = image
        }
    }
    
}
