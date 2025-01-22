//
//  ModalWebView.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import SwiftUI
import WebKit

struct ModalWebView: View {
    let title: String
    let url: URL
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            WebView(url: url)
                .accessibilityIdentifier(AccessibilityIdentifiers.ModalWebView.webView.description)
                .navigationBarTitle(title, displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            isPresented = false
                        }
                        .accessibilityIdentifier(AccessibilityIdentifiers.ModalWebView.doneButton.description)
                    }
                }
        }
    }
}
