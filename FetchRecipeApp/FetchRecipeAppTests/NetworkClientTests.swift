//
//  NetworkClientTests.swift
//  FetchRecipeAppTests
//
//  Created by Tinghe Guo on 12/10/24.
//
import XCTest
@testable import FetchRecipeApp

final class NetworkClientTests: XCTestCase {
    // URl subclass -> return mock response
    class MockURLProtocol: URLProtocol {
        static var testData: Data?
        static var statusCode: Int = 200
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: MockURLProtocol.statusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            
            if let testData = MockURLProtocol.testData {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: testData)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
    
    func testFetchRecipesSuccess() async throws {
        // Given
        let jsonString = """
        {
          "recipes": [
            { "cuisine": "Italian", "name": "Budino Di Ricotta", "uuid": "563dbb27-5323-443c-b30c-c221ae598568" }
          ]
        }
        """
        MockURLProtocol.testData = jsonString.data(using: .utf8)
        MockURLProtocol.statusCode = 200
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
 
        
        let recipes = try await NetworkClient.fetchRecipes(from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
        
        // Then
        XCTAssertEqual(recipes.count, 63)
        XCTAssertEqual(recipes.first?.name, "Apam Balik")
    }
    
    func testFetchRecipesMalformedData() async throws {
        // Given
        let malformedJsonString = """
        {
          "recipes": [
            { "cuisine": "Italian", "uuid": "1234" } // name is missing!
          ]
        }
        """
        MockURLProtocol.testData = malformedJsonString.data(using: .utf8)
        MockURLProtocol.statusCode = 200
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        // When/Then
        do {
            _ = try await NetworkClient.fetchRecipes(from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
            XCTFail("Expected error but got success")
        } catch {
           
            if let netErr = error as? NetworkClient.NetworkError {
                XCTAssertEqual(netErr, .malformedData)
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        }
    }
}
