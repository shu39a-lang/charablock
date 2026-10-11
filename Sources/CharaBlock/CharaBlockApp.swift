import SwiftUI
import AVFoundation

@main
struct CharaBlockApp: App {
    init() {
        // マナーモードでも音が出るように「再生」カテゴリにする
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    var body: some Scene {
        WindowGroup {
            GameWebView()
                .ignoresSafeArea()
                .background(Color.black)
                .preferredColorScheme(.dark)
        }
    }
}
