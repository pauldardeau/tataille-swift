//
//  CocoaDisplayEngineWindow.swift
//  tataille-swift
//
//  Created by Paul Dardeau on 8/1/14.
//  Copyright (c) 2014 SwampBits. All rights reserved.
//

import Foundation
import Cocoa


class CocoaDisplayEngineWindow: DisplayEngineWindow {
    
    var window: NSWindow!
    var windowView: NSView!
    var windowId: Int
    var mapControlIdToControl: Dictionary<Int, NSView>
    var mapGroupControls: Dictionary<String, [NSView]>
    //@property (strong, nonatomic) NSMutableDictionary* mapCheckBoxHandlers;
    //@property (strong, nonatomic) NSMutableDictionary* mapPushButtonHandlers;
    //@property (strong, nonatomic) NSMutableDictionary* mapSliderHandlers;
    //@property (strong, nonatomic) NSMutableDictionary* mapTabViewHandlers;

    
    init(window: NSWindow, windowId: Int) {
        self.window = window
        
        if let contentView = window.contentView as? NSView {
            self.windowView = contentView
        }
        
        self.windowId = windowId
        self.mapControlIdToControl = Dictionary<Int, NSView>()
        self.mapGroupControls = Dictionary<String, [NSView]>()
    }
    
    func controlsForGroup(groupName: String) -> [NSView]? {
        return self.mapGroupControls[groupName]
    }
    
    func controlFromControlId(controlId: Int) -> NSView? {
        var control: NSView?
    
        if controlId > -1 {
            control = self.mapControlIdToControl[controlId]
        }
    
        return control
    }
    
    func controlFromCid(cid: ControlId) -> NSView? {
        return self.controlFromControlId(cid.controlId)
    }
    
    func valuesFromCi(ci: ControlInfo) -> [String]? {
        var listValues: [String]?
    
        if ci.haveValues() {
            listValues = ci.getValues(",")
        }
    
        return listValues;
    }
    
    func populateControl(view: NSView, ci:ControlInfo) {
        //view.tag = ci.cid.controlId;
    
        if let helpCaption = ci.helpCaption {
            view.toolTip = helpCaption
        }
    
        if !ci.isVisible {
            view.hidden = !ci.isVisible
        }
    
        if !ci.isEnabled || ci.isSelected {
            if view.isKindOfClass(NSControl) {
                if let control = view as? NSControl {
                    if !ci.isEnabled {
                        control.enabled = false
                    }
                    
                    if ci.isSelected {
                        //TODO:
                    }
                }
            }
        }
    
        self.windowView!.addSubview(view)
    }
    
    func registerControl(control: NSView, ci:ControlInfo) {
        self.mapControlIdToControl[ci.cid.controlId] = control
        
        if let groupName = ci.groupName {
            var optListControls = self.mapGroupControls[groupName]
            if optListControls {
                var listControls = optListControls!
                listControls.append(control)
            } else {
                var listControls = [NSView]()
                listControls.append(control)
                self.mapGroupControls[groupName] = listControls
            }
        }
    }

    func isControlInfoValid(ci: ControlInfo) -> Bool {
        return ci.isValid()
    }
    
    func setWindowRect(rect: NSRect) -> Bool {
        if let theWindow = self.window {
            theWindow.setFrame(rect, display: true)
            return true
        }
        
        return false
    }
    
    func setWindowSize(windowSize: NSSize) -> Bool {
        //TODO:
        return false
    }
    
    func setWindowPos(point: NSPoint) -> Bool {
        //TODO:
        return false
    }
    
    func hideWindow() -> Bool {
        return self.setWindowVisible(false)
    }
    
    func showWindow() -> Bool {
        return self.setWindowVisible(true)
    }
    
    func setWindowVisible(isVisible: Bool) -> Bool {
        if let theWindow = self.window {
            //TODO:
            //return true
        }
        
        return false
    }
    
    func setWindowTitle(windowTitle: String) -> Bool {
        if let theWindow = self.window {
            theWindow.title = windowTitle
            return true
        }
        
        return false
    }
    
    func closeWindow() -> Bool {
        if self.window {
            var theWindow = self.window!
            theWindow.close()
            self.window = nil
            self.windowView = nil
            return true
        }
        
        return false
    }
    
    func createCheckBox(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var checkBox = NSButton(frame:ci.rect)
            if ci.haveText() {
                checkBox.title = ci.text
            }
            
            checkBox.setButtonType(NSButtonType.SwitchButton)
            
            if (ci.isSelected) {
                checkBox.state = NSOnState
            }
            
            ci.controlType = CocoaDisplayEngine.ControlType.CheckBox;
            //[checkBox setTarget:self];
            //[checkBox setAction:@selector(myAction:)];
            self.populateControl(checkBox, ci:ci)
            self.registerControl(checkBox, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createComboBox(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var comboBox = NSComboBox(frame:ci.rect)
            
            //TODO:
            //NSArray* listValues = [self valuesFromCi:ci];
            //if ([listValues count] > 0) {
            //    [comboBox addItemsWithObjectValues:listValues];
            //}
            
            ci.controlType = CocoaDisplayEngine.ControlType.ComboBox
            self.populateControl(comboBox, ci:ci)
            self.registerControl(comboBox, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createEntryField(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var textField = NSTextField(frame:ci.rect)
            
            if ci.haveText() {
                textField.stringValue = ci.text!
            }
            
            ci.controlType = CocoaDisplayEngine.ControlType.EntryField
            self.populateControl(textField, ci:ci)
            self.registerControl(textField, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createGroupBox(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var box = NSBox(frame:ci.rect)
            box.borderType = NSBorderType.BezelBorder // GrooveBorder, LineBorder
            
            if ci.haveText() {
                box.title = ci.text!
            }
            
            ci.controlType = CocoaDisplayEngine.ControlType.GroupBox
            self.populateControl(box, ci:ci)
            self.registerControl(box, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createHtmlBrowser(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            //var webView = WebView(frame:ci.rect)
            
            //TODO: load URL or text if present
            
            //ci.controlType = CocoaDisplayEngine.ControlType.HtmlBrowser
            //self.populateControl(webView, ci:ci)
            //self.registerControl(webView, ci:ci)
            //controlCreated = true
        }
        
        return controlCreated
    }
    
    func createImageView(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var imageView = NSImageView(frame:ci.rect)
            
            if ci.haveValues() {
                //TODO:
                // attempt to load image
                // support local file path and URL
            }
            
            ci.controlType = CocoaDisplayEngine.ControlType.ImageView
            self.populateControl(imageView, ci:ci)
            self.registerControl(imageView, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createListBox(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var tableView = NSTableView(frame:ci.rect)

            var tableColumn = NSTableColumn(identifier:"listColumn")
            tableView.addTableColumn(tableColumn)

            if ci.haveValues() {
                var listValues = self.valuesFromCi(ci)!
                for value in listValues {
                    //TODO: poplate list entry
                }
            }
            
            ci.controlType = CocoaDisplayEngine.ControlType.ListBox
            self.populateControl(tableView, ci:ci)
            self.registerControl(tableView, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createListView(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var tableView = NSTableView(frame:ci.rect)
            
            if ci.haveValues() {
                var listValues = self.valuesFromCi(ci)!
                for value in listValues {
                    var tableColumn =
                        NSTableColumn(identifier:value)
                    //var headerCell = tableColumn.headerCell!
                    //headerCell.setStringValue(value)
                    //tableColumn.headerCell!.setStringValue(value)
                    
                    //[[myTableColumn headerCell] setStringValue:myNewTitle] ;
                    //[[myTableView headerView] setNeedsDisplay:YES];
                    
                    //tableColumn.title = value
                    
                    tableView.addTableColumn(tableColumn)
                }
            }
            
            ci.controlType = CocoaDisplayEngine.ControlType.ListView
            self.populateControl(tableView, ci:ci)
            self.registerControl(tableView, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createPanel(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var view = NSView(frame:ci.rect)
            
            ci.controlType = CocoaDisplayEngine.ControlType.Panel
            self.populateControl(view, ci:ci)
            self.registerControl(view, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createPasswordField(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var secureTextField =
                NSSecureTextField(frame:ci.rect)
            
            ci.controlType = CocoaDisplayEngine.ControlType.PasswordField
            self.populateControl(secureTextField, ci:ci)
            self.registerControl(secureTextField, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createProgressBar(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var progressIndicator =
                NSProgressIndicator(frame:ci.rect)
            
            progressIndicator.style = NSProgressIndicatorStyle.BarStyle
            progressIndicator.indeterminate = false
            progressIndicator.minValue = 0.0
            progressIndicator.maxValue = 0.0
            
            ci.controlType = CocoaDisplayEngine.ControlType.ProgressBar
            self.populateControl(progressIndicator, ci:ci)
            self.registerControl(progressIndicator, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createPushButton(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var pushButton = NSButton(frame:ci.rect)
            if ci.haveText() {
                pushButton.title = ci.text!
            }
            
            ci.controlType = CocoaDisplayEngine.ControlType.PushButton
            pushButton.bezelStyle = NSBezelStyle.RoundRectBezelStyle
            //[pushButton setTarget:self];
            //[pushButton setAction:@selector(myAction:)];
            self.populateControl(pushButton, ci:ci)
            self.registerControl(pushButton, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createSlider(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var slider = NSSlider(frame:ci.rect)
            slider.minValue = 0.0
            slider.maxValue = 100.0
            ci.controlType = CocoaDisplayEngine.ControlType.Slider
            self.populateControl(slider, ci:ci)
            self.registerControl(slider, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createStaticText(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var textField = NSTextField(frame:ci.rect)
            
            if ci.haveText() {
                textField.stringValue = ci.text!
            }
            
            ci.controlType = CocoaDisplayEngine.ControlType.StaticText
            textField.bezeled = false
            textField.drawsBackground = false
            textField.editable = false
            textField.selectable = false
            self.populateControl(textField, ci:ci)
            self.registerControl(textField, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createTabView(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var tabView = NSTabView(frame:ci.rect)
            
            if ci.haveValues() {
                var listValues = self.valuesFromCi(ci)!
                for value in listValues {
                    var tabViewItem = NSTabViewItem()
                    tabViewItem.label = value
                    tabView.addTabViewItem(tabViewItem)
                }
            }
            
            ci.controlType = CocoaDisplayEngine.ControlType.TabView
            self.populateControl(tabView, ci:ci)
            self.registerControl(tabView, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createTextView(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var textView = NSTextView(frame:ci.rect)
            
            if ci.haveText() {
                textView.string = ci.text!
            }
            
            ci.controlType = CocoaDisplayEngine.ControlType.TextView
            self.populateControl(textView, ci:ci)
            self.registerControl(textView, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createTree(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var outlineView = NSOutlineView(frame:ci.rect)
            
            ci.controlType = CocoaDisplayEngine.ControlType.Tree
            self.populateControl(outlineView, ci:ci)
            self.registerControl(outlineView, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func hideControl(cid: ControlId) -> Bool {
        return self.setVisible(false, cid:cid)
    }
    
    func showControl(cid: ControlId) -> Bool {
        return self.setVisible(true, cid:cid)
    }
    
    func hideGroup(groupName: String) -> Bool {
        return setVisible(false, groupName:groupName)
    }
    
    func showGroup(groupName: String) -> Bool {
        return setVisible(true, groupName:groupName)
    }
    
    func setVisible(isVisible: Bool, cid: ControlId) -> Bool {
        
        if let view = self.controlFromCid(cid) {
            view.hidden = !isVisible
            return true
        }
        
        return false
    }
    
    func setVisible(isVisible: Bool, groupName: String) -> Bool {
        var optGroupControls = self.controlsForGroup(groupName)
        if optGroupControls {
            let isHidden = !isVisible
            
            for view in optGroupControls! {
                view.hidden = isHidden
            }
            
            return true
        }
        
        return false
    }
    
    func enableControl(cid: ControlId) -> Bool {
        return false
        
    }
    
    func disableControl(cid: ControlId) -> Bool {
        return false
        
    }
    
    func enableGroup(groupName: String) -> Bool {
        return self.setEnabled(true, groupName:groupName)
    }
    
    func disableGroup(groupName: String) -> Bool {
        return self.setEnabled(false, groupName:groupName)
    }
    
    func setEnabled(isEnabled: Bool, cid: ControlId) -> Bool {
        return false
        
    }
    
    func setEnabled(isEnabled: Bool, groupName: String) -> Bool {
        var optGroupControls = self.controlsForGroup(groupName)
        if optGroupControls {
            for view in optGroupControls! {
            }
        }
        return false
    }
    
    func setSize(controlSize: NSSize, cid: ControlId) -> Bool {
        return false
        
    }
    
    func setPos(point: NSPoint, cid: ControlId) -> Bool {
        return false
        
    }
    
    func setRect(rect: NSRect, cid: ControlId) -> Bool {
        return false
    }

}
