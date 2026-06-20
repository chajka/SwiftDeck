//
//  ContentView.swift
//  SwiftDeck
//
//  Created by Чайка on 2023/09/19.
//

import SwiftUI

fileprivate let XProPageURLString: String = "https://pro.x.com"
fileprivate let XPageURLString: String = "https://x.com"
fileprivate let Pro: Bool = true

struct ContentView: View {
	@StateObject private var model: WebViewModel

	init () {
		let initialURL = Pro ? XProPageURLString : XPageURLString
		_model = StateObject(wrappedValue: WebViewModel(link: initialURL))
	}// end init

	var body: some View {
		WebView(viewModel: model)
			.onOpenURL { url in
				guard url.scheme?.lowercased() == "https",
					  let host = url.host?.lowercased(),
					  host == "x.com" || host == "www.x.com" else {
					return
				}// end guard supported X URL

				model.link = url.absoluteString
			}// end onOpenURL
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
