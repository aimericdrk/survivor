//
//  WatchViewModel.swift
//  watch Extension
//
//  Created by Antoine Gonthier on 08/09/24.
//

import SwiftUI
import WatchConnectivity

struct Tip: Identifiable {
    let id = UUID()
    let title: String
    let content: String
}

class WatchViewModel: NSObject, ObservableObject {
    var session: WCSession
    @Published var tips: [Tip] = []
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    enum WatchReceiveMethod: String {
        case sendDataToNative
    }

    func updateTips(tipsData: [[String: Any]]) {
        var newTips: [Tip] = []
        for tipData in tipsData {
            if let title = tipData["title"] as? String, let content = tipData["tip"] as? String {
                let tip = Tip(title: title, content: content)
                newTips.append(tip)
            }
        }

        DispatchQueue.main.async {
            self.tips = newTips
        }
    }
}

extension WatchViewModel: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    // Receive message From AppDelegate.swift that send from iOS devices
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            guard let method = message["method"] as? String, let enumMethod = WatchReceiveMethod(rawValue: method) else {
                return
            }
            
            switch enumMethod {
            case .sendDataToNative:
                if let tipdata = message["tips"] as? [[String: Any]] {
                    self.updateTips(tipsData: tipdata)
                }
            }
        }
    }
    
    func sendMessage(for method: String, data: [String: Any] = [:]) {
        guard session.isReachable else {
            return
        }
        let messageData: [String: Any] = ["method": method, "data": data]
        session.sendMessage(messageData, replyHandler: nil, errorHandler: nil)
    }
    
}

