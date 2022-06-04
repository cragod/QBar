//
//  FutureAccountUtil.swift
//  QBar
//
//  Created by Talon Huang on 2022/6/2.
//

import Combine
import Foundation
import SwiftUI

class FutureAccountUtil: ObservableObject {
    static var shared = FutureAccountUtil()
    
    @Published var accountInfo = FutureAccountInfo()
    @Published var lastUpdate = Date()
    
    public var formattedLastUpdateDate: String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.string(from: lastUpdate)
    }
    
    public var formattedUnrealProfitString: String {
        String(format: "%.2f(%.2f%%)", accountInfo.unrealizedProfit, accountInfo.unrealizedProfitPercent * 100)
    }
    
    public var formattedUnrealProfitPctString: String {
        String(format: "%.2f%%", accountInfo.unrealizedProfitPercent * 100)
    }
    
    private var timer: Timer?
    private var timerCancellable: AnyCancellable?
    private var requestCancellable: AnyCancellable?
    
    func start(interval: TimeInterval = 10) {
        request()
        timerCancellable?.cancel()
        timerCancellable = Timer.publish(
            every: interval,
            on: .main,
            in: .common
        )
        .autoconnect()
        .map(\.timeIntervalSince1970)
        .sink { [weak self] _ in
            self?.request()
        }
    }
    
    func stop() {
        requestCancellable?.cancel()
        timerCancellable?.cancel()
    }
    
    private func request() {
        if let req = try? RequestHelper.generateURLRequest(for: .accountInfo,
                                                           key: UserDefaults.standard.string(forKey: StorageKey.kFutureAccountKey),
                                                           secret: UserDefaults.standard.string(forKey: StorageKey.kFutureAccountSecret)) {
            requestCancellable?.cancel()
            requestCancellable = URLSession.shared.dataTaskPublisher(for: req)
                .receive(on: DispatchQueue.main)
                .sink { failure in
                } receiveValue: { [weak self] output in
                    let data = output.data
                    
                    do {
                        let decoder = JSONDecoder()
                        let accountInfo = try decoder.decode(FutureAccountInfo.self, from: data)
                        self?.accountInfo = accountInfo
                        self?.lastUpdate = Date()
                    } catch let error as NSError {
                        print(error)
                    }
                }
        }
    }
}
