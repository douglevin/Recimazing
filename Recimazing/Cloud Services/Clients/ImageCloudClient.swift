//
//  ImageCloudClient.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import os
import UIKit

/// This class contains the functionality to fetch images from the cloud and store them.
public class ImageCloudClient: BaseCloudClient {
    
    // MARK: Properties
    
    /// The directory URL where the images will be cached.
    internal let cacheDirectoryURL: URL
    
    /// A logger for debugging and logging errors.
    private let logger = Logger()
    
    // MARK: Enums
    
    /// An enum representing the possible errors that can occur within the cloud image client.
    public enum InternalError: Equatable, Error {
        case failedToConvertDataToImage
        case failedToConvertImageToData
        case failedWritingDataToFile(message: String)
    }

    // MARK: Initializers
    
    /// Initializes a cloud image client. Attempts to create a directory in the applications support directory.
    /// If this fails for any reason, a temporary directory is used.
    public convenience override init() {
        self.init(session: URLSession.shared)
    }
    
    /// Initializes a cloud image client and is for internal usage only. Allows dependency injection for easier unit
    /// testing.
    ///
    /// Attempts to create a directory in the applications support directory. If this fails for any reason, a
    /// temporary directory is used.
    ///
    /// - Parameters:
    ///   - session: The session to use when making URL requests.
    internal override init(session: URLSessionProtocol = URLSession.shared) {
        
        let fileManager = FileManager.default
        let imageCachePath = "ImageCache"
        
        // Attempt to get the application support directory
        let parentDirectory: URL
        if let directory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            parentDirectory = directory
        } else {
            // Fallback to a temporary directory if the application support directory is not found.
            parentDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
            logger.error("Application Support directory not found. Falling back to temporary directory.")
        }
        
        // Ensure a cache directory exists or use the parent directory as a fallback.
        let cacheDirectory = parentDirectory.appending(path: imageCachePath, directoryHint: .isDirectory)
        if fileManager.fileExists(atPath: cacheDirectory.path) {
            cacheDirectoryURL = cacheDirectory
        } else {
            do {
                try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
                cacheDirectoryURL = cacheDirectory
            } catch {
                logger.error("Failed to create cache directory at \(cacheDirectory.path): \(error)")
                cacheDirectoryURL = parentDirectory
            }
        }
        
        super.init(session: session)
    }
    
    // MARK: Handling Images
    
    /// Retrieves an image given a URL and a caching key. This function will first check to see if the image is in the
    /// cache, otherwise, it will download it.
    ///
    /// - Parameters:
    ///   - url: The URL for the image.
    ///   - cacheKey: The key to use for caching the image.
    /// - Returns: A `UIImage` if no errors have occurred
    /// - Throws:  An `Error` if a problem occurs.
    public func getImage(from url: URL, cacheKey: String) async throws -> UIImage {
    
        // Check if an image is already cached, if so, return it.
        if let cachedImage = cachedImage(forKey: cacheKey) {
            return cachedImage
        }
        
        let data = try await performRequest(withURL: url)
        guard let image = UIImage(data: data) else {
            throw InternalError.failedToConvertDataToImage
        }
        
        // Throw any errors from our private save function
        try save(image, forKey: cacheKey)
        
        return image
    }
    
    /// Gets an image from the cache. Returns nil if no image is found using the given key.
    ///
    /// - Parameter key: The key used to store the image in the cache.
    /// - Returns: A `UIImage` or nil if none exists with the given cache key.
    internal func cachedImage(forKey key: String) -> UIImage? {
        let fileURL = cacheDirectoryURL.appending(path: key)
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    /// Saves an image to the cache.
    ///
    /// - Parameters:
    ///   - image: The image to save
    ///   - key: The key to use for caching the image.
    /// - Throws: An `InternalError` if a problem occurs.
    internal func save(_ image: UIImage, forKey key: String) throws {
        let fileURL = cacheDirectoryURL.appending(path: key)
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            throw InternalError.failedToConvertImageToData
        }
        
        do {
            try data.write(to: fileURL)
        } catch {
            throw InternalError.failedWritingDataToFile(message: "Failed writing to file \(fileURL), Error: \(error)")
        }
    }
}
