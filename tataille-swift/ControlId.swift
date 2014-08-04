//
//  ControlId.swift
//  tataille-swift
//
//  Created by Paul Dardeau on 8/1/14.
//  Copyright (c) 2014 SwampBits. All rights reserved.
//

import Foundation

public class ControlId {
    
    public var windowId = -1
    public var controlId = -1
    public var parentId = -1
    
    //**************************************************************************

    public init(windowId: Int, controlId: Int) {
        self.windowId = windowId
        self.controlId = controlId
        self.parentId = -1
    }

    //**************************************************************************

    public init(windowId: Int, controlId: Int, parentId: Int) {
        self.windowId = windowId
        self.controlId = controlId
        self.parentId = parentId
    }

    //**************************************************************************

    func isValid() -> Bool {
        return (windowId > -1) && (controlId > -1)
    }

    //**************************************************************************

    func haveParent() -> Bool {
        return self.parentId > -1
    }
    
    //**************************************************************************

}
