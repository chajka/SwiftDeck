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
}// end class SwiftDeckAppDelegate
