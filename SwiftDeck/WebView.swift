//
//  WebView.swift
//  SwiftDeck
//
//  Created by Чайка on 2023/09/19.
//

import SwiftUI
import WebKit
import Combine

private let UserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2.1 Safari/605.1.15"

class WebViewModel: ObservableObject {
	@Published var link: String
	@Published var didFinishLoading: Bool = false
	@Published var pageTitle: String

	init (link: String, didFinishLoading: Bool = false, pageTitle: String = "") {
		self.link = link
		self.pageTitle = ""
	}// end init
}// end class WebViewModel

struct WebView: NSViewRepresentable {
	public typealias NSViewType = WKWebView
	@ObservedObject var viewModel: WebViewModel
	private let webView: WKWebView = WKWebView()

	public func makeNSView (context: NSViewRepresentableContext<WebView>) -> WKWebView {
		webView.navigationDelegate = context.coordinator
		webView.uiDelegate = context.coordinator
		webView.customUserAgent = UserAgent
		webView.load(URLRequest(url: URL(string: viewModel.link)!))
		return webView
	}// end makeNSView

	public func updateNSView (_ nsView: WKWebView, context: NSViewRepresentableContext<WebView>) { }

	public func makeCoordinator () -> Coordinator {
		return Coordinator(viewModel)
	}// end makeCoordinator

	class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
		private var viewModel: WebViewModel
		
		init(_ viewModel: WebViewModel) {
			//Initialise the WebViewModel
			self.viewModel = viewModel
		}// end init
		
		public func webView (_: WKWebView, didFail: WKNavigation!, withError: Error) { }
		
		public func webView (_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) { }
		
		//After the webpage is loaded, assign the data in WebViewModel class
		public func webView(_ web: WKWebView, didFinish: WKNavigation!) {
			self.viewModel.pageTitle = web.title!
			self.viewModel.link = web.url?.absoluteString ?? "http://google.com"
			self.viewModel.didFinishLoading = true
		}// end func webView(_ web:, didFinish:)
		
		public func webView (_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) { }
		
		public func webView (_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping @MainActor @Sendable (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
			decisionHandler(.allow, preferences)
		}// end webView (webView:navigationAction:decisionHandler:)
		
		public func webView (_ webView: WKWebView, runOpenPanelWith parameters: WKOpenPanelParameters, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping @MainActor @Sendable ([URL]?) -> Void) {
			func handleResult (_ result: NSApplication.ModalResponse) {
				if result == NSApplication.ModalResponse.OK, let url = openPanel.url {
					completionHandler([url])
				} else {
					completionHandler(nil)
				}// end if response
			}// end handleResult
			
			let openPanel = NSOpenPanel()
			openPanel.prompt = String(localized: "Upload")
			openPanel.message = String(localized: "title")
			openPanel.canChooseFiles = true
			if let window = webView.window {
				openPanel.beginSheetModal(for: window, completionHandler: handleResult)
			} else { // web view is somehow not in a window? Fall back to begin
				openPanel.begin(completionHandler: handleResult)
			}// end if webView have window
		}// end func webView (_:, runOpenPanelWith, initiatedByFrame, completionHandler:)

		public func webView (_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
			if navigationAction.targetFrame == nil {
				if let url: URL = navigationAction.request.url {
					NSWorkspace.shared.open(url)
				}// end if url link
			}// end if navigation targetframe is nil

			return nil
		}// end func webView (_:, createWebViewWith:, for:, windowFeatures:)
	}// end class Coordinator
}// end struct WebView

#Preview {
	WebView(viewModel: WebViewModel(link: "www.apple.com"))
}
