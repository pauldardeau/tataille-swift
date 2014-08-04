//
//  AppDelegate.swift
//  tataille-swift
//
//  Created by Paul Dardeau on 8/1/14.
//  Copyright (c) 2014 SwampBits. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet weak var window: NSWindow!
    
    let WINDOW_WIDTH: CGFloat = 600.0
    let WINDOW_HEIGHT: CGFloat = 500.0
    let BUTTON_WIDTH: CGFloat = 120.0
    let BUTTON_HEIGHT: CGFloat = 44.0
    let LABEL_HEIGHT: CGFloat = 30.0
    let LEFT_EDGE: CGFloat = 25.0
    let LBL_CUSTOMER_WIDTH: CGFloat = 65.0
    let EF_CUSTOMER_WIDTH: CGFloat = 200.0
    let EF_CUSTOMER_HEIGHT: CGFloat = 24.0
    let CK_DELIVERY_WIDTH: CGFloat = 100.0
    let CK_DELIVERY_HEIGHT: CGFloat = 30.0
    let CK_RUSH_WIDTH: CGFloat = 100.0
    let CK_RUSH_HEIGHT: CGFloat = 30.0
    let LIST_WIDTH: CGFloat = 130.0
    let LIST_HEIGHT: CGFloat = 270.0
    let LISTVIEW_WIDTH: CGFloat = 325.0
    let LBL_ORDERTOTAL_WIDTH: CGFloat = 65.0
    let VALUES_DELIMITER = ","

    
    var displayEngine: CocoaDisplayEngine!
    var cidCustomerLabel: ControlId!
    var cidEntryField: ControlId!
    var cidCheckDelivery: ControlId!
    var cidCheckRush: ControlId!
    var cidListBox: ControlId!
    var cidListView: ControlId!
    var cidAddButton: ControlId!
    var cidRemoveButton: ControlId!
    var cidOrderButton: ControlId!
    var cidOrderTotal: ControlId!


    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        self.displayEngine = CocoaDisplayEngine(mainWindow:self.window!)
        self.startApp();
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }

    func startApp() {
        let TOP: CGFloat = 75
        let LBL_CUSTOMER_HEIGHT = LABEL_HEIGHT
        let LISTVIEW_HEIGHT = LIST_HEIGHT
        let BTN_ADD_WIDTH = BUTTON_WIDTH
        let BTN_ADD_HEIGHT = BUTTON_HEIGHT
        let BTN_REMOVE_WIDTH = BUTTON_WIDTH
        let BTN_REMOVE_HEIGHT = BUTTON_HEIGHT
        let BTN_ORDER_WIDTH = BUTTON_WIDTH
        let BTN_ORDER_HEIGHT = BUTTON_HEIGHT
        let LBL_ORDERTOTAL_HEIGHT = LABEL_HEIGHT
        
        var de = self.displayEngine!

        var ci: ControlInfo
        let windowId: Int = 0 //DisplayEngine.ID_MAIN_WINDOW;
        var controlId: Int = 0
        var x = LEFT_EDGE
        var y = TOP
        var topRowText = y + 4
    
        self.cidCustomerLabel = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidCustomerLabel!)
        ci.rect = NSMakeRect(x, topRowText, LBL_CUSTOMER_WIDTH, LBL_CUSTOMER_HEIGHT)
        ci.text = "Customer:"
        de.createStaticText(ci)
    
        x += LBL_CUSTOMER_WIDTH
        x += 10
    
        self.cidEntryField = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidEntryField)
        ci.rect = NSMakeRect(x, y, EF_CUSTOMER_WIDTH, EF_CUSTOMER_HEIGHT)
        self.displayEngine.createEntryField(ci)
    
        x += EF_CUSTOMER_WIDTH
        x += 20
    
        self.cidCheckDelivery = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidCheckDelivery)
        ci.rect = NSMakeRect(x, y - 3, CK_DELIVERY_WIDTH, CK_DELIVERY_HEIGHT)
        ci.text = "Delivery"
        ci.helpCaption = "check if this order is for delivery"
        self.displayEngine.createCheckBox(ci)
        //    m_de.setCheckBoxHandler(m_cidCheckDelivery, new CheckBoxHandler() {
        //        @Override
        //        public void checkBoxToggled(boolean isChecked) {
        //            System.out.println("delivery: " + (isChecked ? "yes" : "no"));
        //        }
        //    });
    
        x += CK_DELIVERY_WIDTH
        x += 20
    
        self.cidCheckRush = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidCheckRush)
        ci.rect = NSMakeRect(x, y - 3, CK_RUSH_WIDTH, CK_RUSH_HEIGHT)
        ci.text = "Rush"
        ci.helpCaption = "check if this is a rush order"
        self.displayEngine.createCheckBox(ci)
        //    m_de.setCheckBoxHandler(m_cidCheckRush, new CheckBoxHandler() {
        //        @Override
        //        public void checkBoxToggled(boolean isChecked) {
        //            System.out.println("rush order: " + (isChecked ? "yes" : "no"));
        //        }
        //    });
    
        x += CK_RUSH_WIDTH
        x += 15
    
        self.cidOrderTotal = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidOrderTotal)
        ci.rect = NSMakeRect(x, topRowText, LBL_ORDERTOTAL_WIDTH, LBL_ORDERTOTAL_HEIGHT)
        ci.text = "0.00"
        ci.helpCaption = "total cost of order"
        self.displayEngine.createStaticText(ci)
    
        x = LEFT_EDGE
        y += EF_CUSTOMER_HEIGHT
        y += 15
    
        self.cidListBox = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidListBox)
        ci.rect = NSMakeRect(x, y, LIST_WIDTH, LIST_HEIGHT)
        ci.values = "Cheeseburger,Chips,Drink,French Fries,Grilled Cheese,Hamburger,Hot Dog,Peanuts"
        ci.valuesDelimiter = VALUES_DELIMITER
        ci.helpCaption = "list of items available for order"
        self.displayEngine.createListBox(ci)
        //    m_de.setListSelectionHandler(m_cidListBox, new ListSelectionHandler() {
        //        @Override
        //        public void listItemSelected(int selectionIndex, String selectedValue) {
        //            System.out.println("list item: " + selectionIndex + ", '" + selectedValue + "'");
        //        }
        //    });
    
        x += LIST_WIDTH
        x += 30
    
        self.cidListView = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidListView)
        ci.rect = NSMakeRect(x, y, LISTVIEW_WIDTH, 26) //LISTVIEW_HEIGHT)
        ci.text = "Group"
        ci.values = "Qty,Item,Price"
        ci.valuesDelimiter = VALUES_DELIMITER
        ci.helpCaption = "list of items on order"
        self.displayEngine.createComboBox(ci)
    
        y += LISTVIEW_HEIGHT
        y += 30
    
        x = LEFT_EDGE
    
        self.cidAddButton = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidAddButton)
        ci.rect = NSMakeRect(x, y, BTN_ADD_WIDTH, BTN_ADD_HEIGHT)
        ci.text = "Add Item"
        //ci.isEnabled = false;
        self.displayEngine.createPushButton(ci)
        //    m_de.setPushButtonHandler(m_cidAddButton, new PushButtonHandler() {
        //        @Override
        //        public void pushButtonClicked() {
        //            System.out.println("add item clicked");
        //        }
        //    });
    
        x += LIST_WIDTH
        x += 30
    
        self.cidRemoveButton = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidRemoveButton)
        ci.rect = NSMakeRect(x, y, BTN_REMOVE_WIDTH, BTN_REMOVE_HEIGHT)
        ci.text = "Remove Item"
        //ci.isEnabled = false
        self.displayEngine.createPushButton(ci)
        //    m_de.setPushButtonHandler(m_cidRemoveButton, new PushButtonHandler() {
        //        @Override
        //        public void pushButtonClicked() {
        //            System.out.println("remove item clicked");
        //        }
        //    });
    
        x += 150
    
        self.cidOrderButton = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidOrderButton)
        ci.rect = NSMakeRect(x, y, BTN_ORDER_WIDTH, BTN_ORDER_HEIGHT)
        ci.text = "Place Order"
        //ci.isEnabled = false
        self.displayEngine.createPushButton(ci)
        //    m_de.setPushButtonHandler(m_cidOrderButton, new PushButtonHandler() {
        //        @Override
        //        public void pushButtonClicked() {
        //            System.out.println("place order clicked");
        //        }
        //    });
    }


}

