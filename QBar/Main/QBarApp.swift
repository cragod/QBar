//
//  QBarApp.swift
//  QBar
//
//  Created by Talon Huang on 2022/6/2.
//

import SwiftUI
import Combine

@main
struct QBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ZStack {
                  EmptyView()
                }
                .hidden()
        }
        Settings {
            PreferenceView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var instance: AppDelegate!
    
    private var cancellables = [AnyCancellable]()
    
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = MainMenu()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem.button?.image = .init(systemSymbolName: "bitcoinsign.square.fill", accessibilityDescription: nil)
        statusBarItem.button?.imagePosition = .imageLeading
        // Assign our custom menu to the status bar
        statusBarItem.menu = menu.build()
        
        // Observe
        subscribeFutureAccountInfo()
        
    }
    
    private func subscribeFutureAccountInfo() {
        let _ = FutureAccountUtil.shared.$accountInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateStatusBarInfo()
            }
            .store(in: &cancellables)
        let _ = UserDefaults.standard.publisher(for: \.showOnStatusBar)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.updateStatusBarInfo()
            }
        FutureAccountUtil.shared.start()
    }
    
    private func updateStatusBarInfo() {
        if UserDefaults.standard.showOnStatusBar {
            statusBarItem.button?.title = FutureAccountUtil.shared.formattedUnrealProfitPctString
        } else {
            statusBarItem.button?.title = ""
        }
        FutureAccountUtil.shared.start()
    }
}

extension UserDefaults {
    @objc dynamic var showOnStatusBar: Bool {
        return bool(forKey: StorageKey.kFutureAccountShowPnlPctOnStatusBar)
    }
}
