import UIKit

extension UIImage {

    // MARK: - Public methods

    func withSize(_ size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }

        return image.withRenderingMode(renderingMode)
    }

}
