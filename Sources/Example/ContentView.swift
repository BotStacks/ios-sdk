//
//  ContentView.swift
//  InAppChat-Example
//
//  Created by Zaid Daghestani on 1/24/23.
//

import SwiftUI
import InAppChat

struct ContentView: View {
    var body: some View {
        InAppChatUI {
            ScrollView {
                VStack {
                    MessageView.sample
                    MessageView.sampleCurrent
                    MessageView.sampleImage
                    MessageView.sampleVideo
                    MessageView.sampleAudio
                    MessageView.sampleGif
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
