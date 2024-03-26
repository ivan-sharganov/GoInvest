import UIKit

extension UIImage {

    // MARK: - Public methods
    
    func withScale(_ scale: CGFloat) -> UIImage {
        let size = CGSize(width: size.width * scale, height: size.height * scale)
        
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }

        return image.withRenderingMode(renderingMode)
    }
    
}
