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
    
    let TOP: CGFloat = 25
    let COMBO_HEIGHT: CGFloat = 26.0
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
    let PAYMENT_METHOD_VALUES = "Cash,Amex,Discover,MasterCard,Visa"
    
    var displayEngine: CocoaDisplayEngine!
    var cidCustomerLabel: ControlId!
    var cidEntryField: ControlId!
    var cidCheckDelivery: ControlId!
    var cidCheckRush: ControlId!
    var cidComboPayment: ControlId!
    var cidListBox: ControlId!
    var cidListView: ControlId!
    var cidAddButton: ControlId!
    var cidRemoveButton: ControlId!
    var cidOrderButton: ControlId!
    var cidOrderTotal: ControlId!
    var listMenuItems = [String]()
    var menuItems = ""
    var listPaymentMethods: [String]!
    var paymentMethod: String!
    var isDelivery: Bool = false
    var isRushOrder: Bool = false
    var selectedMenuItemIndex = -1
    var selectedOrderItemIndex = -1
    var menu = Dictionary<String, Double>()
    var listOrderItems = Array<OrderItem>()
    var orderTotal = 0.00

    //**************************************************************************
    
    func addMenuItem(item: String, price: Double) {
        self.menu[item] = price
        self.listMenuItems.append(item)
        if countElements(self.menuItems) > 0 {
            self.menuItems += ","
        }
        
        self.menuItems += item
    }

    //**************************************************************************

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        self.displayEngine = CocoaDisplayEngine(mainWindow:self.window!)
        
        // set up our menu
        self.addMenuItem("Cheeseburger", price:4.25)
        self.addMenuItem("Chips", price:2.00)
        self.addMenuItem("Drink", price:1.75)
        self.addMenuItem("French Fries", price:2.25)
        self.addMenuItem("Grilled Cheese", price:3.75)
        self.addMenuItem("Hamburger", price:4.00)
        self.addMenuItem("Hot Dog", price:3.00)
        self.addMenuItem("Peanuts", price:2.00)

        self.listPaymentMethods = PAYMENT_METHOD_VALUES.componentsSeparatedByString(",")
        self.startApp(self.displayEngine!);
    }

    //**************************************************************************

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    
    //**************************************************************************
    //**************************************************************************
    
    class PaymentMethodHandler : ComboBoxHandler {
        var appDelegate: AppDelegate
        
        init(appDelegate: AppDelegate) {
            self.appDelegate = appDelegate
        }
        
        func combBoxItemSelected(itemIndex: Int) {
            if let listMethods = self.appDelegate.listPaymentMethods {
                self.appDelegate.paymentMethod = listMethods[itemIndex]
            }
        }
    }

    //**************************************************************************
    //**************************************************************************
    
    class RushCheckBoxHandler : CheckBoxHandler {
        var appDelegate: AppDelegate
        
        init(appDelegate: AppDelegate) {
            self.appDelegate = appDelegate
        }
        
        func checkBoxToggled(isChecked: Bool) {
            self.appDelegate.isRushOrder = isChecked
        }
    }

    //**************************************************************************
    //**************************************************************************

    class DeliveryCheckBoxHandler : CheckBoxHandler {
        var appDelegate: AppDelegate
        
        init(appDelegate: AppDelegate) {
            self.appDelegate = appDelegate
        }
        
        func checkBoxToggled(isChecked: Bool) {
            self.appDelegate.isDelivery = isChecked
        }
    }
    
    //**************************************************************************
    //**************************************************************************
    
    class AddPushButtonHandler : PushButtonHandler {
        var appDelegate: AppDelegate
        
        init(appDelegate: AppDelegate) {
            self.appDelegate = appDelegate
        }

        func pushButtonClicked() {
            self.appDelegate.onAddClicked()
        }
    }
    
    //**************************************************************************
    //**************************************************************************

    class RemovePushButtonHandler : PushButtonHandler {
        var appDelegate: AppDelegate
        
        init(appDelegate: AppDelegate) {
            self.appDelegate = appDelegate
        }
        
        func pushButtonClicked() {
            self.appDelegate.onRemoveClicked()
        }
    }
    
    //**************************************************************************
    //**************************************************************************

    class OrderPushButtonHandler : PushButtonHandler {
        var appDelegate: AppDelegate
        
        init(appDelegate: AppDelegate) {
            self.appDelegate = appDelegate
        }
        
        func pushButtonClicked() {
            self.appDelegate.onOrderClicked()
        }
    }
    
    //**************************************************************************
    //**************************************************************************
    
    class ListMenuSelectionHandler : ListBoxHandler {
        var appDelegate: AppDelegate
        
        init(appDelegate: AppDelegate) {
            self.appDelegate = appDelegate
        }

        func listBoxItemSelected(itemIndex: Int) {
            self.appDelegate.onListMenuSelection(itemIndex)
        }
    }

    //**************************************************************************
    //**************************************************************************
    
    class OrderListViewHandler : ListViewHandler {
        var appDelegate: AppDelegate
        
        init(appDelegate: AppDelegate) {
            self.appDelegate = appDelegate
        }
        
        func listViewRowSelected(rowIndex: Int) {
            self.appDelegate.onListViewOrderRowSelection(rowIndex)
        }
    }

    //**************************************************************************
    //**************************************************************************

    func onListMenuSelection(itemIndex: Int) {
        self.selectedMenuItemIndex = itemIndex
        
        var buttonEnabled = true
        if itemIndex == -1 {
            buttonEnabled = false
        }
        
        self.displayEngine!.setEnabled(buttonEnabled, cid:self.cidAddButton)
    }

    //**************************************************************************
    
    func onListViewOrderRowSelection(itemIndex: Int) {
        println("order item selected: \(itemIndex)")
        
        self.selectedOrderItemIndex = itemIndex
        
        var buttonEnabled = true
        if itemIndex == -1 {
            buttonEnabled = false
        }

        self.displayEngine!.setEnabled(buttonEnabled, cid:self.cidRemoveButton)
    }

    //**************************************************************************

    func onAddClicked() {
        if let cidMenu = self.cidListBox {
            if let cidOrderItems = self.cidListView {
                let selectedMenuItem = self.listMenuItems[self.selectedMenuItemIndex]
                let orderItem = OrderItem()
                orderItem.quantity = 1
                orderItem.itemName = selectedMenuItem
                orderItem.itemPrice = self.menu[selectedMenuItem]!
                
                self.listOrderItems.append(orderItem)

                let itemPriceAsString = NSString(format:"%.2f", orderItem.itemPrice)

                self.displayEngine!.addRow("\(orderItem.quantity),\(selectedMenuItem),\(itemPriceAsString)", cid:self.cidListView)
                self.orderTotal += orderItem.itemPrice
                let orderTotalString = NSString(format:"%.2f", self.orderTotal)
                self.displayEngine!.setStaticText(orderTotalString, cid: self.cidOrderTotal)
                
                if self.listOrderItems.count == 1 {
                    self.displayEngine!.enableControl(self.cidOrderButton)
                }
            }
        }
    }

    //**************************************************************************

    func onRemoveClicked() {
        if self.selectedOrderItemIndex > -1 {
            let item = self.listOrderItems[self.selectedOrderItemIndex]
            self.orderTotal -= item.itemPrice
            let orderTotalString = NSString(format:"%.2f", self.orderTotal)
            self.displayEngine!.setStaticText(orderTotalString, cid: self.cidOrderTotal)

            self.listOrderItems.removeAtIndex(self.selectedOrderItemIndex)
            self.displayEngine!.removeRow(self.selectedOrderItemIndex, cid: self.cidListView)
            
            self.selectedOrderItemIndex = -1
            self.displayEngine!.disableControl(self.cidRemoveButton)
            
            if self.listOrderItems.isEmpty {
                self.displayEngine!.disableControl(self.cidOrderButton)
            }
        }
    }

    //**************************************************************************

    func onOrderClicked() {
        let numberItems = self.listOrderItems.count
        let orderTotalString = NSString(format:"%.2f", self.orderTotal)
        
        let orderAlert = NSAlert()
        orderAlert.messageText = "Order Confirmation"
        orderAlert.informativeText = "\(numberItems) items for total: $ \(orderTotalString)"
        orderAlert.runModal()

        // clear out app for next order
        self.orderTotal = 0.00
        self.listOrderItems.removeAll(keepCapacity: true)
        self.displayEngine!.removeAllRows(self.cidListView)
        self.displayEngine!.setStaticText("0.00", cid: self.cidOrderTotal)
        self.displayEngine!.disableControl(self.cidOrderButton)
    }

    //**************************************************************************

    func startApp(de: CocoaDisplayEngine) {
        
        let LBL_CUSTOMER_HEIGHT = LABEL_HEIGHT
        let LISTVIEW_HEIGHT = LIST_HEIGHT
        let BTN_ADD_WIDTH = BUTTON_WIDTH
        let BTN_ADD_HEIGHT = BUTTON_HEIGHT
        let BTN_REMOVE_WIDTH = BUTTON_WIDTH
        let BTN_REMOVE_HEIGHT = BUTTON_HEIGHT
        let BTN_ORDER_WIDTH = BUTTON_WIDTH
        let BTN_ORDER_HEIGHT = BUTTON_HEIGHT
        let LBL_ORDERTOTAL_HEIGHT = LABEL_HEIGHT
        let windowId: Int = 0 //DisplayEngine.ID_MAIN_WINDOW

        var ci: ControlInfo
        var controlId = 1
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
        de.createEntryField(ci)
    
        x += EF_CUSTOMER_WIDTH
        x += 20
    
        self.cidCheckDelivery = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidCheckDelivery)
        ci.rect = NSMakeRect(x, y - 3, CK_DELIVERY_WIDTH, CK_DELIVERY_HEIGHT)
        ci.text = "Delivery"
        ci.helpCaption = "check if this order is for delivery"
        de.createCheckBox(ci)
        de.setCheckBoxHandler(DeliveryCheckBoxHandler(appDelegate: self), cid: self.cidCheckDelivery)
    
        x += CK_DELIVERY_WIDTH
        x += 20
    
        self.cidCheckRush = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidCheckRush)
        ci.rect = NSMakeRect(x, y - 3, CK_RUSH_WIDTH, CK_RUSH_HEIGHT)
        ci.text = "Rush"
        ci.helpCaption = "check if this is a rush order"
        de.createCheckBox(ci)
        de.setCheckBoxHandler(RushCheckBoxHandler(appDelegate: self), cid: self.cidCheckRush)
    
        x += CK_RUSH_WIDTH
        x += 15
        
        let cidTotalLabel = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:cidTotalLabel)
        let w: CGFloat = 50.0
        ci.rect = NSMakeRect(x, topRowText, w, LBL_ORDERTOTAL_HEIGHT)
        ci.text = "Total: $ "
        de.createStaticText(ci)
        
        x += w
    
        self.cidOrderTotal = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidOrderTotal)
        ci.rect = NSMakeRect(x, topRowText, LBL_ORDERTOTAL_WIDTH, LBL_ORDERTOTAL_HEIGHT)
        ci.text = "0.00"
        ci.helpCaption = "total cost of order"
        de.createStaticText(ci)
    
        x = LEFT_EDGE
        y += EF_CUSTOMER_HEIGHT
        y += 15
        
        self.cidComboPayment = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidComboPayment)
        ci.rect = NSMakeRect(x, y, 120, COMBO_HEIGHT)
        ci.values = PAYMENT_METHOD_VALUES
        ci.helpCaption = "method of payment"
        de.createComboBox(ci)
        de.setComboBoxHandler(PaymentMethodHandler(appDelegate: self), cid: self.cidComboPayment)
        
        y += COMBO_HEIGHT
        y += 12
    
        self.cidListBox = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidListBox)
        ci.rect = NSMakeRect(x, y, LIST_WIDTH, LIST_HEIGHT)
        ci.values = self.menuItems
        ci.valuesDelimiter = VALUES_DELIMITER
        ci.helpCaption = "list of items available for order"
        de.createListBox(ci)
        de.setListBoxHandler(ListMenuSelectionHandler(appDelegate: self), cid: self.cidListBox)
    
        x += LIST_WIDTH
        x += 30
    
        self.cidListView = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidListView)
        ci.rect = NSMakeRect(x, y, LISTVIEW_WIDTH, LISTVIEW_HEIGHT)
        ci.text = "Group"
        ci.values = "Qty,Item,Price"
        ci.valuesDelimiter = VALUES_DELIMITER
        ci.helpCaption = "list of items on order"
        de.createListView(ci)
        de.setListViewHandler(OrderListViewHandler(appDelegate: self), cid: self.cidListView)
    
        y += LISTVIEW_HEIGHT
        y += 30
        x = LEFT_EDGE
    
        self.cidAddButton = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidAddButton)
        ci.rect = NSMakeRect(x, y, BTN_ADD_WIDTH, BTN_ADD_HEIGHT)
        ci.text = "Add Item"
        ci.isEnabled = false;
        de.createPushButton(ci)
        de.setPushButtonHandler(AddPushButtonHandler(appDelegate: self), cid: self.cidAddButton)
    
        x += LIST_WIDTH
        x += 30
    
        self.cidRemoveButton = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidRemoveButton)
        ci.rect = NSMakeRect(x, y, BTN_REMOVE_WIDTH, BTN_REMOVE_HEIGHT)
        ci.text = "Remove Item"
        ci.isEnabled = false
        de.createPushButton(ci)
        de.setPushButtonHandler(RemovePushButtonHandler(appDelegate: self), cid: self.cidRemoveButton)
    
        x += 150
    
        self.cidOrderButton = ControlId(windowId:windowId, controlId:controlId++)
        ci = ControlInfo(cid:self.cidOrderButton)
        ci.rect = NSMakeRect(x, y, BTN_ORDER_WIDTH, BTN_ORDER_HEIGHT)
        ci.text = "Place Order"
        ci.isEnabled = false
        de.createPushButton(ci)
        de.setPushButtonHandler(OrderPushButtonHandler(appDelegate: self), cid: self.cidOrderButton)
    }

    //**************************************************************************

}

