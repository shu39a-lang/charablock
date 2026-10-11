import SwiftUI
import WebKit
import AVFoundation

struct GameWebView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let controller = WKUserContentController()
        controller.add(context.coordinator, name: "speak")
        config.userContentController = controller

        let web = WKWebView(frame: .zero, configuration: config)
        web.isOpaque = false
        web.backgroundColor = .black
        web.scrollView.backgroundColor = .black
        web.scrollView.contentInsetAdjustmentBehavior = .never
        web.scrollView.bounces = false
        web.scrollView.isScrollEnabled = false

        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            web.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return web
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    // ゲームからの「声」の依頼を、iPhone標準の読み上げ(AVSpeechSynthesizer)で話す
    final class Coordinator: NSObject, WKScriptMessageHandler {
        private let synth = AVSpeechSynthesizer()

        func userContentController(_ userContentController: WKUserContentController,
                                   didReceive message: WKScriptMessage) {
            guard message.name == "speak",
                  let body = message.body as? [String: Any],
                  let text = body["t"] as? String else { return }
            let pitch = (body["p"] as? Double) ?? 1.0

            if synth.isSpeaking { synth.stopSpeaking(at: .immediate) }
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
            utterance.pitchMultiplier = Float(min(max(pitch, 0.5), 2.0))
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 1.05
            synth.speak(utterance)
        }
    }
}
