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
        imagePicker.allowsEditing = true
    }
    
    // MARK: - Image Picker functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
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
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func selectImageTapped(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
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
