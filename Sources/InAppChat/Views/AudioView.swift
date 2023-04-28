import AVKit
import Foundation
import SwiftDate
import SwiftUI

public struct AudioView: View {
  @State var player: AVPlayer

  public init(_ url: String) {
    self._player = State(initialValue: AVPlayer(url: URL(string: url)!))
  }

  public var body: some View {
    AudioViewInternal(player: player)
  }
}

struct AudioViewInternal: View {

  let player: AVPlayer
  @State var play: Bool = false
  @State var time: Double = 0.0
  @State var duration: Double? = nil

  @Environment(\.iacTheme) var theme

  public var body: some View {
    HStack(alignment: .center) {
      Button(action: {
        if play {
          player.pause()
        } else {
          player.play()
        }
        play.toggle()
      }) {
        Image(systemName: play ? "pause.fill" : "play.fill")
          .resizable()
          .size(12.0)
          .foregroundColor(Color.white)
      }.circle(44.0, theme.colors.primary)

      Slider(
        value: $time,
        in: 0...(duration ?? 1),
        step: 1,
        label: {
          Text("").foregroundColor(theme.colors.bubbleText)
        },
        minimumValueLabel: {
          Text(secondsToString(time))
            .foregroundColor(theme.colors.bubbleText)
        },
        maximumValueLabel: {
          duration.map { duration -> Text in
            let t = secondsToString(duration)
            print("Seconds To String duration ", duration, t)
            return Text(t)
              .foregroundColor(theme.colors.bubbleText)
          } ?? Text("")
        },
        onEditingChanged: { editing in
          if editing {
            player.pause()
          } else if play {
            player.seek(to: CMTime(seconds: time, preferredTimescale: 600))
            player.play()
          }
        }
      ).frame(width: theme.videoPreviewSize.width)
    }.padding(.all, 8.0)
      .onAppear {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        player.addPeriodicTimeObserver(forInterval: time, queue: .main) { time in
          self.time = time.seconds
        }
        if player.status == .readyToPlay {
          if let duration = player.currentItem?.duration.seconds, !duration.isNaN {
            self.duration = duration
          }
        }
      }.onReceive(
        player.publisher(for: \.status)
          .map { status -> Double? in
            if status == .readyToPlay {
              if let duration = player.currentItem?.duration.seconds, !duration.isNaN {
                return duration
              }
            }
            return nil
          }
      ) { duration in
        self.duration = duration
      }
  }

  func secondsToString(_ _time: Double) -> String {
    var time = Int(_time)
    if time == 0 {
      return ""
    }
    let seconds = time % 60
    time = (time - seconds) / 60
    let minutes = time % 60
    let hours = (time - minutes) / 60
    var ret = ""
    if hours > 0 {
      ret += "\(hours):"
    }
    ret += "\(minutes):"
    return ret + "\(seconds < 10 ? "0\(seconds)" : "\(seconds)")"
  }
}
