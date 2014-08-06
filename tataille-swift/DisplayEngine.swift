//
//  DisplayEngine.swift
//  tataille-swift
//
//  Created by Paul Dardeau on 8/1/14.
//  Copyright (c) 2014 SwampBits. All rights reserved.
//

import Foundation

protocol DisplayEngine {

    func run()
    
    func getDisplayEngineName() -> String
    func getDisplayEngineTechnology() -> String
    func getDisplayEngineLanguage() -> String
    func getDisplayEngineVersion() -> String

    func createWindow(windowId: Int, rect: NSRect) -> Bool
    func setRect(rect: NSRect, windowId: Int) -> Bool
    func setSize(windowSize: NSSize, windowId: Int) -> Bool
    func setPos(point: NSPoint, windowId: Int) -> Bool
    func hideWindow(windowId: Int) -> Bool
    func showWindow(windowId: Int) -> Bool
    func setVisible(isVisible: Bool, windowId: Int) -> Bool
    func setTitle(windowTitle: String, windowId: Int) -> Bool
    func closeWindow(windowId: Int) -> Bool
    
    // --------- possible control types --------
    // color picker (NSColorPicker)
    // timer
    // PDF file viewer (PDFDocument)
    // QuickTime movie player (QTKit, QTMovie)
    // Audio player
    
    func createCheckBox(ci: ControlInfo) -> Bool
    func createComboBox(ci: ControlInfo) -> Bool
    func createDatePicker(ci: ControlInfo) -> Bool
    func createEntryField(ci: ControlInfo) -> Bool
    func createGroupBox(ci: ControlInfo) -> Bool
    func createHtmlBrowser(ci: ControlInfo) -> Bool
    func createImageView(ci: ControlInfo) -> Bool
    func createLevelIndicator(ci: ControlInfo) -> Bool
    func createListBox(ci: ControlInfo) -> Bool
    func createListView(ci: ControlInfo) -> Bool
    func createPanel(ci: ControlInfo) -> Bool
    func createPasswordField(ci: ControlInfo) -> Bool
    func createProgressBar(ci: ControlInfo) -> Bool
    func createPushButton(ci: ControlInfo) -> Bool
    func createSegmentedControl(ci: ControlInfo) -> Bool
    func createSlider(ci: ControlInfo) -> Bool
    func createStaticText(ci: ControlInfo) -> Bool
    func createTabView(ci: ControlInfo) -> Bool
    func createTextView(ci: ControlInfo) -> Bool
    func createTree(ci: ControlInfo) -> Bool

    func setFocus(cid: ControlId) -> Bool
    
    func hideControl(cid: ControlId) -> Bool
    func showControl(cid: ControlId) -> Bool

    func hideGroup(groupName: String, windowId: Int) -> Bool
    func showGroup(groupName: String, windowId: Int) -> Bool
    func setVisible(isVisible: Bool, cid: ControlId) -> Bool
    func setVisible(isVisible: Bool, windowId: Int, groupName: String) -> Bool
    
    func enableControl(cid: ControlId) -> Bool
    func disableControl(cid: ControlId) -> Bool
    func enableGroup(groupName: String, windowId: Int) -> Bool
    func disableGroup(groupName: String, windowId: Int) -> Bool
    func setEnabled(isEnabled: Bool, cid: ControlId) -> Bool
    func setEnabled(isEnabled: Bool, windowId: Int, groupName: String) -> Bool
    
    func setSize(controlSize: NSSize, cid: ControlId) -> Bool
    func setPos(point: NSPoint, cid: ControlId) -> Bool
    func setRect(rect: NSRect, cid: ControlId) -> Bool
    
    // CheckBox
    //func setChecked(isChecked: Bool, cid:ControlId) -> Bool
    
    // ComboBox
    // addItem
    // insertItem
    // removeItem
    // selectItem
    // updateItem
    // clear or removeAll
    
    // EntryField
    // setText
    
    // GroupBox
    // setText
    
    // HtmlBrowser
    // setHtmlText
    // setUrl
    
    // ImageView
    // setImage
    
    // LevelIndicator
    // setLevel
    
    // ListBox
    // addItem
    // deselectItem
    // insertItem
    // removeItem
    // selectItem
    // updateItem
    // clear or removeAll
    
    // ListView
    func addRow(rowText: String, cid: ControlId) -> Bool
    func removeRow(rowIndex: Int, cid: ControlId) -> Bool
    // deselectRow
    // insert
    // selectRow
    // update
    // clear or removeAll
    
    // ProgressBar
    // setProgressPercent
    
    // PushButton
    // setText
    
    // Slider
    // setValue
    
    // StaticText
    // setText
    
    // TabView
    // addTab
    // insertTab
    // updateTab
    // removeTab
    // setTabEnabled
    // setTabVisible
    
    // TextView
    // setText
    
    // Tree
    
    func setCheckBoxHandler(handler: CheckBoxHandler, cid: ControlId) -> Bool
    func setComboBoxHandler(handler: ComboBoxHandler, cid: ControlId) -> Bool
    func setListBoxHandler(handler: ListBoxHandler, cid: ControlId) -> Bool
    func setListViewHandler(handler: ListViewHandler, cid: ControlId) -> Bool
    func setPushButtonHandler(handler: PushButtonHandler, cid: ControlId) -> Bool
    func setSliderHandler(handler: SliderHandler, cid: ControlId) -> Bool
    func setTabViewHandler(handler: TabViewHandler, cid: ControlId) -> Bool

}
