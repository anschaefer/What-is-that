//
//  ViewController.swift
//  What is that
//
//  Created by André Schäfer on 09.04.21.
//

import UIKit

class SelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var selectPictureButton: UIButton!
    
    private var classification = ImageClassification()
    private var resultVire = ResultViewController()
    private let imagePicker = UIImagePickerController()
    private var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .small)
        
        let cameraSymbol = UIImage(systemName: "camera", withConfiguration: buttonConfig)
        let pictureSymbol = UIImage(systemName: "photo", withConfiguration: buttonConfig)
        
        cameraButton.setImage(cameraSymbol, for: .normal)
        selectPictureButton.setImage(pictureSymbol, for: .normal)
    }
    
    // MARK: - Image Picker functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            
            guard let ciImage = CIImage(image: image) else {
                fatalError("couldn't convert uiimage to CIImage")
            }
            classification.detectObject(image: ciImage)
            
            imagePicker.dismiss(animated: true) {
                self.performSegue(withIdentifier: "goToResult", sender: self)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func cameraTapped(_ sender: UIButton) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func selectImageTapped(_ sender: UIButton) {
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            if let destinationVc = segue.destination as? ResultViewController {
                destinationVc.resultImage = selectedImage
                destinationVc.classificationResults = classification.getResults()
            }
        }
    }
}
