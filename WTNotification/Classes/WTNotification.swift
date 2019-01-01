//
//  WTNotification.swift
//  WTNotification
//
//  Created by Developer on 12/31/18.
//  Copyright © 2018 WhatsThat. All rights reserved.
//

import UIKit



public final class WTNotification: UIView {
	
	// MARK: define constant
	private let screenSize: CGSize = UIScreen.main.bounds.size
	private let windowScreen = UIApplication.shared.keyWindow
	let horizontalPadding: CGFloat = 15
	let verticalPadding: CGFloat = 10
	let popupPadding: CGFloat = 0
	let minimumTitleTextHeight: CGFloat = 20
	let minimumMessageTextHeight: CGFloat = 35
	let paddingHorizontalStackView: CGFloat = 10
	let iconWidth: CGFloat = 25
	let messageFontSize: CGFloat = 14
	var notificationStyle: NotificationStyle!
	
	
	
	// MARK: define control
	private lazy var iconView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var iconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)
		label.textAlignment = .left
		return label
	}()
	
	private lazy var messageLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .justified
		label.lineBreakMode = .byWordWrapping
		label.font = UIFont.systemFont(ofSize: 14) // messageFontSize
		return label
	}()
	
	private lazy var verticalContainerStackview: UIStackView = {
		let stackView = UIStackView()
		stackView.alignment = .fill
		stackView.distribution = .fill
		stackView.spacing = -5.0
		stackView.axis = .vertical
		return stackView
	}()
	
	private lazy var horizontalContainerStackview: UIStackView = {
		let stackView = UIStackView()
		stackView.alignment = .fill
		stackView.distribution = .fill
		stackView.spacing = 15.0 // paddingHorizontalStackView
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	
	
	
	// MARK: init
	public init(title: String? = nil, message: String, style: NotificationStyle) {
		super.init(frame: CGRect(x: style.position.startingPoint.x, y: style.position.startingPoint.y, width: screenSize.width-popupPadding, height: 0))
		self.center.x = windowScreen!.center.x
		
		notificationStyle = style
		self.backgroundColor = style.backgroundColor
		
		setupNotiView(title: title, message: message, style: style)
		
		addShadow()
	}
	
	
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
	private func setupNotiView(title: String? = nil, message: String? = nil, style: NotificationStyle) {
		var textHeight: CGFloat = 0
		if let title = title {
			titleLabel.text = title
			titleLabel.textColor = style.tintColor
			verticalContainerStackview.addArrangedSubview(titleLabel)
			textHeight += minimumTitleTextHeight
		}
		
		if let message = message {
			messageLabel.text = message
			messageLabel.textColor = style.tintColor
			verticalContainerStackview.addArrangedSubview(messageLabel)
			textHeight += max(minimumMessageTextHeight, gettingMessageHeight(of: messageLabel.text!))
		}
		
		if let icon = style.icon {
			iconImageView.image = icon.withRenderingMode(.alwaysTemplate)
			iconImageView.tintColor = style.tintColor
			iconView.addSubview(iconImageView)
			horizontalContainerStackview.addArrangedSubview(iconView)
		}
		
		self.frame.size.height = textHeight + 20
		
		horizontalContainerStackview.addArrangedSubview(verticalContainerStackview)
		
		self.addSubview(horizontalContainerStackview)
		windowScreen?.addSubview(self)
		
		layoutConstraints()
	}
	
	
	
	private func layoutConstraints() {
		NSLayoutConstraint.activate([
			horizontalContainerStackview.topAnchor.constraint(equalTo: horizontalContainerStackview.superview!.topAnchor, constant: verticalPadding),
			horizontalContainerStackview.leadingAnchor.constraint(equalTo: horizontalContainerStackview.superview!.leadingAnchor, constant: horizontalPadding),
			horizontalContainerStackview.bottomAnchor.constraint(equalTo: horizontalContainerStackview.superview!.bottomAnchor, constant: -verticalPadding),
			horizontalContainerStackview.trailingAnchor.constraint(equalTo: horizontalContainerStackview.superview!.trailingAnchor, constant: -horizontalPadding)
			])
		
		var constraints: [NSLayoutConstraint] = []
		if let titleText = titleLabel.text, !titleText.isEmpty {
			constraints.append(NSLayoutConstraint(item: titleLabel,
												  attribute: .height,
												  relatedBy: .equal,
												  toItem: nil,
												  attribute: .height,
												  multiplier: 1.0,
												  constant: minimumTitleTextHeight))
		}
		
		if iconImageView.image != nil {
			constraints.append(NSLayoutConstraint(item: iconView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: iconWidth))
			constraints.append(NSLayoutConstraint(item: iconImageView, attribute: .width, relatedBy: .equal, toItem: iconView, attribute: .width, multiplier: 1.0, constant: 0))
			constraints.append(NSLayoutConstraint(item: iconImageView, attribute: .height, relatedBy: .equal, toItem: iconView, attribute: .width, multiplier: 1.0, constant: 0))
			constraints.append(NSLayoutConstraint(item: iconImageView, attribute: .top, relatedBy: .equal, toItem: iconView, attribute: .top, multiplier: 1.0, constant: 10))
			constraints.append(NSLayoutConstraint(item: iconImageView, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
		}
		
		self.addConstraints(constraints)
		
		let dismissRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
		addGestureRecognizer(dismissRecognizer)
	}
	
	
	
	private func addShadow() {
		layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
		layer.shadowRadius = 2
		layer.shadowOpacity = 0.5
		layer.shadowColor = UIColor.lightGray.cgColor
	}
	
	
	
	public func show() {
		switch notificationStyle.position {
		case .top:
			UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelStatusBar
			UIView.animate(withDuration: 0.3,
						   delay: 0.0,
						   usingSpringWithDamping: 0.5,
						   initialSpringVelocity: 0.1,
						   options: [.curveEaseIn],
						   animations: {
							self.frame.origin.y = 0
			}, completion: { finish in
				guard finish else { return }
				self.dismisNotificationPopUp(after: self.notificationStyle.timeDuration)
			})
		case .bottom:
			UIView.animate(withDuration: 0.3,
						   delay: 0.0,
						   usingSpringWithDamping: 0.5,
						   initialSpringVelocity: 0.1,
						   options: UIViewAnimationOptions(),
						   animations: {
							self.frame.origin.y = self.screenSize.height - self.frame.size.height
			}, completion: { finish in
				guard finish else { return }
				self.dismisNotificationPopUp(after: self.notificationStyle.timeDuration)
			})
		}
	}
	
	
	
	@objc
	private func dismiss() {
		switch notificationStyle.position {
		case .top:
			UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [.curveEaseOut], animations: {
				self.frame.origin.y = -self.bounds.height
			}, completion: { finish in
				guard finish else { return }
				UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
				self.removeFromSuperview()
			})
		case .bottom:
			UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [.curveEaseOut], animations: {
				self.frame.origin.y = self.screenSize.height + 30
			}, completion: { finish in
				guard finish else { return }
				self.removeFromSuperview()
			})
		}
	}
	
	
	
	private func dismisNotificationPopUp(after second: TimeInterval) {
		guard second > 0 else { return }
		Timer.scheduledTimer(timeInterval: Double(second), target: self, selector: #selector(dismiss), userInfo: nil, repeats: false)
	}
	
	
	
	private func gettingMessageHeight(of text: String) -> CGFloat {
		let font = UIFont.systemFont(ofSize: messageFontSize)
		let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: (screenSize.width - iconWidth - paddingHorizontalStackView), height: .greatestFiniteMagnitude))
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.font = font
		label.text = text
		label.sizeToFit()
		return label.frame.height
	}
}
