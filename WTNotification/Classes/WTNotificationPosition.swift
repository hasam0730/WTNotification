//
//  WTNotificationPosition.swift
//  WTNotification
//
//  Created by Developer on 12/31/18.
//  Copyright © 2018 WhatsThat. All rights reserved.
//

import UIKit



public enum WTNotificationPosition {
	
	case top
	case bottom
	
	
	
	var startingPoint: CGPoint {
		switch self {
		case .top:
			return CGPoint(x: 0, y: 0)
		case .bottom:
			return CGPoint(x: 0, y: UIScreen.main.bounds.height)
		}
	}
}
