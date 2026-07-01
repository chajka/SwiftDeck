//
//  SwiftDeckApp.swift
//  SwiftDeck
//
//  Created by Чайка on 2023/09/19.
//

import SwiftUI

@main
struct SwiftDeckApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
		}// end WindowGroup
	}// end body
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
