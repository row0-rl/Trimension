//
//  DummyThumbnails.swift
//  Trimension
//
//  Created by Shiyuan Liu on 6/14/23.
//

import Foundation

struct ImageModel: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}

let imageDataSet = [
    ImageModel(name: "Thumbnail 1", image: "thumbnail1"),
    ImageModel(name: "Thumbnail 2", image: "thumbnail2"),
    ImageModel(name: "Thumbnail 3", image: "thumbnail3"),
    ImageModel(name: "Thumbnail 4", image: "thumbnail4"),
    ImageModel(name: "Thumbnail 5", image: "thumbnail5"),
    ImageModel(name: "Thumbnail 6", image: "thumbnail6"),
    ImageModel(name: "Thumbnail 7", image: "thumbnail7"),
    ImageModel(name: "Thumbnail 8", image: "thumbnail8"),
]
