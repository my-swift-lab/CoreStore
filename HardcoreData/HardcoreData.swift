//
//  HardcoreData.swift
//  HardcoreData
//
//  Copyright (c) 2014 John Rommel Estropia
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

import CoreData
import GCDKit


/**
Okay, okay. This one's shorter.
*/
public typealias HCD = HardcoreData


// MARK: - HardcoreData

/**
HardcoreData is the main entry point for all other APIs.
*/
public enum HardcoreData {
    
    // MARK: Public
    
    /**
    The default DataStack instance to be used. If defaultStack is not set before the first time accessed, a default-configured DataStack will be created.
    
    Changing the defaultStack is thread safe.
    */
    public static var defaultStack: DataStack {
        
        get {
        
            self.defaultStackBarrierQueue.barrierSync {
        
                if self.defaultStackInstance == nil {
        
                    self.defaultStackInstance = DataStack()
                }
            }
            return self.defaultStackInstance!
        }
        set {
            
            self.defaultStackBarrierQueue.barrierAsync {
                
                self.defaultStackInstance = newValue
            }
        }
    }
    
    
    /**
    The HardcoreDataLogger instance to be used. The default logger is an instance of a DefaultLogger.
    */
    public static var logger: HardcoreDataLogger = DefaultLogger()
    
    
    // MARK: Internal
    
    internal static func log(level: LogLevel, message: String, fileName: StaticString = __FILE__, lineNumber: Int = __LINE__, functionName: StaticString = __FUNCTION__) {
        
        self.logger.log(
            level: level,
            message: message,
            fileName: fileName,
            lineNumber:
            lineNumber,
            functionName:
            functionName
        )
    }
    
    internal static func handleError(error: NSError, _ message: String, fileName: StaticString = __FILE__, lineNumber: Int = __LINE__, functionName: StaticString = __FUNCTION__) {
        
        self.logger.handleError(
            error: error,
            message: message,
            fileName: fileName,
            lineNumber: lineNumber,
            functionName: functionName)
    }
    
    internal static func assert(@autoclosure condition: () -> Bool, _ message: String, fileName: StaticString = __FILE__, lineNumber: Int = __LINE__, functionName: StaticString = __FUNCTION__) {
        
        self.logger.assert(
            condition,
            message: message,
            fileName: fileName,
            lineNumber: lineNumber,
            functionName: functionName)
    }
    
    
    // MARK: Private
    
    private static let defaultStackBarrierQueue = GCDQueue.createConcurrent("com.hardcoreData.defaultStackBarrierQueue")
    
    private static var defaultStackInstance: DataStack?
}