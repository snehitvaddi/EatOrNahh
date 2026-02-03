import Foundation
import Speech
import AVFoundation

final class SpeechService: NSObject, SpeechServiceProtocol, @unchecked Sendable {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let synthesizer = AVSpeechSynthesizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var transcriptContinuation: AsyncStream<String>.Continuation?
    private(set) var isListening: Bool = false

    func startListening() throws {
        guard let speechRecognizer, speechRecognizer.isAvailable else {
            throw SpeechError.notAvailable
        }

        let authStatus = SFSpeechRecognizer.authorizationStatus()
        guard authStatus == .authorized else {
            SFSpeechRecognizer.requestAuthorization { _ in }
            throw SpeechError.notAuthorized
        }

        stopListening()

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest else { throw SpeechError.requestFailed }

        recognitionRequest.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
        isListening = true

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            if let result {
                let transcript = result.bestTranscription.formattedString
                self?.transcriptContinuation?.yield(transcript)
            }

            if error != nil || (result?.isFinal ?? false) {
                self?.cleanupAudioSession()
            }
        }
    }

    func stopListening() {
        cleanupAudioSession()
    }

    func speak(_ text: String) async {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, mode: .default)
        try? audioSession.setActive(true)

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.95
        utterance.pitchMultiplier = 1.05

        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            let delegate = SpeechDelegate(onFinish: {
                continuation.resume()
            })
            self.synthesizer.delegate = delegate
            // Keep strong reference
            objc_setAssociatedObject(self.synthesizer, "delegate", delegate, .OBJC_ASSOCIATION_RETAIN)
            self.synthesizer.speak(utterance)
        }
    }

    func transcriptStream() -> AsyncStream<String> {
        AsyncStream { continuation in
            self.transcriptContinuation = continuation
            continuation.onTermination = { [weak self] _ in
                self?.transcriptContinuation = nil
            }
        }
    }

    private func cleanupAudioSession() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
        isListening = false
    }
}

private class SpeechDelegate: NSObject, AVSpeechSynthesizerDelegate {
    let onFinish: () -> Void
    init(onFinish: @escaping () -> Void) { self.onFinish = onFinish }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        onFinish()
    }
}

enum SpeechError: LocalizedError {
    case notAvailable
    case notAuthorized
    case requestFailed

    var errorDescription: String? {
        switch self {
        case .notAvailable: return "Speech recognition is not available on this device."
        case .notAuthorized: return "Speech recognition is not authorized."
        case .requestFailed: return "Failed to create speech recognition request."
        }
    }
}
