//
//  DashboardContainerView.swift
//  QBar
//
//  Created by Talon Huang on 2022/6/2.
//

import SwiftUI
import Combine

struct DashboardContainerView: View {
    var body: some View {
        VStack {
            FutureAccountDashboardView()
        }
        .frame(width: 250, height: 150, alignment: .center)
    }
}

struct DashboardContainerView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardContainerView()
    }
}
