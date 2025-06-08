//
//  FullScreenNotification.swift
//  TestNotification
//
//  Created by Paul Solt on 7/14/24.
//


import Cocoa

class FullScreenNotification: NSPanel {
    
    init(contentRect: NSRect) {
        super.init(contentRect: contentRect,
                   styleMask: [.borderless, .nonactivatingPanel],
                   backing: .buffered,
                   defer: false)
        
        // Set window level
        self.level = .mainMenu + 1
        
        // Make it non-resizable and non-closable
        self.isFloatingPanel = true
        self.collectionBehavior = [.canJoinAllSpaces, .ignoresCycle]
        
        // Make it non-activating so it doesn't take focus
        self.isReleasedWhenClosed = false
        self.isMovableByWindowBackground = false
        self.isOpaque = false
        self.hasShadow = false
        self.backgroundColor = NSColor.clear
        
//        self.ignoresMouseEvents = false  // FIXME: Do not use this property or you break default behavior (unless you want to swallow all touches from background apps)
        
        // Create the content view
        let contentView = NSView(frame: contentRect)
        contentView.wantsLayer = true
        contentView.layer?.backgroundColor = NSColor.clear.cgColor // NOTE: Clear background color to allow clicks, or transparent color to obscure screen
        self.contentView = contentView
        
        // Create the close button
        let icon = NSImage(systemSymbolName: "xmark", accessibilityDescription: nil)!
        let closeButton = NSButton(image: icon, target: self, action: #selector(closePanel))
        closeButton.bezelStyle = .circular
        closeButton.wantsLayer = true
        closeButton.layer?.cornerRadius = 5
        closeButton.layer?.masksToBounds = true
        
        // Create the message label
        let messageLabel = NSTextField(labelWithString: "This is a full screen notification")
        messageLabel.textColor = .white
        messageLabel.font = NSFont.systemFont(ofSize: 55)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.alignment = .center
        messageLabel.isEditable = false     // NOTE: Do this to prevent touches from being swallowed from ClickGestures
        messageLabel.isSelectable = false   // NOTE: Do this to prevent touches from being swallowed from ClickGestures
        messageLabel.isBordered = false
        messageLabel.backgroundColor = .clear
        messageLabel.setAccessibilityIdentifier("messageLabel") // TODO: Set accessibility identifiers
        
        // Create a container view for the message label
        let messageContainer = NSView()
        messageContainer.wantsLayer = true
        messageContainer.layer?.backgroundColor = NSColor.black.cgColor
        messageContainer.layer?.cornerRadius = 10
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the message label to the message container
        messageContainer.addSubview(messageLabel)
        messageContainer.addSubview(closeButton)
        contentView.addSubview(messageContainer)
        
        let padding: CGFloat = 40
        // Add the message container constraints
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -padding),
            messageLabel.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: padding),
            messageLabel.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -padding),
            
            messageContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            messageContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
            // NOTE: Add constraints for any buttons you want to add, I skipped that for this code
        ])
        
        // Add click gesture recognizer to the message container
        let clickRecognizer = NSClickGestureRecognizer(target: self, action: #selector(closePanel))
        messageLabel.addGestureRecognizer(clickRecognizer)
                
        // Initial state for fade-in animation
        self.alphaValue = 0
    }
    
    
    func show(animated: Bool = true, duration: Int? = 10) {
        self.orderFront(nil) // NOTE: This is important for NSPanel that are non-activiating (not a key window), don't use the "makeKey" methods.
        if animated {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.3
                context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                self.animator().alphaValue = 1.0
            }) {
                if let duration = duration {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(duration)) {
                        self.closeWithFadeOutAnimation()
                    }
                }
            }
        } else {
            self.alphaValue = 1.0
            if let duration = duration {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(duration)) {
                    self.closeWithFadeOutAnimation()
                }
            }
        }
    }
    
    @objc func closePanel() {
        print("CLOSE!")
        closeWithFadeOutAnimation()
    }
    
    func closeWithFadeOutAnimation() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.animator().alphaValue = 0.0
        }) {
            self.orderOut(nil)
        }
    }
    
    /// Static methods
    
    static var shared: FullScreenNotification!
    
    public static func showNotification(duration: Int = 10) {
        guard let screen = NSScreen.main else { return }
        let screenRect = screen.frame
        
        if shared == nil {
            shared = FullScreenNotification(contentRect: screenRect)
        }
        shared.show(animated: true, duration: duration)
    }
    
    public static func hideNotification() {
        guard let shared else { return }
        shared.closeWithFadeOutAnimation()
    }
}