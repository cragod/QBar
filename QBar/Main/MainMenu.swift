//
//  MainMenu.swift
//  QBar
//
//  Created by Talon Huang on 2022/6/2.
//

import Cocoa
import SwiftUI

// This is our custom menu that will appear when users
// click on the menu bar icon
class MainMenu: NSObject {
    // A new menu instance ready to add items to
    let menu = NSMenu()
    // These are the available links shown in the menu
    // These are fetched from the Info.plist file
    let menuItems = [String: String]()
    
    var preferenceWindwo: NSWindow?
    
    // function called by KyanBarApp to create the menu
    func build() -> NSMenu {
        
        addDashboardItem()
        addSeparator()
        addPreferenceItem()
        addSeparator()
        addQuitItem()
        
        return menu
    }
}
// Menu Items
extension MainMenu {
    fileprivate func addDashboardItem() {
        let dashboardView = DashboardContainerView()
        let contentView = NSHostingController(rootView: dashboardView)
        contentView.view.frame.size = CGSize(width: 200, height: 130)
        let customMenuItem = NSMenuItem()
        customMenuItem.view = contentView.view
        menu.addItem(customMenuItem)
    }
    
    fileprivate func addPreferenceItem() {
        let preferenceMenuItem = NSMenuItem(
            title: "设置",
            action: #selector(preference),
            keyEquivalent: ","
        )
        preferenceMenuItem.target = self
        menu.addItem(preferenceMenuItem)
    }
    
    fileprivate func addQuitItem() {
        let quitMenuItem = NSMenuItem(
            title: "退出",
            action: #selector(quit),
            keyEquivalent: "q"
        )
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
    }
    
    fileprivate func addSeparator() {
        menu.addItem(NSMenuItem.separator())
    }
}

// Actions
extension MainMenu {
    // The selector that quits the app
    @objc func quit(sender: NSMenuItem) {
        NSApp.terminate(self)
    }
    
    @objc func preference(sender: NSMenuItem) {
        final class ModalWindow: NSWindow {
            override func becomeKey() {
                super.becomeKey()

                level = .modalPanel
            }

            override func close() {
                super.close()

                NSApp.stopModal()
            }
        }

        let window = ModalWindow(
            contentRect: .zero,
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )

        window.titlebarAppearsTransparent = true
        window.title = "设置"
        window.center()
        window.isReleasedWhenClosed = false
        let view = PreferenceView()
            .padding()
            .frame(
                width: Constants.kPreferenceWindowWidth,
                height: Constants.kPreferenceWindowHeight,
                alignment: .topLeading
            )
        let hosting = NSHostingView(rootView: view)
        window.contentView = hosting
        hosting.autoresizingMask = [.width, .height]

        NSApp.runModal(for: window)
    }
}
