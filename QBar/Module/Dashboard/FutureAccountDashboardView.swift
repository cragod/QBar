//
//  FutureAccountDashboardView.swift
//  QBar
//
//  Created by Talon Huang on 2022/6/2.
//

import SwiftUI

struct FutureAccountDashboardView: View {
    @ObservedObject var accountUtil = FutureAccountUtil.shared
    var body: some View {
        VStack{
            Form {
                Text("钱包资产: \(accountUtil.accountInfo.walletBalance, specifier: "%.2f")")
                Text("未实现盈亏: \(accountUtil.formattedUnrealProfitString)")
                    .padding([.top], 5)
                Text("保证金总额: \(accountUtil.accountInfo.marginBalance, specifier: "%.2f")")
                    .padding([.top, .bottom], 5)
                Text("更新: \(accountUtil.formattedLastUpdateDate)")
                .font(Font.footnote)
                .padding([.top], 10)

            }
        }
        .onAppear {
            FutureAccountUtil.shared.start(interval: 1)
        }
        .onDisappear {
            FutureAccountUtil.shared.start()
        }
    }
}

struct FutureAccountDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        FutureAccountDashboardView()
    }
}
