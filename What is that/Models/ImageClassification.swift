//
//  ImageClassification.swift
//  What is that
//
//  Created by André Schäfer on 25.04.21.
//

import UIKit
import CoreML
import Vision

class ImageClassification {
    
    private var topResult: String?
    private var results: [VNClassificationObservation] = []
    
    func detectObject(image : CIImage) {
        
        let configuration = MLModelConfiguration()
        
        guard let model = try? VNCoreMLModel(for: SqueezeNet(configuration: configuration).model) else {
            fatalError("Could not load ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
                fatalError("Unexpected result type")
            }
            
            self.topResult = topResult.identifier
            self.results = results
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try  handler.perform([request])
        } catch  {
            print(error)
        }
    }
    
    func getResults() -> [VNClassificationObservation]{
        return results
    }
    
    func getTopResult() -> String? {
        return topResult
    }
}
