//
//  AppManager.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import Foundation

class AppManager: ObservableObject {
    
    // MARK: Properties - Singleton
    
    /// The shared instance of the AppManager.
    static let shared = AppManager()
    
    // MARK: Properties - Cloud
    
    /// The API cloud client
    let apiCloudClient = APICloudClient(baseURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net")!)
    
    /// The image cloud client
    let imageCloudClient = ImageCloudClient()
}
