//
//  CocoaDisplayEngine.swift
//  tataille-swift
//
//  Created by Paul Dardeau on 8/1/14.
//  Copyright (c) 2014 SwampBits. All rights reserved.
//

import Foundation
import Cocoa


public class CocoaDisplayEngine: DisplayEngine {
    
    public enum ControlType {
        case Unknown
        case CheckBox
        case ComboBox
        case EntryField
        case GroupBox
        case HtmlBrowser
        case ImageView
        case ListBox
        case ListView
        case Panel
        case PasswordField
        case ProgressBar
        case PushButton
        case Slider
        case StaticText
        case TabView
        case TextView
        case Tree
    }
    
    
    var mapIdToWindows = [Int: CocoaDisplayEngineWindow]()
    var _translateYValues = true

    //**************************************************************************

    init(mainWindow: NSWindow) {
        var deWindow = CocoaDisplayEngineWindow(window:mainWindow, windowId:0)
        self.mapIdToWindows[0] = deWindow
    }

    //**************************************************************************

    func setTranslateYValues(translateYValues: Bool) {
        //TODO: automatically propagate to all windows?
        self._translateYValues = translateYValues
    }

    //**************************************************************************

    func translateYValues() -> Bool {
        return self._translateYValues
    }

    //**************************************************************************

    func windowFromId(windowId: Int) -> CocoaDisplayEngineWindow? {
        var window: CocoaDisplayEngineWindow?
    
        if (windowId > -1) {
            window = self.mapIdToWindows[windowId]
        }
    
        return window
    }

    //**************************************************************************

    func windowFromCid(cid: ControlId) -> CocoaDisplayEngineWindow? {
        return self.windowFromId(cid.windowId)
    }

    //**************************************************************************

    func windowFromCi(ci: ControlInfo) -> CocoaDisplayEngineWindow? {
        return self.windowFromCid(ci.cid)
    }

    //**************************************************************************

    func run() {
    
    }

    //**************************************************************************

    func getDisplayEngineName() -> String {
        return "CocoaDisplayEngine"
    }

    //**************************************************************************

    func getDisplayEngineTechnology() -> String {
        return "Cocoa/Swift"
    }

    //**************************************************************************

    func getDisplayEngineLanguage() -> String {
        return "Swift"
    }

    //**************************************************************************

    func getDisplayEngineVersion() -> String {
        return "0.1"
    }

    //**************************************************************************

    func createWindow(windowId: Int, rect: NSRect) -> Bool {
        //TODO:
        return false
    }

    //**************************************************************************

    func setRect(rect: NSRect, windowId: Int) -> Bool {
        if let window = self.windowFromId(windowId) {
            return window.setWindowRect(rect)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setSize(windowSize: NSSize, windowId: Int) -> Bool {
        if let window = self.windowFromId(windowId) {
            return window.setWindowSize(windowSize)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setPos(point: NSPoint, windowId: Int) -> Bool {
        if let window = self.windowFromId(windowId) {
            return window.setWindowPos(point)
        } else {
            return false
        }
    }

    //**************************************************************************

    func hideWindow(windowId: Int) -> Bool {
        if let window = self.windowFromId(windowId) {
            return window.hideWindow()
        } else {
            return false
        }
    }

    //**************************************************************************

    func showWindow(windowId: Int) -> Bool {
        if let window = self.windowFromId(windowId) {
            return window.showWindow()
        } else {
            return false
        }
    }

    //**************************************************************************

    func setVisible(isVisible: Bool, windowId: Int) -> Bool {
        if let window = self.windowFromId(windowId) {
            return window.setWindowVisible(isVisible)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setTitle(windowTitle: String, windowId: Int) -> Bool {
        if let window = self.windowFromId(windowId) {
            return window.setWindowTitle(windowTitle)
        } else {
            return false
        }
    }

    //**************************************************************************

    func closeWindow(windowId: Int) -> Bool {
        if let window = self.windowFromId(windowId) {
            return window.closeWindow()
        } else {
            return false
        }
    }

    //**************************************************************************

    func createCheckBox(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createCheckBox(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createComboBox(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createComboBox(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createEntryField(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createEntryField(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createGroupBox(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createGroupBox(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createHtmlBrowser(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createHtmlBrowser(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createImageView(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createImageView(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createListBox(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createListBox(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createListView(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createListView(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createPanel(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createPanel(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createPasswordField(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createPasswordField(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createProgressBar(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createProgressBar(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createPushButton(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createPushButton(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createSlider(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createSlider(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createStaticText(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createStaticText(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createTabView(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createTabView(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createTextView(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createTextView(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func createTree(ci: ControlInfo) -> Bool {
        if let window = self.windowFromCi(ci) {
            return window.createTree(ci)
        } else {
            return false
        }
    }

    //**************************************************************************

    func hideControl(cid: ControlId) -> Bool {
        return self.setVisible(false, cid:cid)
    }

    //**************************************************************************

    func showControl(cid: ControlId) -> Bool {
        return self.setVisible(true, cid:cid)
    }

    //**************************************************************************

    func hideGroup(groupName: String, windowId: Int) -> Bool {
        if let window = self.windowFromId(windowId) {
            return window.setVisible(false, groupName:groupName)
        } else {
            return false
        }
    }

    //**************************************************************************

    func showGroup(groupName: String, windowId: Int) -> Bool {
        if let window = self.windowFromId(windowId) {
            return window.setVisible(true, groupName:groupName)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setVisible(isVisible: Bool, cid: ControlId) -> Bool {
        if let window = self.windowFromCid(cid) {
            return window.setVisible(isVisible, cid:cid)
        } else {
            return false
        }
    }
    
    //**************************************************************************

    func setVisible(isVisible: Bool, windowId: Int, groupName: String) -> Bool {
        if let window = self.windowFromId(windowId) {
            return window.setVisible(isVisible, groupName:groupName)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setFocus(cid: ControlId) -> Bool {
        if let window = self.windowFromCid(cid) {
            return window.setFocus(cid)
        } else {
            return false
        }
    }

    //**************************************************************************

    func enableControl(cid: ControlId) -> Bool {
        return self.setEnabled(true, cid:cid)
    }

    //**************************************************************************

    func disableControl(cid: ControlId) -> Bool {
        return self.setEnabled(false, cid:cid)
    }

    //**************************************************************************

    func enableGroup(groupName: String, windowId: Int) -> Bool {
        if let window = self.windowFromId(windowId) {
            return window.setEnabled(true, groupName:groupName)
        } else {
            return false
        }
    }

    //**************************************************************************

    func disableGroup(groupName: String, windowId: Int) -> Bool {
        if let window = self.windowFromId(windowId) {
            return window.setEnabled(false, groupName:groupName)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setEnabled(isEnabled: Bool, cid:ControlId) -> Bool {
        if let window = self.windowFromCid(cid) {
            return window.setEnabled(isEnabled, cid:cid)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setEnabled(isEnabled: Bool, windowId: Int, groupName: String) -> Bool {
        if let window = self.windowFromId(windowId) {
            return window.setEnabled(isEnabled, groupName:groupName)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setSize(controlSize: NSSize, cid: ControlId) -> Bool {
        if let window = self.windowFromCid(cid) {
            return window.setSize(controlSize, cid:cid)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setPos(point: NSPoint, cid: ControlId) -> Bool {
        if let window = self.windowFromCid(cid) {
            return window.setPos(point, cid:cid)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setRect(rect: NSRect, cid: ControlId) -> Bool {
        if let window = self.windowFromCid(cid) {
            return window.setRect(rect, cid:cid)
        } else {
            return false
        }
    }

    //**************************************************************************
    
    func addRow(rowText: String, cid: ControlId) -> Bool {
        if let window = self.windowFromCid(cid) {
            return window.addRow(rowText, cid:cid)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setCheckBoxHandler(handler: CheckBoxHandler, cid: ControlId) -> Bool {
        if let window = self.windowFromCid(cid) {
            return window.setCheckBoxHandler(handler, cid:cid)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setComboBoxHandler(handler: ComboBoxHandler, cid: ControlId) -> Bool {
        if let window = self.windowFromCid(cid) {
            return window.setComboBoxHandler(handler, cid:cid)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setListBoxHandler(handler: ListBoxHandler, cid: ControlId) -> Bool {
        if let window = self.windowFromCid(cid) {
            return window.setListBoxHandler(handler, cid:cid)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setListViewHandler(handler: ListViewHandler, cid: ControlId) -> Bool {
        if let window = self.windowFromCid(cid) {
            return window.setListViewHandler(handler, cid:cid)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setPushButtonHandler(handler: PushButtonHandler, cid: ControlId) -> Bool {
        if let window = self.windowFromCid(cid) {
            return window.setPushButtonHandler(handler, cid:cid)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setSliderHandler(handler: SliderHandler, cid: ControlId) -> Bool {
        if let window = self.windowFromCid(cid) {
            return window.setSliderHandler(handler, cid:cid)
        } else {
            return false
        }
    }

    //**************************************************************************

    func setTabViewHandler(handler: TabViewHandler, cid: ControlId) -> Bool {
        if let window = self.windowFromCid(cid) {
            return window.setTabViewHandler(handler, cid:cid)
        } else {
            return false
        }
    }

    //**************************************************************************

}
