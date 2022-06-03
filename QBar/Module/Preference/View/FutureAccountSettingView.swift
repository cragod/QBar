//
//  FutureAccountSettingView.swift
//  QBar
//
//  Created by Talon Huang on 2022/6/2.
//

import SwiftUI

struct FutureAccountSettingView: View {
    @AppStorage(StorageKey.kFutureAccountKey) var key = ""
    @AppStorage(StorageKey.kFutureAccountSecret) var secret = ""
    @AppStorage(StorageKey.kFutureAccountShowPnlPctOnStatusBar) var showOnStatusBar = true
    @State var editable: Bool = false
    var body: some View {
        VStack(alignment: .center) {
            Text("！！！使用只读权限的 API ！！！").font(.title3).bold().foregroundColor(.red)
            HStack {
                Text("API Key")
                    .frame(width: 70, alignment: .leading)
                TextField("Key", text: $key)
                    .frame(width: 200)
                    .disabled(!editable)
                    .disableAutocorrection(true)
            }.padding([.leading, .trailing], 20)
            HStack {
                Text("API Secret")
                    .frame(width: 70, alignment: .leading)
                SecureField("Secret", text: $secret)
                    .textContentType(.oneTimeCode)
                    .frame(width: 200)
                    .disabled(!editable)
                    .disableAutocorrection(true)
            }.padding([.leading, .trailing], 20)
            Toggle("修改", isOn: $editable)
                .toggleStyle(.switch)
                .alignmentGuide(HorizontalAlignment.center) { d in
                    -65
                }
            
            Divider()
                .padding([.leading, .trailing], 20)
                .padding([.bottom], 10)
            Toggle("状态栏显示浮动盈亏率", isOn: $showOnStatusBar)
                .toggleStyle(.checkbox)
                .font(.body)
                .alignmentGuide(HorizontalAlignment.center) { d in
                    140
                }
        }
        .frame(width: 320, height: 200, alignment: .top)
        .onAppear {
            editable = key.isEmpty && secret.isEmpty
        }
    }
}

struct FutureAccountSettingView_Previews: PreviewProvider {
    static var previews: some View {
        FutureAccountSettingView()
    }
}
