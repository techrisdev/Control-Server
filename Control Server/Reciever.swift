// Server.swift
//
// Created by TeChris on 28.03.24.

import Cocoa

/// Create a Reciever which will recieve commands from the controller.
class Reciever {
	
	static let shared = Reciever()
	
	/// Start recieving commands.
	func start() {
		setup()
		startRecievingActions()
	}
	
	var gamepadWasAdded: @convention(c) (UnsafeMutableRawPointer?, IOReturn, UnsafeMutableRawPointer?, IOHIDDevice) -> Void = { inContext, inResult, inSender, device in
		print("Gamepad was Added")
	}
	
	var gamepadWasRemoved: @convention(c) (UnsafeMutableRawPointer?, IOReturn, UnsafeMutableRawPointer?, IOHIDDevice) -> Void = { inContext, inResult, inSender, device in
		print("Gamepad was Removed")
		// Close Everything
		NotificationCenter.default.post(name: .UpButtonOnController, object: nil)
		
		
	}
	
	var lastIntegerValue: Int!
	
// TODO: Better
	
//	var gamepadAction: @convention(c) (UnsafeMutableRawPointer?, IOReturn, UnsafeMutableRawPointer?, IOHIDReportType, UInt32, UnsafeMutablePointer<UInt8>, CFIndex) -> Void = { inContext, inResult, inSender, reportType, reportID, reportValue, reportLength in
//		
//		// Source: https://github.com/superwills/IOKitExample/blob/30e501d2691d867a3c70a8b1a453c0fc93d1e23b/IOKitExample/Callbacks.h#L63
//		// MADE FOR PS4 CONTROLLER !!!!
//		
//		print("legnth: \(reportLength) pressed:")
//		for i in 0 ..< reportLength {
//			print(Helper.convertGamePadCode(value: Int(reportValue[i]), at: i))
//		}
//	}
	
	var gamepadAction: @convention(c) (UnsafeMutableRawPointer?, IOReturn, UnsafeMutableRawPointer?, IOHIDValue) -> Void = { inContext, inResult, inSender, value in
		
		
		
		let reciever = Reciever.shared
		let integerValue = IOHIDValueGetIntegerValue(value)
		
		let element = IOHIDValueGetElement(value)
		let usagePage = IOHIDElementGetUsagePage(element)
		let currentButtonCode = IOHIDElementGetUsage(element)
		
		
		// Check if Button is down (1), and if it's a controller button
		if integerValue == 1 && usagePage == kHIDPage_Button {
			
			// Go through all buttons and check which one of them was pressed
			for button in Button.buttons {
				// If the button matches...
				if currentButtonCode == button.usageCode {
					// TODO: Do its action
					print(button.buttonName)
					Helper.executeScript(button.buttonActionName)
				}
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		// Usage: L1: 5, L2: 7, R1: 6, R2: 8, Options: 10, Share: 9, D-Pad: 14, Triangle: 4, Square: 1, Circle: 3, X: 2, Right Stick Press: 12, Left Stick Press: 11
		// Usage Page always 9 for everything except DPad Buttons, kHIDPage_GenericDesktop
		
		
		
//		if usagePage == kHIDPage_Button && buttonCode == ButtonCode.L1 {
//			if integerValue == 1 {
//				print("Pressed")
//			} else {
//				print(integerValue)
//			}
//		}
//		
		// Left = 6
		// Right = 2
		// Up = 0 TODO: Also release code
		// Down = 4
		
		// Only check current integer value if code 8 came after it (8 = DPad) TODO: Very laggy
//		if integerValue != 8 && integerValue < 9 {
//			reciever.lastIntegerValue = integerValue
//			return
//		}
		
		
		/*
		switch integerValue {
		case 0:
			// Up = Close Music
			NotificationCenter.default.post(name: .UpButtonOnController, object: nil)
		case 2:
			// Right = skip action
			print("right")
			NotificationCenter.default.post(name: .RightButtonOnController, object: nil)
		case 4:
			// Down = Reopen Music
			NotificationCenter.default.post(name: .DownButtonOnController, object: nil)
		case 6:
			// Left = Turn Down Volume
			NotificationCenter.default.post(name: .LeftButtonOnController, object: nil)
		default:
			break
		}
		*/
	}
	
	var hidManager: IOHIDManager!
	
	func setup() {
		hidManager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
		let criterion = NSMutableDictionary()
		criterion.setObject(kHIDPage_GenericDesktop, forKey: NSString(string: kIOHIDDeviceUsagePageKey))
		criterion.setObject(kHIDUsage_GD_GamePad, forKey: NSString(string: kIOHIDDeviceUsageKey))
		
		IOHIDManagerSetDeviceMatching(hidManager, criterion)
		IOHIDManagerRegisterDeviceMatchingCallback(hidManager, gamepadWasAdded, nil)
		IOHIDManagerRegisterDeviceRemovalCallback(hidManager, gamepadWasRemoved, nil)
		
		IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode!.rawValue)
		IOHIDManagerOpen(hidManager, IOOptionBits(kIOHIDOptionsTypeNone))
		
		IOHIDManagerRegisterInputValueCallback(hidManager, gamepadAction, nil)
	}
	
	func startRecievingActions() {
		NotificationCenter.default.addObserver(forName: Notification.Name.UpButtonOnController, object: nil, queue: nil, using: { _ in
			// My Action: Close Music App, mute volume
			Helper.executeScript("CloseAction")
		})
		
		NotificationCenter.default.addObserver(forName: Notification.Name.DownButtonOnController, object: nil, queue: nil, using: { _ in
			// My Action: Open Music App, unmute volume
			Helper.executeScript("OpenAction")
			// Hide the cursor and wait
		})
		
		NotificationCenter.default.addObserver(forName: Notification.Name.RightButtonOnController, object: nil, queue: nil, using: { _ in
			// My Action: Skip Track
			Helper.executeScript("SkipAction")
		})
		
		NotificationCenter.default.addObserver(forName: Notification.Name.LeftButtonOnController, object: nil, queue: nil, using: { _ in
			// My Action: Volume Down
			Helper.executeScript("VolumeDownAction")
		})
	}
}
