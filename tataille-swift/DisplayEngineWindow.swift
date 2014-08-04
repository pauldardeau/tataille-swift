//
//  DisplayEngineWindow.swift
//  tataille-swift
//
//  Created by Paul Dardeau on 8/1/14.
//  Copyright (c) 2014 SwampBits. All rights reserved.
//

import Foundation

protocol DisplayEngineWindow {
    
    func setWindowRect(rect: NSRect) -> Bool
    func setWindowSize(windowSize: NSSize) -> Bool
    func setWindowPos(point: NSPoint) -> Bool
    func hideWindow() -> Bool
    func showWindow() -> Bool
    func setWindowVisible(isVisible: Bool) -> Bool
    func setWindowTitle(windowTitle: String) -> Bool
    func closeWindow() -> Bool
    
    func createCheckBox(ci: ControlInfo) -> Bool
    func createComboBox(ci: ControlInfo) -> Bool
    func createEntryField(ci: ControlInfo) -> Bool
    func createGroupBox(ci: ControlInfo) -> Bool
    func createHtmlBrowser(ci: ControlInfo) -> Bool
    func createImageView(ci: ControlInfo) -> Bool
    func createListBox(ci: ControlInfo) -> Bool
    func createListView(ci: ControlInfo) -> Bool
    func createPanel(ci: ControlInfo) -> Bool
    func createPasswordField(ci: ControlInfo) -> Bool
    func createProgressBar(ci: ControlInfo) -> Bool
    func createPushButton(ci: ControlInfo) -> Bool
    func createSlider(ci: ControlInfo) -> Bool
    func createStaticText(ci: ControlInfo) -> Bool
    func createTabView(ci: ControlInfo) -> Bool
    func createTextView(ci: ControlInfo) -> Bool
    func createTree(ci: ControlInfo) -> Bool
    
    func setFocus(cid: ControlId) -> Bool

    func hideControl(cid: ControlId) -> Bool
    func showControl(cid: ControlId) -> Bool
    
    func hideGroup(groupName: String) -> Bool
    func showGroup(groupName: String) -> Bool
    func setVisible(isVisible: Bool, cid: ControlId) -> Bool
    func setVisible(isVisible: Bool, groupName: String) -> Bool
    
    func enableControl(cid: ControlId) -> Bool
    func disableControl(cid: ControlId) -> Bool
    func enableGroup(groupName: String) -> Bool
    func disableGroup(groupName: String) -> Bool
    func setEnabled(isEnabled: Bool, cid: ControlId) -> Bool
    func setEnabled(isEnabled: Bool, groupName: String) -> Bool
    
    func setSize(controlSize: NSSize, cid: ControlId) -> Bool
    func setPos(point: NSPoint, cid: ControlId) -> Bool
    func setRect(rect: NSRect, cid: ControlId) -> Bool
    
    func setCheckBoxHandler(handler: CheckBoxHandler, cid: ControlId) -> Bool
    func setComboBoxHandler(handler: ComboBoxHandler, cid: ControlId) -> Bool
    func setListBoxHandler(handler: ListBoxHandler, cid: ControlId) -> Bool
    //func setListSelectionHandler(handler: ListSelectionHandler, cid: ControlId) -> Bool
    func setPushButtonHandler(handler: PushButtonHandler, cid: ControlId) -> Bool
    func setSliderHandler(handler: SliderHandler, cid: ControlId) -> Bool
    func setTabViewHandler(handler: TabViewHandler, cid: ControlId) -> Bool

}