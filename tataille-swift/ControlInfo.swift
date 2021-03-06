//
//  ControlInfo.swift
//  tataille-swift
//
//  Created by Paul Dardeau on 8/1/14.
//  Copyright (c) 2014 SwampBits. All rights reserved.
//  BSD license

import Foundation

public class ControlInfo {
    
    // font
    // audio clip

    var controlType: CocoaDisplayEngine.ControlType
    public var cid: ControlId
    public var controlName: String?
    public var groupName: String?
    public var text: String?
    public var helpCaption: String?
    public var values: String?
    public var valuesDelimiter: String?
    public var foregroundColor: String?
    public var backgroundColor: String?
    public var rect: NSRect
    public var isSelected = false  // only for checkbox? if so, probably remove
    public var isVisible = true
    public var isEnabled = true

    //**************************************************************************

    public init(cid: ControlId) {
        self.controlType = CocoaDisplayEngine.ControlType.Unknown
        self.cid = cid
        self.rect = CGRectZero
    }

    //**************************************************************************

    func isValid() -> Bool {
        return self.cid.isValid()
    }

    //**************************************************************************

    func haveParent() -> Bool {
        return self.cid.haveParent()
    }

    //**************************************************************************

    func getValues(defaultDelimiter: String) -> [String]? {
        if let unWrappedValues = self.values {
            if let unWrappedDelimiter = self.valuesDelimiter {
                return unWrappedValues.componentsSeparatedByString(unWrappedDelimiter)
            } else {
                return unWrappedValues.componentsSeparatedByString(defaultDelimiter)
            }
        }
        
        return nil
    }

    //**************************************************************************

    class func haveStringValue(s: String?) -> Bool {
        if let sUnwrapped = s {
            if countElements(sUnwrapped) > 0 {
                return true
            }
        }
        
        return false
    }

    //**************************************************************************
    
    func haveForegroundColor() -> Bool {
        return ControlInfo.haveStringValue(self.foregroundColor)
    }

    //**************************************************************************

    func haveBackgroundColor() -> Bool {
        return ControlInfo.haveStringValue(self.backgroundColor)
    }

    //**************************************************************************

    func haveGroupName() -> Bool {
        return ControlInfo.haveStringValue(self.groupName)
    }

    //**************************************************************************

    func haveControlName() -> Bool {
        return ControlInfo.haveStringValue(self.controlName)
    }

    //**************************************************************************

    func haveHelpCaption() -> Bool {
        return ControlInfo.haveStringValue(self.helpCaption)
    }

    //**************************************************************************

    func haveText() -> Bool {
        return ControlInfo.haveStringValue(self.text)
    }

    //**************************************************************************

    func haveValues() -> Bool {
        return ControlInfo.haveStringValue(self.values)
    }

    //**************************************************************************

    func haveValuesDelimiter() -> Bool {
        return ControlInfo.haveStringValue(self.valuesDelimiter)
    }
    
    //**************************************************************************

}

