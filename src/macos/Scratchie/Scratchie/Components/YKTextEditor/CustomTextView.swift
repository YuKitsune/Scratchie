//
//  CustomTextView.swift
//  Scratchie
//
//  Created by Eoin Motherway on 6/3/21.
//

import Foundation
import AppKit

public final class CustomTextView: NSView {
    private var font: NSFont?
    
    weak var delegate: NSTextViewDelegate?
    
    var attributedText: NSAttributedString {
        didSet {
            textView.textStorage?.setAttributedString(attributedText)
        }
    }
    
    var text: String {
        didSet {
            textView.string = text
        }
    }
    
    var selectedRanges: [NSValue] = [] {
        didSet {
            guard selectedRanges.count > 0 else { return }
            textView.selectedRanges = selectedRanges
        }
    }
        
    var allowsDocumentBackgroundColorChange: Bool {
        get { textView.allowsDocumentBackgroundColorChange }
        set { textView.allowsDocumentBackgroundColorChange = newValue }
    }
    
    var backgroundColor: NSColor {
        get { textView.backgroundColor }
        set { textView.backgroundColor = newValue }
    }
    
    var drawsBackground: Bool {
        get { textView.drawsBackground }
        set { textView.drawsBackground = newValue }
    }
    
    var insertionPointColor: NSColor? {
        get { textView.insertionPointColor }
        set { textView.insertionPointColor = newValue ?? textView.insertionPointColor }
    }
    
    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = false
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalRuler = false
        scrollView.autoresizingMask = [.width, .height]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var textView: NSTextView = {
        let contentSize = scrollView.contentSize
        let textStorage = NSTextStorage()

        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(containerSize: scrollView.frame.size)
        textContainer.widthTracksTextView = true
        textContainer.containerSize = NSSize(
            width: contentSize.width,
            height: CGFloat.greatestFiniteMagnitude
        )
        
        layoutManager.addTextContainer(textContainer)
        
        let textView = NSTextView(frame: .zero, textContainer: textContainer)
        textView.autoresizingMask = .width
        textView.backgroundColor = .clear
        textView.delegate = self.delegate
        textView.font = self.font
        textView.isEditable = true
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.minSize = NSSize(width: 0, height: contentSize.height)
        textView.textColor = NSColor.labelColor
        
        return textView
    }()

    init(text: String, font: NSFont?) {
        self.font       = font
        self.text       = text
        self.attributedText = NSMutableAttributedString()
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func viewWillDraw() {
        super.viewWillDraw()
        
        setupScrollViewConstraints()
        setupTextView()
    }
    
    func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    func setupTextView() {
        scrollView.documentView = textView
    }
}
