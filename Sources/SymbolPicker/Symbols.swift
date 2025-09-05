//
//  Symbols.swift
//  SymbolPicker
//
//  Created by Yubo Qin on 1/12/23.
//

import Foundation

/// Simple singleton class for providing symbols list per platform availability.
@MainActor
public class Symbols: Sendable {

    /// Singleton instance.
    public static let shared = Symbols()

    /// Filter closure that checks each symbol name string should be included.
    public var filter: ((String) -> Bool)? {
        didSet {
            if let filter {
                symbols = allSymbols.filter { filter($0.name) }
            } else {
                symbols = allSymbols
            }
        }
    }

    /// Array of the symbol name strings to be displayed.
    private(set) var symbols: [Symbol]

    /// Array of all available symbol name strings.
    private let allSymbols: [Symbol]

    private init() {
        self.allSymbols = Self.fetchSymbolsWithCategories()
        self.symbols = self.allSymbols
    }

    private static func fetchSymbols() -> [String] {
        if let bundle = Bundle(identifier: "com.apple.CoreGlyphs"),
           let resourcePath = bundle.path(forResource: "name_availability", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: resourcePath),
           let plistSymbols = plist["symbols"] as? [String: String]
        {
          let symbols = Array(plistSymbols.keys)
            
            return symbols
        }
        
        return []
    }
    
    private static func fetchSymbolsWithCategories() -> [Symbol] {
        if let bundle = Bundle(identifier: "com.apple.CoreGlyphs"),
           let resourcePath = bundle.path(forResource: "name_availability", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: resourcePath),
           let plistSymbols = plist["symbols"] as? [String: String]
        {
          let symbols = Array(plistSymbols.keys)
            
            return symbols.map({ Symbol($0) })
        }
        
        return []
    }
}

