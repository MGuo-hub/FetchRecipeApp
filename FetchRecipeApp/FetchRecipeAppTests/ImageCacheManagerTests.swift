//
//  ImageCacheManagerTests.swift
//  FetchRecipeAppTests
//
//  Created by Tinghe Guo on 12/10/24.
//

import XCTest
@testable import FetchRecipeApp
import UIKit

final class ImageCacheManagerTests: XCTestCase {
    var imageCache: ImageCacheManager!

    override func setUp() async throws {
       
        imageCache = ImageCacheManager()
    }

    func testLoadImageFromNetwork() async throws {
        
        let imageData = UIImage(systemName: "star")!.pngData()!
        
        let image1 = try await imageCache.loadImage(from: "https://via.placeholder.com/150/0000FF/808080 ?Text=PAKAINFO.com")
        XCTAssertNotNil(image1)
        
        let image2 = try await imageCache.loadImage(from: "https://via.placeholder.com/150/FF0000/FFFFFF?Text=yttags.com")
        XCTAssertNotNil(image2)
        
    
    }
}
