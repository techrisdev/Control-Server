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
		
		//print(integerValue)
		
//		if integerValue < 100 {
//			print(integerValue)
//		}
		
		
		// Left = 6
		// Right = 2
		// Up = 0
		// Down = 4
		
		// Only check current integer value if code 8 came after it (8 = DPad) TODO: Very laggy
//		if integerValue != 8 && integerValue < 9 {
//			reciever.lastIntegerValue = integerValue
//			return
//		}
		
		
		
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
		
//		IOHIDManagerRegisterInputReportCallback(hidManager, gamepadAction, nil)
		
		IOHIDManagerRegisterInputValueCallback(hidManager, gamepadAction, nil)
	}
	
	func startRecievingActions() {
		NotificationCenter.default.addObserver(forName: Notification.Name.UpButtonOnController, object: nil, queue: nil, using: { _ in
			// My Action: Close Music App, mute volume
			Helper.executeScript(with: "CloseAction")
		})
		
		NotificationCenter.default.addObserver(forName: Notification.Name.DownButtonOnController, object: nil, queue: nil, using: { _ in
			// My Action: Open Music App, unmute volume
			Helper.executeScript(with: "OpenAction")
			// Hide the cursor and wait
		})
		
		NotificationCenter.default.addObserver(forName: Notification.Name.RightButtonOnController, object: nil, queue: nil, using: { _ in
			// My Action: Skip Track
			Helper.executeScript(with: "SkipAction")
		})
		
		NotificationCenter.default.addObserver(forName: Notification.Name.LeftButtonOnController, object: nil, queue: nil, using: { _ in
			// My Action: Volume Down
			Helper.executeScript(with: "VolumeDownAction")
		})
	}
}
