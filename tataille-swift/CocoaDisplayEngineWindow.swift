//
//  CocoaDisplayEngineWindow.swift
//  tataille-swift
//
//  Created by Paul Dardeau on 8/1/14.
//  Copyright (c) 2014 SwampBits. All rights reserved.
//

import Foundation
import Cocoa
import WebKit


// Enhancements
// ============
// status bar at bottom of window:
//    [theWindow setContentBorderThickness:24.0 forEdge:NSMinYEdge];
//    Don't forget to set autorecalculatesContentBorderThickness to NO
//    developer.apple.com/releasenotes/Cocoa/AppKit.html

class CocoaDisplayEngineWindow: NSObject,
                                DisplayEngineWindow,
                                NSComboBoxDelegate,
                                NSTableViewDataSource,
                                NSTableViewDelegate {
    
    var window: NSWindow!
    var windowView: NSView!
    var windowId: Int
    var mapControlIdToControl: Dictionary<Int, NSView>
    var mapControlToControlId: Dictionary<Int, Int> // <Hash(NSView), Int>
    var mapGroupControls: Dictionary<String, Array<NSView>>
    var mapListBoxDataSources: Dictionary<Int, Array<String>>  // <Hash(NSView), [String]>
    var mapListViewDataSources: Dictionary<Int, Array<Array<String>>> // <Hash(NSView), [[String]]>
    var mapListViewColumns: Dictionary<Int, Array<Int>> // Hash(NSView), Array<Hash(NSTableColumn)>
    var mapCheckBoxHandlers: Dictionary<Int, CheckBoxHandler>
    var mapComboBoxHandlers: Dictionary<Int, ComboBoxHandler>
    var mapListBoxHandlers: Dictionary<Int, ListBoxHandler>
    var mapListViewHandlers: Dictionary<Int, ListViewHandler>
    var mapPushButtonHandlers: Dictionary<Int, PushButtonHandler>
    var mapSliderHandlers: Dictionary<Int, SliderHandler>
    var mapTabViewHandlers: Dictionary<Int, TabViewHandler>
    var _translateYValues = true
    var logger = Logger(logLevel:Logger.LogLevel.Debug)

    //**************************************************************************
    
    init(window: NSWindow, windowId: Int) {
        self.window = window
        
        if let contentView = window.contentView as? NSView {
            self.windowView = contentView
        }
        
        self.windowId = windowId
        self.mapControlIdToControl = Dictionary<Int, NSView>()
        self.mapControlToControlId = Dictionary<Int, Int>()
        self.mapGroupControls = Dictionary<String, [NSView]>()
        self.mapListBoxDataSources = Dictionary<Int, [String]>()
        self.mapListViewDataSources = Dictionary<Int, [[String]]>()
        self.mapListViewColumns = Dictionary<Int, [Int]>()
        self.mapCheckBoxHandlers = Dictionary<Int, CheckBoxHandler>()
        self.mapComboBoxHandlers = Dictionary<Int, ComboBoxHandler>()
        self.mapListBoxHandlers = Dictionary<Int, ListBoxHandler>()
        self.mapListViewHandlers = Dictionary<Int, ListViewHandler>()
        self.mapPushButtonHandlers = Dictionary<Int, PushButtonHandler>()
        self.mapSliderHandlers = Dictionary<Int, SliderHandler>()
        self.mapTabViewHandlers = Dictionary<Int, TabViewHandler>()
    }

    //**************************************************************************
    
    func tableViewSelectionDidChange(notification: NSNotification!) {
        self.logger.debug("tableViewSelectionDidChange: combo box selection did change")
        
        if let aNotification = notification {
            if let obj: AnyObject = aNotification.object {
                if let tableView = obj as? NSTableView {
                    if let controlId = self.mapControlToControlId[tableView.hashValue] {
                        let selectedRowIndex = tableView.selectedRow
                        if let listBoxHandler = self.mapListBoxHandlers[controlId] {
                            listBoxHandler.listBoxItemSelected(selectedRowIndex)
                        } else {
                            if let listViewHandler = self.mapListViewHandlers[controlId] {
                                listViewHandler.listViewRowSelected(selectedRowIndex)
                            } else {
                                self.logger.debug("tableViewSelectionDidChange: no handler registered for table view")
                            }
                        }
                    } else {
                        self.logger.error("tableViewSelectionDidChange: unable to find control id for table view")
                    }
                } else {
                    self.logger.error("tableViewSelectionDidChange: control is not a NSTableView")
                }
            } else {
                self.logger.error("tableViewSelectionDidChange: no object available in notification")
            }
        } else {
            self.logger.error("tableViewSelectionDidChange: no notification object available")
        }
    }

    //**************************************************************************

    func comboBoxSelectionDidChange(notification: NSNotification!) {
        self.logger.debug("comboBoxSelectionDidChange: combo box selection did change")
        
        if let aNotification = notification {
            if let obj: AnyObject = aNotification.object {
                if let comboBox = obj as? NSComboBox {
                    if let controlId = self.mapControlToControlId[comboBox.hashValue] {
                        if let handler = self.mapComboBoxHandlers[controlId] {
                            handler.combBoxItemSelected(comboBox.indexOfSelectedItem)
                        } else {
                            self.logger.debug("comboBoxSelectionDidChange: no handler registered for combobox")
                        }
                    } else {
                        self.logger.error("comboBoxSelectionDidChange: unable to find control id for combo box")
                    }
                } else {
                    self.logger.error("comboBoxSelectionDidChange: control is not a NSComboBox")
                }
            } else {
                self.logger.error("comboBoxSelectionDidChange: no object available in notification")
            }
        } else {
            self.logger.error("comboBoxSelectionDidChange: no notification object available")
        }
    }
    
    //**************************************************************************

    func comboBoxSelectionIsChanging(notification: NSNotification!) {
        //println("combo box selection is changing")
    }

    //**************************************************************************

    func comboBoxWillDismiss(notification: NSNotification!)  {
        //println("combo box will dismiss")
    }

    //**************************************************************************

    func comboBoxWillPopUp(notification: NSNotification!) {
        //println("combo box will popup")
    }

    //**************************************************************************

    func setTranslateYValues(translateYValues: Bool) {
        self._translateYValues = translateYValues
    }
    
    //**************************************************************************

    func translateYValues() -> Bool {
        return self._translateYValues
    }

    //**************************************************************************

    func controlsForGroup(groupName: String) -> [NSView]? {
        return self.mapGroupControls[groupName]
    }

    //**************************************************************************

    func controlFromControlId(controlId: Int) -> NSView? {
        var control: NSView?
    
        if controlId > -1 {
            control = self.mapControlIdToControl[controlId]
        }
    
        return control
    }

    //**************************************************************************

    func controlFromCid(cid: ControlId) -> NSView? {
        return self.controlFromControlId(cid.controlId)
    }

    //**************************************************************************

    func valuesFromCi(ci: ControlInfo) -> [String]? {
        var listValues: [String]?
    
        if ci.haveValues() {
            listValues = ci.getValues(",")
        }
    
        return listValues
    }

    //**************************************************************************

    func populateControl(view: NSView, ci:ControlInfo) {
        //view.tag = ci.cid.controlId;
    
        if let helpCaption = ci.helpCaption {
            view.toolTip = helpCaption
        }
    
        if !ci.isVisible {
            view.hidden = !ci.isVisible
        }
        
        if ci.haveForegroundColor() {
            let fgColor = self.colorFromString(ci.foregroundColor! as NSString)
            //TODO: set foreground color
        }
        
        if ci.haveBackgroundColor() {
            let bgColor = self.colorFromString(ci.backgroundColor! as NSString)
            //TODO: set background color
        }
    
        if !ci.isEnabled || ci.isSelected {
            if let control = view as? NSControl {
                if !ci.isEnabled {
                    control.enabled = false
                }
                
                //TODO: if isSelected only applies to checkbox, take it out
                //      of ControlInfo
                if ci.isSelected {
                    //TODO:
                }
            }
        }
    
        self.windowView!.addSubview(view)
    }

    //**************************************************************************

    func registerControl(control: NSView, ci:ControlInfo) {
        self.mapControlIdToControl[ci.cid.controlId] = control
        self.mapControlToControlId[control.hashValue] = ci.cid.controlId
        
        if let groupName = ci.groupName {
            var optListControls = self.mapGroupControls[groupName]
            if optListControls != nil {
                var listControls = optListControls!
                listControls.append(control)
            } else {
                var listControls = [NSView]()
                listControls.append(control)
                self.mapGroupControls[groupName] = listControls
            }
        }
    }

    //**************************************************************************

    func numberOfRowsInTableView(aTableView: NSTableView!) -> Int {
        if let tv = aTableView {
            // is it a listbox?
            let hash = tv.hashValue
            if let listValues = self.mapListBoxDataSources[hash] {
                return listValues.count
            } else {
                if let listViewValues = self.mapListViewDataSources[hash] {
                    return listViewValues.count
                } else {
                    self.logger.error("numberOfRowsInTableView: no datasource available for listview")
                    return 0
                }
            }
        } else {
            self.logger.error("numberOfRowsInTableView: no tableview provided")
            return 0
        }
    }

    //**************************************************************************

    func tableView(aTableView: NSTableView!,
                   objectValueForTableColumn tableColumn: NSTableColumn!,
                   row: Int) -> AnyObject! {
        //self.logger.debug("tableView objectValueForTableColumn")

        if let tv = aTableView {
            let hash = tv.hashValue

            // is it a listbox?
            if let listValues = self.mapListBoxDataSources[hash] {
                return listValues[row]
            } else {
                if let listRowValues = self.mapListViewDataSources[hash] {
                    if row < listRowValues.count {
                        //self.logger.debug("non-empty list of values found")
                        let rowValues = listRowValues[row]
                        
                        if !rowValues.isEmpty {
                            if var listColumns = self.mapListViewColumns[hash] {
                                var colIndex = 0
                                let hashTargetColumn = tableColumn!.hashValue
                                
                                for hashColumn in listColumns {
                                    if hashColumn == hashTargetColumn {
                                        break
                                    } else {
                                        ++colIndex
                                    }
                                }
                                
                                if colIndex < rowValues.count {
                                    return rowValues[colIndex]
                                } else {
                                    // log error
                                    self.logger.error("objectValueForTableColumn: column index beyond max values index")
                                    return ""
                                }
                            } else {
                                // log error
                                self.logger.error("objectValueForTableColumn: no table columns registered for NSTableView")
                                return ""
                            }
                        } else {
                            self.logger.error("objectValueForTableColumn: no column data available")
                            return ""
                        }

                    } else {
                        self.logger.debug("no value available in list")
                        return "xvalue"
                    }
                } else {
                    self.logger.debug("no data source found")
                    return ""
                }
            }
        } else {
            self.logger.error("objectValueForTableColumn: aTableView is nil")
            return ""
        }
    }
    
    //**************************************************************************

    func tableView(aTableView: NSTableView!,
                   viewForTableColumn tableColumn: NSTableColumn!,
                   row rowIndex: Int) -> NSView! {
                    
        //self.logger.debug("tableView viewForTableColumn")

        var view: NSView!
        if let tv = aTableView {
            var tf: NSTextField!
            var optView: AnyObject! = tv.makeViewWithIdentifier("TVCTF", owner: self)
            if let aTextField = optView as? NSTextField {
                tf = aTextField
            } else {
                tf = NSTextField(frame:CGRectZero)
                tf.bezeled = false
                tf.drawsBackground = false
                tf.editable = false
                tf.selectable = false
            }
            
            if let textField = tf {
                let hash = tv.hashValue
                
                // is it a listbox?
                if let listValues = self.mapListBoxDataSources[hash] {
                    textField.stringValue = listValues[rowIndex]
                } else {
                    if let listRowValues = self.mapListViewDataSources[hash] {
                        if rowIndex < listRowValues.count {
                            let rowValues = listRowValues[rowIndex]
                            if !rowValues.isEmpty {
                                if var listColumns = self.mapListViewColumns[hash] {
                                    var colIndex = 0
                                    let hashTargetColumn = tableColumn!.hashValue
                                    
                                    for hashColumn in listColumns {
                                        if hashColumn == hashTargetColumn {
                                            break
                                        } else {
                                            ++colIndex
                                        }
                                    }
                                    
                                    if colIndex < rowValues.count {
                                        textField.stringValue = rowValues[colIndex]
                                    } else {
                                        // log error
                                        self.logger.error("viewForTableColumn: column index beyond max values index")
                                    }
                                } else {
                                    // log error
                                    self.logger.error("viewForTableColumn: no table columns registered for NSTableView")
                                }
                            } else {
                                self.logger.error("viewForTableColumn: no column data available")
                                textField.stringValue = ""
                            }
                        } else {
                            self.logger.error("viewForTableColumn: no row data available")
                            textField.stringValue = ""
                        }
                    } else {
                        self.logger.error("viewForTableColumn: no data source for listview")
                        textField.stringValue = ""
                    }
                }
                
                view = tf
            } else {
                self.logger.error("viewForTableColumn: view is not a textfield")
            }
        } else {
            self.logger.error("viewForTableColumn: no tableview provided")
        }
                    
        return view
    }

    //**************************************************************************

    func isControlInfoValid(ci: ControlInfo) -> Bool {
        return ci.isValid()
    }

    //**************************************************************************

    func setWindowRect(rect: NSRect) -> Bool {
        if let theWindow = self.window {
            theWindow.setFrame(rect, display: true)
            return true
        }
        
        return false
    }
    
    //**************************************************************************

    func setWindowSize(windowSize: NSSize) -> Bool {
        //TODO:
        return false
    }

    //**************************************************************************

    func setWindowPos(point: NSPoint) -> Bool {
        //TODO:
        return false
    }

    //**************************************************************************

    func hideWindow() -> Bool {
        return self.setWindowVisible(false)
    }

    //**************************************************************************

    func showWindow() -> Bool {
        return self.setWindowVisible(true)
    }
    
    //**************************************************************************

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

    //**************************************************************************

    func setWindowTitle(windowTitle: String) -> Bool {
        if let theWindow = self.window {
            theWindow.title = windowTitle
            return true
        }
        
        return false
    }
    
    //**************************************************************************

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

    //**************************************************************************

    func translateRectYValues(rect: NSRect) -> NSRect {
        let windowRect = self.windowView!.frame
        var translatedRect = NSMakeRect(0, 0, 0, 0)
        translatedRect.origin.x = rect.origin.x
        translatedRect.origin.y = windowRect.size.height - rect.origin.y - rect.size.height
        translatedRect.size.width = rect.size.width
        translatedRect.size.height = rect.size.height
            
        return translatedRect
    }

    //**************************************************************************

    func translateYValues(ci: ControlInfo) -> NSRect {
        // do we have a parent?
        if ci.haveParent() {
            //TODO: implement translation for control with a parent
            return ci.rect;
        } else {
            return self.translateRectYValues(ci.rect)
        }
    }
    
    //**************************************************************************

    func rectForCi(ci: ControlInfo) -> NSRect {
        if self.translateYValues() {
            return self.translateYValues(ci)
        } else {
            return ci.rect
        }
    }

    //**************************************************************************
    
    class func hexDigitToInt(hexDigit: NSString) -> Int {
        let digits: NSString = "0123456789"
        let rangeDigit = digits.rangeOfString(hexDigit)
        
        if rangeDigit.location != NSNotFound {
            return rangeDigit.location
        } else {
            let lowerHexDigit: NSString = hexDigit.lowercaseString
            let hexDigits: NSString = "abcdef"
            let rangeHexDigit = hexDigits.rangeOfString(lowerHexDigit)
            if rangeHexDigit.location != NSNotFound {
                return 10 + rangeHexDigit.location
            } else {
                return -1
            }
        }
    }

    //**************************************************************************

    class func hexStringToInt(hexString: NSString) -> Int {
        var intValue = 0
        
        let firstDigitValue =
            CocoaDisplayEngineWindow.hexDigitToInt(hexString.substringToIndex(1))
        if firstDigitValue > -1 {
            intValue = firstDigitValue * 16
            
            let secondDigitValue = CocoaDisplayEngineWindow.hexDigitToInt(hexString.substringWithRange(NSMakeRange(1,1)))
            if secondDigitValue > -1 {
                intValue += secondDigitValue
            } else {
                intValue = -1
            }
        } else {
            intValue = -1
        }
        
        return intValue
    }

    //**************************************************************************

    func colorFromString(colorString: String) -> NSColor {
        var color = NSColor.blackColor()
        
        if colorString.hasPrefix("color:") {
            let colorName: String = (colorString as NSString).substringFromIndex(6)
            
            if colorName == "black" {
                color = NSColor.blackColor()
            } else if colorName == "blue" {
                color = NSColor.blueColor()
            } else if colorName == "brown" {
                color = NSColor.brownColor()
            } else if colorName == "clear" {
                color = NSColor.clearColor()
            } else if colorName == "cyan" {
                color = NSColor.cyanColor()
            } else if colorName == "darkGray" {
                color = NSColor.darkGrayColor()
            } else if colorName == "gray" {
                color = NSColor.grayColor()
            } else if colorName == "green" {
                color = NSColor.greenColor()
            } else if colorName == "lightGray" {
                color = NSColor.lightGrayColor()
            } else if colorName == "magenta" {
                color = NSColor.magentaColor()
            } else if colorName == "orange" {
                color = NSColor.orangeColor()
            } else if colorName == "purple" {
                color = NSColor.purpleColor()
            } else if colorName == "red" {
                color = NSColor.redColor()
            } else if colorName == "white" {
                color = NSColor.whiteColor()
            } else if colorName == "yellow" {
                color = NSColor.yellowColor()
            } else {
                self.logger.error("colorFromString: unrecognized color value ' \(colorName)'")
            }
        } else if colorString.hasPrefix("rgb:") {
            let colorValues = colorString.componentsSeparatedByString(",")
            if colorValues.count > 2 {
                let redIntValue: Int? = colorValues[0].toInt()
                let greenIntValue: Int? = colorValues[1].toInt()
                let blueIntValue: Int? = colorValues[2].toInt()
                if redIntValue != nil && greenIntValue != nil && blueIntValue != nil {
                    //TODO: check that values are between 0-255
                    let red = redIntValue!
                    let green = greenIntValue!
                    let blue = blueIntValue!
                    if red >= 0 && red <= 255 && green >= 0 && green <= 255 && blue >= 0 && blue <= 255 {
                        let redValue: CGFloat = CGFloat(red) / 255.0
                        let greenValue: CGFloat = CGFloat(green) / 255.0
                        let blueValue: CGFloat = CGFloat(blue) / 255.0
                        color = NSColor(red:redValue, green: greenValue, blue: blueValue, alpha: 1.0)
                    } else {
                        // log error
                    }
                } else {
                    // log error
                }
            } else {
                // log error
            }
        } else if colorString.hasPrefix("hexRGB:") {
            let colorValues: NSString = (colorString as NSString).substringFromIndex(7)
            if colorValues.length == 6 {
                let redString = colorValues.substringToIndex(2)
                let greenString = colorValues.substringWithRange(NSMakeRange(2,2))
                let blueString = colorValues.substringFromIndex(4)
                
                let red = CocoaDisplayEngineWindow.hexStringToInt(redString)
                let green = CocoaDisplayEngineWindow.hexStringToInt(greenString)
                let blue = CocoaDisplayEngineWindow.hexStringToInt(blueString)
                
                if red > -1 && green > -1 && blue > -1 {
                    let redValue: CGFloat = CGFloat(red) / 255.0
                    let greenValue: CGFloat = CGFloat(green) / 255.0
                    let blueValue: CGFloat = CGFloat(blue) / 255.0
                    color = NSColor(red:redValue, green: greenValue, blue: blueValue, alpha: 1.0)
                } else {
                    // log error
                }
            } else {
                // log error
            }
        } else {
            self.logger.error("colorFromString: unrecognized color value ' \(colorString)'")
        }

        return color
    }

    //**************************************************************************

    func checkBoxToggled(obj:NSButton) {
        self.logger.debug("checkBoxToggled: check box toggled")
        
        if let controlId = self.mapControlToControlId[obj.hashValue] {
            if let handler = self.mapCheckBoxHandlers[controlId] {
                handler.checkBoxToggled(true)
            } else {
                self.logger.debug("checkBoxToggled: no handler registered for checkbox")
            }
        } else {
            self.logger.error("checkBoxToggled: unable to find control id for checkbox")
        }
    }

    //**************************************************************************

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
            
            checkBox.target = self
            checkBox.action = "checkBoxToggled:"
            
            ci.controlType = CocoaDisplayEngine.ControlType.CheckBox;
            self.populateControl(checkBox, ci:ci)
            self.registerControl(checkBox, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }

    //**************************************************************************

    func comboBoxSelectionChange(obj: NSComboBox) {
    }
    
    //**************************************************************************
    
    func createColorWell(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var colorWell = NSColorWell(frame:self.rectForCi(ci))
            
            if ci.haveValues() {
                colorWell.color = self.colorFromString(ci.values!)
            }
            
            //TODO: respond to changes in color selection
            
            ci.controlType = CocoaDisplayEngine.ControlType.ColorWell
            self.populateControl(colorWell, ci:ci)
            self.registerControl(colorWell, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }

    //**************************************************************************

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
            
            comboBox.setDelegate(self)
            
            ci.controlType = CocoaDisplayEngine.ControlType.ComboBox
            self.populateControl(comboBox, ci:ci)
            self.registerControl(comboBox, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    //**************************************************************************
    
    func createDatePicker(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var datePicker = NSDatePicker(frame:self.rectForCi(ci))
            
            if ci.haveText() {
                //TODO:
                //textField.stringValue = ci.text!
            }
            
            ci.controlType = CocoaDisplayEngine.ControlType.DatePicker
            self.populateControl(datePicker, ci:ci)
            self.registerControl(datePicker, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }

    //**************************************************************************

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
    
    //**************************************************************************

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
    
    //**************************************************************************

    func createHtmlBrowser(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var webView = WebView(frame:self.rectForCi(ci))
            
            if ci.haveValues() {
                let value = ci.values!
                // does it look like a URL?
                if value.hasPrefix("http") {
                    let url = NSURL(string:value)
                    let urlRequest = NSURLRequest(URL: url)
                    webView.mainFrame.loadRequest(urlRequest)
                } else {
                    // treat the value as HTML content and set it in the browser
                    webView.mainFrame.loadHTMLString(value, baseURL: nil)
                }
            }
            
            ci.controlType = CocoaDisplayEngine.ControlType.HtmlBrowser
            self.populateControl(webView, ci:ci)
            self.registerControl(webView, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    //**************************************************************************

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
    
    //**************************************************************************

    func createLevelIndicator(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var levelIndicator = NSLevelIndicator(frame:self.rectForCi(ci))
            
            levelIndicator.minValue = 0.0
            levelIndicator.maxValue = 0.0
            
            if ci.haveValues() {
                //TODO:
            }
            
            ci.controlType = CocoaDisplayEngine.ControlType.LevelIndicator
            self.populateControl(levelIndicator, ci:ci)
            self.registerControl(levelIndicator, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }

    //**************************************************************************

    func createListBox(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var tableView = NSTableView(frame:self.rectForCi(ci))

            var tableColumn = NSTableColumn(identifier:"listColumn")
            tableView.addTableColumn(tableColumn)
            
            let hash = tableView.hashValue

            if ci.haveValues() {
                var listValues = self.valuesFromCi(ci)!
                self.mapListBoxDataSources[hash] = listValues
            } else {
                self.mapListBoxDataSources[hash] = Array<String>()
            }
            
            tableView.setDataSource(self)
            tableView.setDelegate(self)
            
            ci.controlType = CocoaDisplayEngine.ControlType.ListBox
            self.populateControl(tableView, ci:ci)
            self.registerControl(tableView, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    //**************************************************************************

    func createListView(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            let viewRect = self.rectForCi(ci)
            var scrollView = NSScrollView(frame: viewRect)
            var tableView = NSTableView(frame: viewRect)
            let hash = tableView.hashValue
            
            scrollView.hasVerticalScroller = true
            scrollView.hasHorizontalScroller = true
            scrollView.documentView = tableView
            //scrollView.autoresizesSubviews = true

            tableView.usesAlternatingRowBackgroundColors = true
            tableView.columnAutoresizingStyle =
                NSTableViewColumnAutoresizingStyle.UniformColumnAutoresizingStyle
            tableView.rowHeight = 17.0
            //tableView.autoresizesSubviews = true
            
            self.mapListViewDataSources[hash] = Array<Array<String>>()
            
            var listColumns = Array<Int>()
            
            if ci.haveValues() {
                var listValues = self.valuesFromCi(ci)!
                let tableHeaderViewRect = NSMakeRect(0.0, 0.0, NSWidth(ci.rect), 22.0)
                var tableHeaderView = NSTableHeaderView(frame:tableHeaderViewRect)
                //tableHeaderView.autoresizesSubviews = true
                tableView.headerView = tableHeaderView
                tableView.addSubview(tableHeaderView)
                
                for colText in listValues {
                    var tableColumn = NSTableColumn(identifier:colText)
                    let hashTableColumn = tableColumn.hashValue
                    
                    listColumns.append(hashTableColumn)
                    let colIndex = listColumns.count - 1
                    //println("registering column '\(colText)' at index \(colIndex)")
                    
                    //NSTableCellView
                    //var headerCell = tableColumn.headerCell!
                    //headerCell.setStringValue(colText, resolvingEntities: false)
                    tableView.addTableColumn(tableColumn)
                }
            }
            
            self.mapListViewColumns[hash] = listColumns

            tableView.setDataSource(self)
            tableView.setDelegate(self)
            tableView.setNeedsDisplay()

            ci.controlType = CocoaDisplayEngine.ControlType.ListView
            self.populateControl(tableView, ci:ci)
            self.registerControl(tableView, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    //**************************************************************************

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

    //**************************************************************************

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
    
    //**************************************************************************

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

    //**************************************************************************

    func pushButtonClicked(obj:NSButton) {
        self.logger.debug("pushButtonClicked: push button clicked")

        if let controlId = self.mapControlToControlId[obj.hashValue] {
            if let handler = self.mapPushButtonHandlers[controlId] {
                handler.pushButtonClicked()
            } else {
                self.logger.debug("pushButtonClicked: no handler registered for push button")
            }
        } else {
            self.logger.error("pushButtonClicked: can't map push button to cid")
        }
    }
    
    //**************************************************************************

    func createPushButton(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var pushButton = NSButton(frame:self.rectForCi(ci))
            if ci.haveText() {
                pushButton.title = ci.text!
            }
            
            pushButton.bezelStyle = NSBezelStyle.RoundRectBezelStyle
            
            pushButton.target = self
            pushButton.action = "pushButtonClicked:"
            
            ci.controlType = CocoaDisplayEngine.ControlType.PushButton
            self.populateControl(pushButton, ci:ci)
            self.registerControl(pushButton, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }
    
    //**************************************************************************
    
    func createSegmentedControl(ci: ControlInfo) -> Bool {
        var controlCreated = false
        
        if self.isControlInfoValid(ci) {
            var segmentedControl = NSSegmentedControl(frame:self.rectForCi(ci))
            
            if ci.haveValues() {
                var listValues = self.valuesFromCi(ci)!
                segmentedControl.segmentCount = listValues.count
                
                var i = 0
                
                for segmentText in listValues {
                    segmentedControl.setLabel(segmentText, forSegment: i)
                    ++i
                }
            }
            
            // TexturedRounded, RoundedRect, Capsule, SmallSqure
            let style = NSSegmentStyle.Rounded
            
            segmentedControl.segmentStyle = style
            
            //segmentedControl.target = self
            //segmentedControl.action = "pushButtonClicked:"
            
            ci.controlType = CocoaDisplayEngine.ControlType.SegmentedControl
            self.populateControl(segmentedControl, ci:ci)
            self.registerControl(segmentedControl, ci:ci)
            controlCreated = true
        }
        
        return controlCreated
    }

    //**************************************************************************

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

    //**************************************************************************

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
    
    //**************************************************************************

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

    //**************************************************************************

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
    
    //**************************************************************************

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

    //**************************************************************************

    func hideControl(cid: ControlId) -> Bool {
        return self.setVisible(false, cid:cid)
    }

    //**************************************************************************

    func showControl(cid: ControlId) -> Bool {
        return self.setVisible(true, cid:cid)
    }

    //**************************************************************************

    func hideGroup(groupName: String) -> Bool {
        return setVisible(false, groupName:groupName)
    }

    //**************************************************************************

    func showGroup(groupName: String) -> Bool {
        return setVisible(true, groupName:groupName)
    }
    
    //**************************************************************************

    func setVisible(isVisible: Bool, cid: ControlId) -> Bool {
        
        if let view = self.controlFromCid(cid) {
            view.hidden = !isVisible
            return true
        }
        
        return false
    }

    //**************************************************************************

    func setVisible(isVisible: Bool, groupName: String) -> Bool {
        var optGroupControls = self.controlsForGroup(groupName)
        if optGroupControls != nil {
            let isHidden = !isVisible
            
            for view in optGroupControls! {
                view.hidden = isHidden
            }
            
            return true
        }
        
        return false
    }
    
    //**************************************************************************

    func setFocus(cid: ControlId) -> Bool {
        if let view = self.controlFromCid(cid) {
            self.window.makeFirstResponder(view)
            return true
        }
        
        return false
    }

    //**************************************************************************

    func enableControl(cid: ControlId) -> Bool {
        return setEnabled(true, cid:cid)
    }

    //**************************************************************************

    func disableControl(cid: ControlId) -> Bool {
        return setEnabled(false, cid:cid)
    }

    //**************************************************************************

    func enableGroup(groupName: String) -> Bool {
        return self.setEnabled(true, groupName:groupName)
    }

    //**************************************************************************

    func disableGroup(groupName: String) -> Bool {
        return self.setEnabled(false, groupName:groupName)
    }
    
    //**************************************************************************

    func setEnabled(isEnabled: Bool, cid: ControlId) -> Bool {
        if let view = self.controlFromCid(cid) {
            if let control = view as? NSControl {
                control.enabled = isEnabled
            }
            
            return true
        }

        return false
    }

    //**************************************************************************

    func setEnabled(isEnabled: Bool, groupName: String) -> Bool {
        if var optGroupControls = self.controlsForGroup(groupName) {
            for view in optGroupControls {
                if let control = view as? NSControl {
                    control.enabled = isEnabled
                }
            }
            
            return true
        }
        
        return false
    }

    //**************************************************************************

    func setSize(controlSize: NSSize, cid: ControlId) -> Bool {
        if let view = self.controlFromCid(cid) {
            var frame = view.frame
            frame.size = controlSize
            view.frame = frame
            return true
        }

        return false
    }

    //**************************************************************************

    func setPos(point: NSPoint, cid: ControlId) -> Bool {
        if let view = self.controlFromCid(cid) {
            var frame = view.frame
            frame.origin = point
            view.frame = frame
            return true
        }
        
        return false
    }

    //**************************************************************************

    func setRect(rect: NSRect, cid: ControlId) -> Bool {
        if let view = self.controlFromCid(cid) {
            view.frame = rect
            return true
        }
        
        return false
    }

    //**************************************************************************
    
    func showListViewDataSource(ds:[[String]]) {
        var i = 0
        
        for row in ds {
            print("row \(i): ")
            
            var j = 0
            for col in row {
                if j > 0 {
                    print(",")
                }
                print("\(col)")
                ++j
            }
            println("")
            ++i
        }
        
        if i == 0 {
            println("<no data>")
        }
    }

    //**************************************************************************

    func addRow(rowText: String, cid: ControlId) -> Bool {
        if let view = self.controlFromCid(cid) {
            if let listView = view as? NSTableView {
                let hash = listView.hashValue
                
                //println("adding row to view: \(hash)")
                
                if var ds = self.mapListViewDataSources[hash] {
                    let parsedValues: [String] = rowText.componentsSeparatedByString(",")
                    
                    //let beforeLen = ds.count
                    //println("======== before appending row ==========")
                    //println("len(dataSource) = \(beforeLen)")
                    //self.showListViewDataSource(ds)
                    
                    ds.append(parsedValues)
                        
                    //let afterLen = ds.count
                    //println("-------- after appending row ----------")
                    //println("len(dataSource) = \(afterLen)")
                    //self.showListViewDataSource(ds)
                    
                    // IMPORTANT: swift passes arrays by VALUE, so we have to
                    // update what's stored!
                    self.mapListViewDataSources[hash] = ds
                    
                    listView.reloadData()
                    listView.needsDisplay = true

                    return true
                } else {
                    self.logger.error("addRow: no data source exists for ListView")
                }
            } else {
                self.logger.error("addRow: control is not a NSTableView")
            }
        } else {
            self.logger.error("addRow: invalid ControlId")
        }

        return false
    }

    //**************************************************************************

    func removeRow(rowIndex: Int, cid: ControlId) -> Bool {
        if let view = self.controlFromCid(cid) {
            if let listView = view as? NSTableView {
                let hash = listView.hashValue
                println("removing row from view: \(hash)")
                if var ds = self.mapListViewDataSources[hash] {
                    
                    let beforeLen = ds.count
                    println("======== before removing row ==========")
                    println("len(dataSource) = \(beforeLen)")
                    self.showListViewDataSource(ds)
                    
                    ds.removeAtIndex(rowIndex)
                    
                    let afterLen = ds.count
                    
                    println("-------- after removing row ----------")
                    println("len(dataSource) = \(afterLen)")
                    self.showListViewDataSource(ds)
                    
                    listView.reloadData()
                    
                    listView.needsDisplay = true
                    return true
                } else {
                    self.logger.error("removeRow: no data source exists for ListView")
                }
            } else {
                self.logger.error("removeRow: control is not a NSTableView")
            }
        } else {
            self.logger.error("removeRow: invalid ControlId")
        }

        return false
    }

    //**************************************************************************

    func setCheckBoxHandler(handler: CheckBoxHandler, cid: ControlId) -> Bool {
        let controlId = cid.controlId
        if controlId > -1 {
            self.mapCheckBoxHandlers[controlId] = handler
            return true
        }
        
        return false
    }

    //**************************************************************************

    func setComboBoxHandler(handler: ComboBoxHandler, cid: ControlId) -> Bool {
        let controlId = cid.controlId
        if controlId > -1 {
            self.mapComboBoxHandlers[controlId] = handler
            return true
        }
        
        return false
    }

    //**************************************************************************

    func setListBoxHandler(handler: ListBoxHandler, cid: ControlId) -> Bool {
        let controlId = cid.controlId
        if controlId > -1 {
            self.mapListBoxHandlers[controlId] = handler
            return true
        }
        
        return false
    }

    //**************************************************************************

    func setListViewHandler(handler: ListViewHandler, cid: ControlId) -> Bool {
        let controlId = cid.controlId
        if controlId > -1 {
            self.mapListViewHandlers[controlId] = handler
            return true
        }
        
        return false
    }
    
    //**************************************************************************

    func setPushButtonHandler(handler: PushButtonHandler, cid: ControlId) -> Bool {
        let controlId = cid.controlId
        if controlId > -1 {
            self.mapPushButtonHandlers[controlId] = handler
            return true
        }
        
        return false
    }

    //**************************************************************************

    func setTabViewHandler(handler: TabViewHandler, cid: ControlId) -> Bool {
        let controlId = cid.controlId
        if controlId > -1 {
            self.mapTabViewHandlers[controlId] = handler
            return true
        }
        
        return false
    }

    //**************************************************************************

    func setSliderHandler(handler: SliderHandler, cid: ControlId) -> Bool {
        let controlId = cid.controlId
        if controlId > -1 {
            self.mapSliderHandlers[controlId] = handler
            return true
        }
        
        return false
    }

    //**************************************************************************

}
