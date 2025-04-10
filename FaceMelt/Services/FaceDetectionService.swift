import Vision
import UIKit

class FaceDetectionService {
    func detectFaces(in image: UIImage, completion: @escaping ([CGRect]) -> Void) {
        guard let cgImage = image.cgImage else {
            completion([])
            return
        }
        
        let request = VNDetectFaceRectanglesRequest { request, error in
            guard let observations = request.results as? [VNFaceObservation], error == nil else {
                completion([])
                return
            }
            
            let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
            let boundingBoxes = observations.map { observation in
                // Convert normalized coordinates to image coordinates
                let boundingBox = observation.boundingBox
                return CGRect(
                    x: boundingBox.origin.x * imageSize.width,
                    y: (1 - boundingBox.origin.y - boundingBox.height) * imageSize.height,
                    width: boundingBox.width * imageSize.width,
                    height: boundingBox.height * imageSize.height
                )
            }
            
            completion(boundingBoxes)
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
} 