//
//  SpeechRecognizer.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/4/23.
//

import Foundation
import Speech
import SwiftUI

class SpeechRecognizer: ObservableObject {
  enum RecognizerError: Error {
    case nilRecognizer
    case notAuthorizedToRecognize
    case notPermittedToRecord
    case recognizerIsUnavailable

    var message: String {
      switch self {
      case .nilRecognizer: return "Can't initialize speech recognizer"
      case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
      case .notPermittedToRecord: return "Not permitted to record audio"
      case .recognizerIsUnavailable: return "Recognizer is unavailable"
      }
    }
  }

  @Published var transcript: String = ""

  private var audioEngine: AVAudioEngine?
  private var request: SFSpeechAudioBufferRecognitionRequest?
  private var task: SFSpeechRecognitionTask?
  private let recognizer: SFSpeechRecognizer?
  @Published var transcribing = false
  @Published var hasPermission = false
  @Published var canAsk = false

  var enabled: Bool {
    return canAsk || hasPermission
  }

  func toggle() {
    if transcribing {
      stopTranscribing()
    } else {
      transcribe()
    }
  }

  init() {
    recognizer = SFSpeechRecognizer()
    self.hasPermission =
      SFSpeechRecognizer.authorizationStatus() == .authorized
      && AVAudioSession.sharedInstance().recordPermission == .granted
    self.canAsk =
      SFSpeechRecognizer.authorizationStatus() != .denied
      && AVAudioSession.sharedInstance().recordPermission != .denied
  }

  deinit {
    reset()
  }

  func permissions(transcribe: Bool = true) {
    Task(priority: .background) {
      do {
        guard recognizer != nil else {
          throw RecognizerError.nilRecognizer
        }
        guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
          await MainActor.run {
            self.hasPermission = false
          }
          throw RecognizerError.notAuthorizedToRecognize
        }
        guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
          await MainActor.run {
            self.hasPermission = false
          }
          throw RecognizerError.notPermittedToRecord
        }
      } catch {
        speakError(error)
      }
      await MainActor.run {
        if self.hasPermission {
          self._transcribe()
        }
      }
    }
  }

  func transcribe() {
    if recognizer == nil {
      return
    }
    if !hasPermission {
      if canAsk {
        permissions(transcribe: true)
      }
      return
    }
    _transcribe()
  }

  func _transcribe() {
    if transcribing { return }
    transcribing = true
    DispatchQueue(label: "Speech Recognizer Queue", qos: .background).async { [weak self] in
      guard let self = self, let recognizer = self.recognizer, recognizer.isAvailable else {
        self?.speakError(RecognizerError.recognizerIsUnavailable)
        return
      }

      do {
        let (audioEngine, request) = try Self.prepareEngine()
        self.audioEngine = audioEngine
        self.request = request
        self.task = recognizer.recognitionTask(
          with: request, resultHandler: self.recognitionHandler(result:error:))
        print("Voice Engine Started")
      } catch {
        self.reset()
        self.speakError(error)
      }
    }
  }

  func stopTranscribing() {
    reset()
  }

  func reset() {
    task?.cancel()
    audioEngine?.stop()
    audioEngine = nil
    request = nil
    task = nil
    DispatchQueue.main.async { [weak self] in
      self?.transcribing = false
      self?.transcript = ""
    }
  }

  private static func prepareEngine() throws -> (
    AVAudioEngine, SFSpeechAudioBufferRecognitionRequest
  ) {
    let audioEngine = AVAudioEngine()

    let request = SFSpeechAudioBufferRecognitionRequest()
    request.shouldReportPartialResults = true

    let audioSession = AVAudioSession.sharedInstance()
    try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
    try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    let inputNode = audioEngine.inputNode

    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
      (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
      request.append(buffer)
    }
    audioEngine.prepare()
    try audioEngine.start()

    return (audioEngine, request)
  }

  private func recognitionHandler(result: SFSpeechRecognitionResult?, error: Error?) {
    let receivedFinalResult = result?.isFinal ?? false
    let receivedError = error != nil
    if receivedFinalResult || receivedError {
      audioEngine?.stop()
      audioEngine?.inputNode.removeTap(onBus: 0)
    }

    if let result = result {
      print(result)
      speak(result.bestTranscription.formattedString)
    }
  }

  private func speak(_ message: String) {
    publish {
      self.transcript = message
    }
  }

  private func speakError(_ error: Error) {
    var errorMessage = ""
    if let error = error as? RecognizerError {
      errorMessage += error.message
    } else {
      errorMessage += error.localizedDescription
    }
    print(errorMessage)
  }
}

extension SFSpeechRecognizer {
  static func hasAuthorizationToRecognize() async -> Bool {
    await withCheckedContinuation { continuation in
      requestAuthorization { status in
        continuation.resume(returning: status == .authorized)
      }
    }
  }
}

extension AVAudioSession {
  func hasPermissionToRecord() async -> Bool {
    await withCheckedContinuation { continuation in
      requestRecordPermission { authorized in
        continuation.resume(returning: authorized)
      }
    }
  }
}
