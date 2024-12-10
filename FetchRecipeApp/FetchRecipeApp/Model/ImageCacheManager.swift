//
//  ImageCacheManager.swift
//  FetchRecipeApp
//
//  Created by Tinghe Guo on 12/9/24.
//
import Foundation
import UIKit

actor ImageCacheManager {
    private let cacheDirectory: URL
    private let fileManager: FileManager = .default
    
    private let memoryCache = NSCache<NSString, UIImage>()

    init() {
        
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        self.cacheDirectory = urls[0].appendingPathComponent("ImageCache", isDirectory: true)
        
   
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }

    func loadImage(from urlString: String) async throws -> UIImage {
        let cacheKey = NSString(string: urlString)

        // check in-memory cache
        if let memImage = memoryCache.object(forKey: cacheKey) {
            return memImage
        }

        // Hash URL for disk filename
        let filename = urlString.sha256()
        let fileURL = cacheDirectory.appendingPathComponent(filename)
        
        // Check disk cache
        if fileManager.fileExists(atPath: fileURL.path) {
            let data = try Data(contentsOf: fileURL)
            if let img = UIImage(data: data) {
                // Store image in memory cache before returning
                memoryCache.setObject(img, forKey: cacheKey)
                return img
            } else {
                throw NSError(domain: "ImageCache", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data corrupted"])
            }
        } else {
            // download from network
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            // Save to disk and cache
            try data.write(to: fileURL)

            guard let img = UIImage(data: data) else {
                throw NSError(domain: "ImageCache", code: -1, userInfo: [NSLocalizedDescriptionKey: "Downloaded image data invalid"])
            }

            // Add to in-memory cache
            memoryCache.setObject(img, forKey: cacheKey)
            return img
        }
    }
}



// helper for unique name
import CryptoKit

extension String {
    func sha256() -> String {
        let inputData = Data(self.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}



