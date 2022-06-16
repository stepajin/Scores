//
//  Image+Kingfisher.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import Kingfisher
import UIKit
import SwiftUI

extension UIImageView {
    func setImage(url: URL?) {
        guard let url = url else {
            image = nil
            return
        }
        if url.pathExtension == "svg" {
            kf.setImage(with: url, options: [.processor(SVGImgProcessor())])
        } else {
            kf.setImage(with: url)
        }
    }
}

typealias SVGImage = KFImage
extension SVGImage {
    init(svgUrl url: URL?) {
        if url?.pathExtension == "svg" {
            self = KFImage(url).setProcessor(SVGImgProcessor())
        } else {
            self = KFImage(url)
        }
    }
}
