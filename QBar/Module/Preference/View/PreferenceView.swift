//
//  PreferenceView.swift
//  QBar
//
//  Created by Talon Huang on 2022/6/2.
//

import SwiftUI

struct PreferenceView: View {
    var body: some View {
        TabView {
            FutureAccountSettingView()
                .tabItem {
                    Label("U合约账户", systemImage: "person.crop.circle")
                }
        }
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView()
    }
}
