//
//  ContentView.swift
//  SwiftDeck
//
//  Created by Чайка on 2023/09/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SafariLikeView(messageURL: "https://tweetdeck.twitter.com")
    }
}

struct SafariLikeView: View {
    @ObservedObject var model: WebViewModel

    init(messageURL: String) {
         //Assign the url to the model and initialise the model
         self.model = WebViewModel(link: messageURL)
     }

    var body: some View {
        //Create the WebView with the model
        WebView(viewModel: model)
    }
}

#Preview {
    ContentView()
}
