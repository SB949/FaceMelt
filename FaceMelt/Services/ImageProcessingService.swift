import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

class ImageProcessingService {
    private let context = CIContext()
    
    func applyBlurCircles(to image: UIImage, circles: [BlurCircle]) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        var outputImage = ciImage
        
        for circle in circles {
            let blurFilter = CIFilter.gaussianBlur()
            blurFilter.inputImage = outputImage
            blurFilter.radius = Float(circle.radius * circle.blurIntensity)
            
            // Create a mask for the blur circle
            let maskFilter = CIFilter.radialGradient()
            maskFilter.center = CIVector(x: circle.center.x, y: circle.center.y)
            maskFilter.radius0 = Float(circle.radius * 0.9)
            maskFilter.radius1 = Float(circle.radius)
            maskFilter.color0 = CIColor(red: 1, green: 1, blue: 1, alpha: 1)
            maskFilter.color1 = CIColor(red: 0, green: 0, blue: 0, alpha: 1)
            
            // Apply the blur only within the circle
            let blendFilter = CIFilter.blendWithMask()
            blendFilter.inputImage = blurFilter.outputImage
            blendFilter.backgroundImage = outputImage
            blendFilter.maskImage = maskFilter.outputImage
            
            if let blendedImage = blendFilter.outputImage {
                outputImage = blendedImage
            }
        }
        
        guard let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: outputCGImage)
    }
} 