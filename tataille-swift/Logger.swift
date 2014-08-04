//
//  Logger.swift
//  tataille-swift
//
//  Created by Paul Dardeau on 8/4/14.
//  Copyright (c) 2014 SwampBits. All rights reserved.
//

import Foundation

public class Logger {
    
    public enum LogLevel {
        case Critical
        case Error
        case Warn
        case Info
        case Debug
        case Verbose
    }
    
    let CRITICAL_PREFIX = "critical:"
    let ERROR_PREFIX    = "error:"
    let WARN_PREFIX     = "warn:"
    let INFO_PREFIX     = "info:"
    let DEBUG_PREFIX    = "debug:"
    let VERBOSE_PREFIX  = "verbose:"
    
    let CRITICAL_VALUE  = 0
    let ERROR_VALUE     = 1
    let WARN_VALUE      = 2
    let INFO_VALUE      = 3
    let DEBUG_VALUE     = 4
    let VERBOSE_VALUE   = 5
    
    var logLevel: LogLevel = LogLevel.Debug
    var levelValue: Int
    
    
    init() {
        self.logLevel = LogLevel.Debug
        self.levelValue = DEBUG_VALUE
    }
    
    init(logLevel: LogLevel) {
        self.logLevel = logLevel
        self.levelValue = DEBUG_VALUE
        self.levelValue = self.getLogLevelValue(logLevel)
    }
    
    func isLoggingLevel(logLevel: LogLevel) -> Bool {
        return self.getLogLevelValue(logLevel) <= self.levelValue
    }
    
    func getLogLevel() -> LogLevel {
        return self.logLevel
    }
    
    func setLogLevel(logLevel: LogLevel) {
        self.logLevel = logLevel
        self.levelValue = self.getLogLevelValue(logLevel)
    }
    
    func getLogLevelValue(aLogLevel: LogLevel) -> Int {
        switch (aLogLevel) {
            case LogLevel.Critical:
                return CRITICAL_VALUE
            case LogLevel.Error:
                return ERROR_VALUE
            case LogLevel.Warn:
                return WARN_VALUE
            case LogLevel.Info:
                return INFO_VALUE
            case LogLevel.Debug:
                return DEBUG_VALUE
            case LogLevel.Verbose:
                return VERBOSE_VALUE
        }
    }
    
    func getPrefix(aLogLevel: LogLevel) -> String {
        switch (aLogLevel) {
        case LogLevel.Critical:
            return CRITICAL_PREFIX
        case LogLevel.Error:
            return ERROR_PREFIX
        case LogLevel.Warn:
            return WARN_PREFIX
        case LogLevel.Info:
            return INFO_PREFIX
        case LogLevel.Debug:
            return DEBUG_PREFIX
        case LogLevel.Verbose:
            return VERBOSE_PREFIX
        }
    }
    
    func logMessage(level: LogLevel, message: String) {
        let theLevelValue = self.getLogLevelValue(level)
        if theLevelValue <= self.levelValue {
            let prefix = getPrefix(level)
            println("\(prefix) \(message)")
        }
    }
    
    func critical(logMessage: String) {
        self.logMessage(LogLevel.Critical, message:logMessage)
    }
    
    func error(logMessage: String) {
        self.logMessage(LogLevel.Error, message:logMessage)
    }
    
    func warn(logMessage: String) {
        self.logMessage(LogLevel.Warn, message:logMessage)
    }
    
    func info(logMessage: String) {
        self.logMessage(LogLevel.Info, message:logMessage)
    }
    
    func debug(logMessage: String) {
        self.logMessage(LogLevel.Debug, message:logMessage)
    }
    
    func verbose(logMessage: String) {
        self.logMessage(LogLevel.Verbose, message:logMessage)
    }
}
