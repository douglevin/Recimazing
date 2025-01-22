//
//  AccessibilityIdentifiers.swift
//  Recimazing
//
//  Created by Doug Levin on 1/21/25.
//

import Foundation

/// Defines the accessibility identifiers used in our SwiftUIViews.
public struct AccessibilityIdentifiers {
    
    /// The accessibility identifiers for the `RecipeListView`
    public enum RecipeListView: String, CustomStringConvertible {
        case list
        case refreshButton
        
        public var description: String {
            "recipeListView_\(self.rawValue)"
        }
    }
    
    /// The accessibility identifiers for the `RecipeDetailView`
    public enum RecipeDetailView: String, CustomStringConvertible {
        case scrollView
        case websiteButton
        case videoButton
        
        public var description: String {
            "recipeDetailView_\(self.rawValue)"
        }
    }
    
    /// The accessibility identifiers for the `ModalWebView`
    public enum ModalWebView: String, CustomStringConvertible {
        case webView
        case doneButton
        
        public var description: String {
            "modalWebView_\(self.rawValue)"
        }
    }
}
