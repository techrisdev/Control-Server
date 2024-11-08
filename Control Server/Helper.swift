// Helper.swift
//
// Created by TeChris on 07.04.24.

import Cocoa

struct Helper {
	/// Execute one of the included scripts
	static func executeScript(_ script: String) {
		guard let url = Bundle.main.url(forResource: script, withExtension: "script") else { fatalError("File Does not Exist") }
		
		var fileContent: String!
		do {
			fileContent = try String(contentsOf: url, encoding: .utf8)
		} catch {
			print(error)
			fatalError()
		}
		
		if let scriptObject = NSAppleScript(source: fileContent) {
			scriptObject.executeAndReturnError(nil)
		}
	}
	
	/// Convert GamePad codes to usable Codes.
	static func convertGamePadCode(value: Int, at index: Int) -> ActionType? {
		
		// 5: DPad + Buttons
		// 6: Shoulder Buttons: 2 right, left 1, also clicking joystick left 64, joystick right 128
		// 7: middle pad on ps4 controller
		// 8 + 9 Back Paddles
		
		
		
		// TODO: COMPLETE
		switch index {
		case 5:
			switch value {
			case 6:
				return .DPadLeft
			case 2:
				return .DPadRight
			case 0:
				return .DPadUp
			case 4:
				return .DPadDown
			default:
				break
			}
		default:
			break
		}
		
		return nil
	}
	
	enum ActionType {
		case DPadUp
		case DPadDown
		case DPadLeft
		case DPadRight
		case ShoulderLeft
		case ShoulderRight
	}
	
	
	/// Get Accessibility Permission for SetupAction
	static func requestAccessibilityPermission() {
		if !AXIsProcessTrusted() {
			let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
			let enabled = AXIsProcessTrustedWithOptions(options)
		}
	}
}
