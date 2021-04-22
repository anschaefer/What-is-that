//
//  ResultViewController.swift
//  What is that
//
//  Created by André Schäfer on 19.04.21.
//

import UIKit
import Vision


class ResultViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource {

    // MARK: -- Outlets
    @IBOutlet weak var imageView: UIImageView!
   
    // MARK: --Properties
    var resultImage: UIImage?
    var resultTitle: String?
    var classificationResults: [VNClassificationObservation]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = resultTitle {
            navigationItem.title =  title
        }
        
        if let image = resultImage {
            imageView.image = image
        }
    }
    
    // MARK: -- Table View Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classificationResults?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        let result = classificationResults![indexPath.row]
        
        cell.textLabel?.text = result.identifier
        
        return cell
    }
    
}
