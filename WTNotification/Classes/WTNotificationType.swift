//
//  WTNotificationType.swift
//  WTNotification
//
//  Created by Developer on 12/31/18.
//  Copyright © 2018 WhatsThat. All rights reserved.
//

import UIKit



public protocol NotificationStyle {
	
	var backgroundColor: UIColor { get }
	var tintColor: UIColor { get }
	var icon: UIImage? { get }
	var position: WTNotificationPosition { get }
	var timeDuration: TimeInterval { get }
}



public enum WTNotificationType: NotificationStyle {
	
	case success
	case error
	
	
	
	public var icon: UIImage? {
		let bundle = Bundle(for: WTNotification.self)
		switch self {
		case .success:
			return UIImage(named: "success", in: bundle, compatibleWith: nil)!
		case .error:
			return UIImage(named: "error", in: bundle, compatibleWith: nil)!
		}
	}
	
	
	
	public var tintColor: UIColor {
		switch self {
		case .success:
			return UIColor(red: 126/255, green: 211/255, blue: 33/255, alpha: 1.0)
		case .error:
			return UIColor(red: 255/255, green: 77/255, blue: 102/255, alpha: 1.0)
		}
	}
	
	
	
	public var backgroundColor: UIColor {
		switch self {
		case .success, .error:
			return .white
		}
	}
	
	
	
	public var position: WTNotificationPosition {
		switch self {
		case .success, .error:
			return .bottom
		}
	}
	
	
	
	public var timeDuration: TimeInterval {
		switch self {
		case .success, .error:
			return 3.0
		}
	}
}
