// ButtonCode.swift
//
// Created by TeChris on 08.11.24.

import Foundation

/// A PS4 Controller Button.
struct Button {
	
	/// Name or Identifier of the Controller Button.
	var buttonName: String
	
	/// Usage Code for the Button.
	var usageCode: Int
	
	/// Name of the corresponding AppleScript.
	var buttonActionName: String
	
	/// List of PS4 Controller Buttons.
	static let buttons: [Button] =
	[
	Button(buttonName: "L1", usageCode: 5, buttonActionName: "PreviousTrackAction"),
	Button(buttonName: "L2", usageCode: 7, buttonActionName: "VolumeDownAction"),
	Button(buttonName: "R1", usageCode: 6, buttonActionName: "SkipAction"),
	Button(buttonName: "R2", usageCode: 8, buttonActionName: "VolumeUpAction"),
	Button(buttonName: "RightStickPress", usageCode: 12, buttonActionName: "CloseAction"),
	Button(buttonName: "LeftStickPress", usageCode: 11, buttonActionName: "OpenAction"),
	Button(buttonName: "Cross", usageCode: 2, buttonActionName: "PlayPauseAction"),
	Button(buttonName: "TouchPad", usageCode: 14, buttonActionName: "SetupAction")
	]
}

/// Button Codes on a PS4 Controller
//struct ButtonCode1 {
//	static let L1 = 5
//	static let L2 = 7
//	static let R1 = 6
//	static let R2 = 8
//	static let Options = 10
//	static let Share = 9
//	static let touchPad = 14
//	static let Triangle = 4
//	static let Square = 1
//	static let Circle = 3
//	static let Cross = 2
//	static let RightStickPress = 12
//	static let LeftStickPress = 11
//}
