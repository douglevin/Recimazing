//
//  BaseCloudClientTests.swift
//  RecimazingTests
//
//  Created by Doug Levin on 1/20/25.
//

import Foundation
@testable import Recimazing
import Testing

struct BaseCloudClientTests {
    
    let baseCloudClient = BaseCloudClient()
    let mockBaseCloudClient: BaseCloudClient
    let mockSession = MockURLSession()
    let mockURL = URL(string: "https://example.com")!
    
    init() throws {
        mockBaseCloudClient = BaseCloudClient(session: mockSession)
    }
    
    @Test func initializing() throws {
        #expect(baseCloudClient.session as? URLSession != nil)
        #expect(baseCloudClient.session as? MockURLSession == nil)
        
        #expect(mockBaseCloudClient.session as? MockURLSession != nil)
        #expect(mockBaseCloudClient.session as? URLSession == nil)
    }
    
    @Test func performRequestSuccess() async throws {
        let mockResponse = HTTPURLResponse(url: mockURL,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
        mockSession.mockData = Data()
        mockSession.mockResponse = mockResponse
        
        let data = try await mockBaseCloudClient.performRequest(withURL: mockURL)
        #expect(mockSession.mockData == data)
    }
    
    @Test func performRequestBadResponseType() async throws {
        let mockResponse = URLResponse(url: mockURL,
                                       mimeType: "text/plain",
                                       expectedContentLength: 100,
                                       textEncodingName: "utf-8")
        mockSession.mockData = Data()
        mockSession.mockResponse = mockResponse
        
        await #expect(throws: URLError(.badServerResponse)) {
            try await mockBaseCloudClient.performRequest(withURL: mockURL)
        }
    }
    
    @Test func performRequestBadStatusCode() async throws {
        let mockResponse = HTTPURLResponse(url: mockURL,
                                           statusCode: 400,
                                           httpVersion: nil,
                                           headerFields: nil)
        mockSession.mockData = Data()
        mockSession.mockResponse = mockResponse
        
        await #expect(throws: URLError(.badServerResponse)) {
            try await mockBaseCloudClient.performRequest(withURL: mockURL)
        }
    }
}
