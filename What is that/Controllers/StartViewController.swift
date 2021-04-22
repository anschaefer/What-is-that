//
//  ViewController.swift
//  What is that
//
//  Created by André Schäfer on 09.04.21.
//

import UIKit
import CoreML
import Vision

class StartViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: -- Outles
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var selectPictureButton: UIButton!
    
    
    // MARK: -- Properties
    private let imagePicker = UIImagePickerController()
    private var resultView = ResultViewController();
    private var classificationResults: [VNClassificationObservation] = []
    private var resultImage: UIImage?
    private var resultTitle: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .medium)
        
        let cameraSymbol = UIImage(systemName: "camera", withConfiguration: buttonConfig)
        let pictureSymbol = UIImage(systemName: "photo", withConfiguration: buttonConfig)
        
        cameraButton.setImage(cameraSymbol, for: .normal)
        selectPictureButton.setImage(pictureSymbol, for: .normal)
    }
    
    private func detectObject(image : CIImage) {
        
        let configuration = MLModelConfiguration()
        
        guard let model = try? VNCoreMLModel(for: SqueezeNet(configuration: configuration).model) else {
            fatalError("Could not load ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
                fatalError("Unexpected result type")
            }
            
            self.resultTitle = topResult.identifier
            self.classificationResults = results
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try  handler.perform([request])
        } catch  {
            print(error)
        }
    }
    
    // MARK: - Image Picker functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            resultImage = image
            
            guard let ciImage = CIImage(image: image) else {
                fatalError("couldn't convert uiimage to CIImage")
            }
            detectObject(image: ciImage)
            
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
                destinationVc.resultTitle = resultTitle
                destinationVc.resultImage = resultImage
                destinationVc.classificationResults = classificationResults
            }
        }
    }
}
