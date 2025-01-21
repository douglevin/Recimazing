//
//  URLSessionProtocol.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import Foundation

/// A protocol that we will conform to for use with our cloud clients. (Allows easier mocking for our unit tests)
internal protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}
