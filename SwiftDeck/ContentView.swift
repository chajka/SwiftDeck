//
//  ContentView.swift
//  SwiftDeck
//
//  Created by Чайка on 2023/09/19.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		BrowserView(messageURL: "https://tweetdeck.twitter.com")
	}// end body
}// end struct ContentView

struct BrowserView: View {
	@ObservedObject var model: WebViewModel

	init(messageURL: String) {
		 //Assign the url to the model and initialise the model
		 self.model = WebViewModel(link: messageURL)
	 }// end init

	var body: some View {
		//Create the WebView with the model
		WebView(viewModel: model)
	}// end body
}// end struct BrowserView

#Preview {
	ContentView()
}// end Preview
