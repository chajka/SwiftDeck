//
//  SwiftDeckApp.swift
//  SwiftDeck
//
//  Created by Чайка on 2023/09/19.
//

import SwiftUI
import AppKit

@main
struct SwiftDeckApp: App {
	@NSApplicationDelegateAdaptor(SwiftDeckAppDelegate.self)
	private var appDelegate

	@StateObject
	private var model = WebViewModel(link: "https://pro.x.com")

	var body: some Scene {
		WindowGroup {
			ContentView(model: model)
				.onAppear {
					appDelegate.openURLHandler = openURLInExistingWindow
				}// end onAppear
		}
	}// end body

	@MainActor
	private func openURLInExistingWindow(_ url: URL) {
		guard url.scheme?.lowercased() == "https",
			  let host = url.host?.lowercased(),
			  host == "x.com" || host == "www.x.com" else {
			return
		}// end guard supported X URL

		model.link = url.absoluteString
		NSApp.activate(ignoringOtherApps: true)
		let window =
			NSApp.windows.first(where: \.isVisible)
			?? NSApp.windows.first
		window?.makeKeyAndOrderFront(nil)
	}// end openURLInExistingWindow
}// end struct SwiftDeckApp

@MainActor
final class SwiftDeckAppDelegate: NSObject, NSApplicationDelegate {
	var openURLHandler: ((URL) -> Void)? {
		didSet {
			flushPendingURLs()
		}// end didSet
	}// end var openURLHandler

	private var pendingURLs: [URL] = []

	func applicationDidFinishLaunching(_ notification: Notification) {
		NSAppleEventManager.shared().setEventHandler(
			self,
			andSelector: #selector(handleGetURLEvent(_:withReplyEvent:)),
			forEventClass: AEEventClass(kInternetEventClass),
			andEventID: AEEventID(kAEGetURL)
		)
	}// end applicationDidFinishLaunching

	@objc
	private func handleGetURLEvent(_ event: NSAppleEventDescriptor, withReplyEvent replyEvent: NSAppleEventDescriptor) {
		guard let urlString =
				event
				.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?
				.stringValue,
			  let url = URL(string: urlString) else {
			return
		}// end guard url

		if let openURLHandler {
			openURLHandler(url)
		} else {
			pendingURLs.append(url)
		}// end if handler ready
	}// end handleGetURLEvent

	private func flushPendingURLs() {
		guard let openURLHandler,
			  !pendingURLs.isEmpty else {
			return
		}// end guard pending

		let urls = pendingURLs
		pendingURLs.removeAll()
		for url in urls {
			openURLHandler(url)
		}// end for pending urls
	}// end flushPendingURLs
}// end class SwiftDeckAppDelegate
