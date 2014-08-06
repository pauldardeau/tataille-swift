//
//  Logger.swift
//  tataille-swift
//
//  Created by Paul Dardeau on 8/4/14.
//  Copyright (c) 2014 SwampBits. All rights reserved.
//

import Foundation

public class Logger {
    
    public enum LogLevel: Int {
        case Critical  = 0
        case Error     = 1
        case Warn      = 2
        case Info      = 3
        case Debug     = 4
        case Verbose   = 5
    }
    
    let CRITICAL_PREFIX = "critical:"
    let ERROR_PREFIX    = "error:"
    let WARN_PREFIX     = "warn:"
    let INFO_PREFIX     = "info:"
    let DEBUG_PREFIX    = "debug:"
    let VERBOSE_PREFIX  = "verbose:"
    
    var logLevel: LogLevel = LogLevel.Debug
    var levelValue: Int
    
    
    init() {
        self.logLevel = LogLevel.Debug
        self.levelValue = self.logLevel.toRaw()
    }
    
    init(logLevel: LogLevel) {
        self.logLevel = logLevel
        self.levelValue = self.logLevel.toRaw()
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
        return aLogLevel.toRaw()
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
