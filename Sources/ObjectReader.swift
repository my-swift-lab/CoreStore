//
//  ObjectReader.swift
//  CoreStore
//
//  Copyright © 2021 John Rommel Estropia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#if canImport(Combine) && canImport(SwiftUI)

import Combine
import SwiftUI


// MARK: - ObjectReader

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public struct ObjectReader<Object: DynamicObject, Content: View, Value>: View {
    
    // MARK: Internal
    
    public init(
        _ objectPublisher: ObjectPublisher<Object>?,
        @ViewBuilder content: @escaping (Value) -> Content
    ) where Value == LiveObject<Object>.Item {
        
        self._object = .init(objectPublisher)
        self.content = content
        self.keyPath = \.self
    }
    
    public init(
        _ objectPublisher: ObjectPublisher<Object>?,
        keyPath: KeyPath<LiveObject<Object>.Item, Value>,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        
        self._object = .init(objectPublisher)
        self.content = content
        self.keyPath = keyPath
    }
    
    
    // MARK: View
    
    public var body: some View {
        
        if let object = self.object {
            
            self.content(object[keyPath: self.keyPath])
        }
    }
    
    
    // MARK: Private
    
    @LiveObject
    private var object: LiveObject<Object>.Item?
    
    private let content: (Value) -> Content
    private let keyPath: KeyPath<LiveObject<Object>.Item, Value>
}

#endif