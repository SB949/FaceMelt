import Foundation
import CoreGraphics

struct BlurCircle: Identifiable {
    let id = UUID()
    var center: CGPoint
    var radius: CGFloat
    var blurIntensity: Double
    
    init(center: CGPoint, radius: CGFloat = 100, blurIntensity: Double = 0.5) {
        self.center = center
        self.radius = radius
        self.blurIntensity = blurIntensity
    }
    
    func contains(_ point: CGPoint) -> Bool {
        let distance = sqrt(pow(point.x - center.x, 2) + pow(point.y - center.y, 2))
        return distance <= radius
    }
} 