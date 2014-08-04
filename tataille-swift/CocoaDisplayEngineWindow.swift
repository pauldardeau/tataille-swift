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
    var mapCheckBoxHandlers: Dictionary<Int, CheckBoxHandler>
    var mapPushButtonHandlers: Dictionary<Int, PushButtonHandler>
    var mapSliderHandlers: Dictionary<Int, SliderHandler>
    var mapTabViewHandlers: Dictionary<Int, TabViewHandler>
    var _translateYValues = true

    
    init(window: NSWindow, windowId: Int) {
        self.window = window
        
        if let contentView = window.contentView as? NSView {
            self.windowView = contentView
        }
        
        self.windowId = windowId
        self.mapControlIdToControl = Dictionary<Int, NSView>()
        self.mapGroupControls = Dictionary<String, [NSView]>()
        self.mapCheckBoxHandlers = Dictionary<Int, CheckBoxHandler>()
        self.mapPushButtonHandlers = Dictionary<Int, PushButtonHandler>()
        self.mapSliderHandlers = Dictionary<Int, SliderHandler>()
        self.mapTabViewHandlers = Dictionary<Int, TabViewHandler>()
    }
    
    func setTranslateYValues(translateYValues: Bool) {
        self._translateYValues = translateYValues
    }
    
    func translateYValues() -> Bool {
        return self._translateYValues
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
            if let control = view as? NSControl {
                if !ci.isEnabled {
                    control.enabled = false
                }
                    
                if ci.isSelected {
                    //TODO:
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
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return 3
    }
    
    func tableView(aTableView: NSTableView!,
        objectValueForTableColumn aTableColumn: NSTableColumn!,
        row rowIndex: Int) -> AnyObject! {
        return "Paul"
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
            if isVisible {
                theWindow.makeKeyAndOrderFront(self)
            } else {
                theWindow.orderOut(self)
            }
            
            return true
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
    
    func checkBoxToggled(sender: NSButton!) {
        println("check box toggled")
    }
    
    func translateRectYValues(rect: NSRect) -> NSRect {
        let windowRect = self.windowView!.frame
        var translatedRect = NSMakeRect(0, 0, 0, 0)
        translatedRect.origin.x = rect.origin.x
        translatedRect.origin.y = windowRect.size.height - rect.origin.y - rect.size.height
        translatedRect.size.width = rect.size.width
        translatedRect.size.height = rect.size.height
            
        return translatedRect
    }
    
    func translateYValues(ci: ControlInfo) -> NSRect {
        // do we have a parent?
        if ci.haveParent() {
            //TODO: implement translation for control with a parent
            return ci.rect;
        } else {
            return self.translateRectYValues(ci.rect)
        }
    }
    
    func rectForCi(ci: ControlInfo) -> NSRect {
        if self.translateYValues() {
            return self.translateYValues(ci)
        } else {
            return ci.rect
        }
    }
    
    func createCheckBox(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var checkBox = NSButton(frame:self.rectForCi(ci))
            if ci.haveText() {
                checkBox.title = ci.text
            }
            
            checkBox.setButtonType(NSButtonType.SwitchButton)
            
            if (ci.isSelected) {
                checkBox.state = NSOnState
            }
            
            //checkBox.target = self
            //checkBox.action = "checkBoxToggled:"
            
            //[checkBox setTarget:self];
            //[checkBox setAction:@selector(myAction:)];
            
            ci.controlType = CocoaDisplayEngine.ControlType.CheckBox;
            self.populateControl(checkBox, ci:ci)
            self.registerControl(checkBox, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createComboBox(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var comboBox = NSComboBox(frame:self.rectForCi(ci))

            if ci.haveValues() {
                var listValues = self.valuesFromCi(ci)
                comboBox.addItemsWithObjectValues(listValues)
                comboBox.selectItemAtIndex(0)
            }
            
            comboBox.editable = false
            
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
            var textField = NSTextField(frame:self.rectForCi(ci))
            
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
            var box = NSBox(frame:self.rectForCi(ci))
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
            //var webView = WebView(frame:self.rectForCi(ci))
            
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
            var imageView = NSImageView(frame:self.rectForCi(ci))
            
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
            var tableView = NSTableView(frame:self.rectForCi(ci))

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
            let viewRect = self.rectForCi(ci)
            var scrollView = NSScrollView(frame: viewRect)
            var tableView = NSTableView(frame: viewRect)
            
            scrollView.hasVerticalScroller = true
            scrollView.hasHorizontalScroller = true
            scrollView.documentView = tableView
            scrollView.autoresizesSubviews = true

            tableView.usesAlternatingRowBackgroundColors = true
            tableView.columnAutoresizingStyle =
                NSTableViewColumnAutoresizingStyle.UniformColumnAutoresizingStyle
            tableView.rowHeight = 17.0
            tableView.autoresizesSubviews = true

            
            if ci.haveValues() {
                var listValues = self.valuesFromCi(ci)!
                let tableHeaderViewRect = NSMakeRect(0.0, 0.0, NSWidth(ci.rect), 22.0)
                var tableHeaderView = NSTableHeaderView(frame:tableHeaderViewRect)
                tableHeaderView.autoresizesSubviews = true
                tableView.headerView = tableHeaderView
                tableView.addSubview(tableHeaderView)
                
                for colText in listValues {
                    var tableColumn = NSTableColumn(identifier:colText)
                    //var headerCell = tableColumn.headerCell!
                    //headerCell.setStringValue(colText, resolvingEntities: false)
                    tableView.addTableColumn(tableColumn)
                }

                //tableView.setDataSource(self)
                tableView.setNeedsDisplay()
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
            var view = NSView(frame:self.rectForCi(ci))
            
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
                NSSecureTextField(frame:self.rectForCi(ci))
            
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
                NSProgressIndicator(frame:self.rectForCi(ci))
            
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
    
    func buttonClicked(obj:NSButton) {
        println("button clicked")
    }
    
    func createPushButton(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var pushButton = NSButton(frame:self.rectForCi(ci))
            if ci.haveText() {
                pushButton.title = ci.text!
            }
            
            pushButton.bezelStyle = NSBezelStyle.RoundRectBezelStyle
            
            //pushButton.target = self
            //pushButton.action = "buttonClicked:"
            
            //[pushButton setTarget:self];
            //[pushButton setAction:@selector(myAction:)];
            
            ci.controlType = CocoaDisplayEngine.ControlType.PushButton
            self.populateControl(pushButton, ci:ci)
            self.registerControl(pushButton, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createSlider(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var slider = NSSlider(frame:self.rectForCi(ci))
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
            var textField = NSTextField(frame:self.rectForCi(ci))
            
            if ci.haveText() {
                textField.stringValue = ci.text!
            }
            
            textField.bezeled = false
            textField.drawsBackground = false
            textField.editable = false
            textField.selectable = false
            
            ci.controlType = CocoaDisplayEngine.ControlType.StaticText
            self.populateControl(textField, ci:ci)
            self.registerControl(textField, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    func createTabView(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var tabView = NSTabView(frame:self.rectForCi(ci))
            
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
            var textView = NSTextView(frame:self.rectForCi(ci))
            
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
            var outlineView = NSOutlineView(frame:self.rectForCi(ci))
            
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
    
    func setFocus(cid: ControlId) -> Bool {
        if let view = self.controlFromCid(cid) {
            self.window.makeFirstResponder(view)
            return true
        }
        
        return false
    }
    
    func enableControl(cid: ControlId) -> Bool {
        return setEnabled(true, cid:cid)
    }
    
    func disableControl(cid: ControlId) -> Bool {
        return setEnabled(false, cid:cid)
    }
    
    func enableGroup(groupName: String) -> Bool {
        return self.setEnabled(true, groupName:groupName)
    }
    
    func disableGroup(groupName: String) -> Bool {
        return self.setEnabled(false, groupName:groupName)
    }
    
    func setEnabled(isEnabled: Bool, cid: ControlId) -> Bool {
        if let view = self.controlFromCid(cid) {
            if let control = view as? NSControl {
                control.enabled = isEnabled
            }
            
            return true
        }

        return false
    }
    
    func setEnabled(isEnabled: Bool, groupName: String) -> Bool {
        var optGroupControls = self.controlsForGroup(groupName)
        if optGroupControls {
            for view in optGroupControls! {
                if let control = view as? NSControl {
                    control.enabled = isEnabled
                }
            }
            
            return true
        }
        
        return false
    }
    
    func setSize(controlSize: NSSize, cid: ControlId) -> Bool {
        if let view = self.controlFromCid(cid) {
            var frame = view.frame
            frame.size = controlSize
            view.frame = frame
            return true
        }

        return false
    }
    
    func setPos(point: NSPoint, cid: ControlId) -> Bool {
        if let view = self.controlFromCid(cid) {
            var frame = view.frame
            frame.origin = point
            view.frame = frame
            return true
        }
        
        return false
    }
    
    func setRect(rect: NSRect, cid: ControlId) -> Bool {
        if let view = self.controlFromCid(cid) {
            view.frame = rect
            return true
        }
        
        return false
    }

    func setCheckBoxHandler(handler: CheckBoxHandler, cid: ControlId) -> Bool {
        let controlId = cid.controlId
        if controlId > -1 {
            self.mapCheckBoxHandlers[controlId] = handler
            return true
        }
        
        return false
    }

    func setPushButtonHandler(handler: PushButtonHandler, cid: ControlId) -> Bool {
        let controlId = cid.controlId
        if controlId > -1 {
            self.mapPushButtonHandlers[controlId] = handler
            return true
        }
        
        return false
    }

    func setTabViewHandler(handler: TabViewHandler, cid: ControlId) -> Bool {
        let controlId = cid.controlId
        if controlId > -1 {
            self.mapTabViewHandlers[controlId] = handler
            return true
        }
        
        return false
    }
    
    func setSliderHandler(handler: SliderHandler, cid: ControlId) -> Bool {
        let controlId = cid.controlId
        if controlId > -1 {
            self.mapSliderHandlers[controlId] = handler
            return true
        }
        
        return false
    }

}
