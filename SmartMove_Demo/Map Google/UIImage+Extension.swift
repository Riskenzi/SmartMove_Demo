//
//  UIImage+Extension.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 27.09.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import UIKit
extension CGPoint {
    func rotated(around origin: CGPoint, byDegrees: CGFloat) -> CGPoint {
        let dx = self.x - origin.x
        let dy = self.y - origin.y
        let radius = sqrt(dx * dx + dy * dy)
        let azimuth = atan2(dy, dx) // in radians
        let newAzimuth = azimuth + (byDegrees * CGFloat.pi / 180.0) // convert it to radians
        let x = origin.x + radius * cos(newAzimuth)
        let y = origin.y + radius * sin(newAzimuth)
        return CGPoint(x: x, y: y)
    }
}
class ColorFilter: CIFilter {
    var inputImage: CIImage?
    var inputColor: CIColor?
    private let kernel: CIColorKernel = {
        let kernelString =
        """
        kernel vec4 colorize(__sample pixel, vec4 color) {
            pixel.rgb = pixel.a * color.rgb;
            pixel.a *= color.a;
            return pixel;
        }
        """
        return CIColorKernel(source: kernelString)!
    }()

    override var outputImage: CIImage? {
        guard let inputImage = inputImage, let inputColor = inputColor else { return nil }
        let inputs = [inputImage, inputColor] as [Any]
        return kernel.apply(extent: inputImage.extent, arguments: inputs)
    }
}

extension UIImage {
    func colorized(with color: UIColor) -> UIImage {
        guard let cgInput = self.cgImage else {
            return self
        }
        let colorFilter = ColorFilter()
        colorFilter.inputImage = CIImage(cgImage: cgInput)
        colorFilter.inputColor = CIColor(color: color)

        if let ciOutputImage = colorFilter.outputImage {
            let context = CIContext(options: nil)
            let cgImg = context.createCGImage(ciOutputImage, from: ciOutputImage.extent)
            return UIImage(cgImage: cgImg!, scale: self.scale, orientation: self.imageOrientation).withRenderingMode(self.renderingMode)
        } else {
            return self
        }
    }
}
extension UIImage {
    func stroked(with color: UIColor, size: CGFloat) -> UIImage {
        let strokeImage = self.colorized(with: color)
        let oldRect = CGRect(x: size, y: size, width: self.size.width, height: self.size.height).integral
        let newSize = CGSize(width: self.size.width + (2*size), height: self.size.height + (2*size))
        let translationVector = CGPoint(x: size, y: 0)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.interpolationQuality = .high

            let step = 10 // reduce the step to increase quality
            for angle in stride(from: 0, to: 360, by: step) {
                let vector = translationVector.rotated(around: .zero, byDegrees: CGFloat(angle))
                let transform = CGAffineTransform(translationX: vector.x, y: vector.y)
                context.concatenate(transform)
                context.draw(strokeImage.cgImage!, in: oldRect)
                let resetTransform = CGAffineTransform(translationX: -vector.x, y: -vector.y)
                context.concatenate(resetTransform)
            }
            context.draw(self.cgImage!, in: oldRect)

            let newImage = UIImage(cgImage: context.makeImage()!, scale: self.scale, orientation: self.imageOrientation)
            UIGraphicsEndImageContext()

            return newImage.withRenderingMode(self.renderingMode)
        }
        UIGraphicsEndImageContext()
        return self
    }
}
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}
extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}
