// AppDelegate.swift
//
// Created by TeChris on 28.03.24.

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		let reciever = Reciever.shared
		reciever.start()
	}
}

