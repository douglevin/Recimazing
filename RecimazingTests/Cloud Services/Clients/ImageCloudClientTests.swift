//
//  ImageCloudClientTests.swift
//  RecimazingTests
//
//  Created by Doug Levin on 1/20/25.
//

@testable import Recimazing
import Testing
import UIKit

struct ImageCloudClientTests {
    
    struct MockTests {
        let fileManager = FileManager.default
        let mockImageCloudClient: ImageCloudClient
        let mockSession = MockURLSession()
        let mockURL = URL(string: "https://example.com/image.jpg")!
        
        init() throws {
            mockImageCloudClient = ImageCloudClient(session: mockSession)
        }
        
        @Test func initializing() throws {
            #expect(mockImageCloudClient.session as? MockURLSession != nil)
            #expect(mockImageCloudClient.session as? URLSession == nil)
            
            let directory = try #require(fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first)
            let cacheDirectory = directory.appendingPathComponent("ImageCache", isDirectory: true)
            #expect(cacheDirectory == mockImageCloudClient.cacheDirectoryURL)
        }
        
        @Test func getImageSuccessFromURL() async throws {
            let cacheKey = UUID().uuidString
            let image = try #require(UIImage(systemName: "iphone"))
            let imageData = image.jpegData(compressionQuality: 1.0)
            mockSession.mockData = imageData
            mockSession.mockResponse = HTTPURLResponse(url: mockURL,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil)
            
            let cachedImage = mockImageCloudClient.cachedImage(forKey: cacheKey)
            #expect(cachedImage == nil)
            
            let uiImage = try await mockImageCloudClient.getImage(from: mockURL, cacheKey: cacheKey)
            #expect(uiImage != nil)
        }
        
        @Test func getImageSuccessFromCache() async throws {
            let cacheKey = UUID().uuidString
            let image = try #require(UIImage(systemName: "iphone"))
            mockSession.mockData = Data()
            mockSession.mockResponse = HTTPURLResponse(url: mockURL,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil)
            
            let cachedImage = mockImageCloudClient.cachedImage(forKey: cacheKey)
            #expect(cachedImage == nil)
            
            try mockImageCloudClient.save(image, forKey: cacheKey)
            let cachedImage2 = try #require(mockImageCloudClient.cachedImage(forKey: cacheKey))
            
            let uiImage = try await mockImageCloudClient.getImage(from: mockURL, cacheKey: cacheKey)
            #expect(cachedImage2.size == uiImage.size)
        }
        
        @Test func getImageBadResponseData() async throws {
            let mockResponse = HTTPURLResponse(url: mockURL,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
            
            mockSession.mockData = Data()
            mockSession.mockResponse = mockResponse
            
            await #expect(throws: ImageCloudClient.InternalError.failedToConvertDataToImage) {
                try await mockImageCloudClient.getImage(from: mockURL, cacheKey: "")
            }
        }
        
        @Test func saveFailedToConvertImageToData() throws {
            let emptyImage = UIImage(ciImage: CIImage())
            #expect(throws: ImageCloudClient.InternalError.failedToConvertImageToData) {
                try mockImageCloudClient.save(emptyImage, forKey: "some key")
            }
        }
    }
    
    struct IntegrationTests {
        let imageCloudClient = ImageCloudClient()
        let fileManager = FileManager.default
        let url = URL(string:
                        "https://d3jbb8n5wk0qxi.cloudfront.net/photos/93e50ff1-bf1d-4f88-8978-e18e01d3231d/small.jpg")!
        
        @Test func initializing() throws {
            #expect(imageCloudClient.session as? URLSession != nil)
            #expect(imageCloudClient.session as? MockURLSession == nil)
            
            let directory = try #require(fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first)
            let cacheDirectory = directory.appendingPathComponent("ImageCache", isDirectory: true)
            #expect(cacheDirectory == imageCloudClient.cacheDirectoryURL)
        }
        
        @Test func getImageSuccess() async throws {
            let cacheKey = UUID().uuidString
            let cachedImage = imageCloudClient.cachedImage(forKey: cacheKey)
            #expect(cachedImage == nil)
            
            let uiImage = try await imageCloudClient.getImage(from: url, cacheKey: cacheKey)
            #expect(uiImage != nil)
            
            let cachedImage2 = try #require(imageCloudClient.cachedImage(forKey: cacheKey))
            #expect(cachedImage2 != nil)
            #expect(cachedImage2.size == uiImage.size)
            
        }
        
        @Test func getImageFailsWithBadResponse() async throws {
            let badURL = try #require(URL(string: "https://httpstat.us/500"))
            await #expect(throws: URLError(.badServerResponse)) {
                try await imageCloudClient.getImage(from: badURL, cacheKey: "badResponse")
            }
        }
        
        @Test func getImageFailsWithInvalidData() async throws {
            let badURL = try #require(URL(string: "https://httpstat.us/200"))
            await #expect(throws: ImageCloudClient.InternalError.failedToConvertDataToImage) {
                try await imageCloudClient.getImage(from: badURL, cacheKey: "invalidData")
            }
        }
    }
}
