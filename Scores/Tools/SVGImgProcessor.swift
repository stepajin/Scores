//
//  SVGImgProcessor.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import Kingfisher
import SVGKit

struct SVGImgProcessor: ImageProcessor {
    let identifier = "SVGImgProcessor"
    
    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image
        case .data(let data):
            return SVGKImage(data: data)?.uiImage
        }
    }
}
