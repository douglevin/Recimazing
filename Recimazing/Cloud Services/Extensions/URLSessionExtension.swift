//
//  URLSessionExtension.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import Foundation

/// An extension for URLSession so we can use it with our cloud clients. (Allows easier mocking for our unit tests)
extension URLSession: URLSessionProtocol {}
