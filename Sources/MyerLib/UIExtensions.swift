//
//  UIExtensions.swift
//  ProjectSort
//
//  Created by juniperphoton on 2022/2/12.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct PressActions: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}

struct MatchParent: ViewModifier {
    let matchWidth: Bool
    let matchHeight: Bool
    let alignment: Alignment
    
    func body(content: Content) -> some View {
        content.frame(maxWidth: matchWidth ? .infinity : nil,
                      maxHeight: matchHeight ? .infinity : nil, alignment: alignment)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension View {
    func assist() -> some View {
        self.background(Color.blue)
    }
}

extension View {
    func addShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
    }
    
    @ViewBuilder
    func hiddenIf(condition: Bool) -> some View {
        if (condition) {
            self.hidden()
        } else {
            self
        }
    }
    
    @ViewBuilder
    func runIf(condition: Bool, block: (Self) -> some View) -> some View {
        if (condition) {
            block(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func matchParent(matchWidth: Bool = true,
                     matchHeight: Bool = true,
                     alignment: Alignment = .center) -> some View {
        self.modifier(MatchParent(matchWidth: matchWidth, matchHeight: matchHeight, alignment: alignment))
    }
}

extension EdgeInsets {
    static func createUnified(inset: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
    }
    
    static func createVertical(inset: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: inset, leading: 0, bottom: inset, trailing: 0)
    }
    
    static func createHorizontal(inset: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset)
    }
    
    static func create(_ top: CGFloat, _ leading: CGFloat, _ bottom: CGFloat, _ trailing: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
}

extension CGSize: CustomStringConvertible {
    public var description: String {
        return "\(self.width) x \(self.height)"
    }
}

@available(iOS 16.0, macOS 13.0, *)
extension ProposedViewSize: CustomStringConvertible {
    public var description: String {
        return "\(String(describing: self.width)) x \(String(describing: self.height))"
    }
}

extension View {
    func importFolderOrFiles(isPresented: Binding<Bool>, types: [UTType],
                             allowsMultipleSelection: Bool, onSucess: @escaping ([URL])->Void) -> some View {
        return self.fileImporter(isPresented: isPresented, allowedContentTypes: types,
                                 allowsMultipleSelection: allowsMultipleSelection) { result in
            defer {
                isPresented.wrappedValue = false
            }
            switch result {
            case .success(let urls):
                onSucess(urls)
                break
            case .failure(_):
                break
            }
        }
    }
}
