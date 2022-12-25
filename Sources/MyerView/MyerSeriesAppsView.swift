//
//  SwiftUIView.swift
//  
//
//  Created by Photon Juniper on 2022/12/24.
//

import SwiftUI

protocol MyerSeriesApp {
    var title: String { get }
    var description: String { get }
    var icon: String { get }
    var themeColor: Color { get }
    var backgroundColor: Color { get }
    var storeLink: URL { get }
}

struct MyerListApp: MyerSeriesApp {
    var title: String {
        return "MyerList"
    }
    
    var description: String {
        return "MyerListDesc"
    }
    
    var icon: String {
        return "myerlist"
    }
    
    var themeColor: Color {
        return Color(hex: 0x0060ff)
    }
    
    var backgroundColor: Color {
        return Color(hex: 0xfbfcff)
    }
    
    var storeLink: URL {
        return URL(string: "https://apps.apple.com/us/app/myerlist/id1659589940")!
    }
}

struct MyerTidyApp: MyerSeriesApp {
    var title: String {
        return "MyerTidy"
    }
    
    var description: String {
        return "MyerTidyDesc"
    }
    
    var icon: String {
        return "myertidy"
    }
    
    var themeColor: Color {
        return Color(hex: 0x894F16)
    }
    
    var backgroundColor: Color {
        return Color(hex: 0xfdfcfb)
    }
    
    var storeLink: URL {
        return URL(string: "https://apps.apple.com/us/app/myertidy/id1609860733")!
    }
}

struct MyerSplashApp: MyerSeriesApp {
    var title: String {
        return "MyerSplash"
    }
    
    var description: String {
        return "MyerSplashDesc"
    }
    
    var icon: String {
        return "myersplash"
    }
    
    var themeColor: Color {
        return Color(hex: 0x2A8F9A)
    }
    
    var backgroundColor: Color {
        return Color(hex: 0xfcfdfd)
    }
    
    var storeLink: URL {
        return URL(string: "https://apps.apple.com/us/app/myersplash/id1486017120")!
    }
}

public struct MyerSeriesAppsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    private let apps: [any MyerSeriesApp] = [
        MyerSplashApp(), MyerTidyApp(), MyerListApp()
    ]
    
    var showView: Binding<Bool>
    
    public init(showView: Binding<Bool>) {
        self.showView = showView
    }
    
    public var body: some View {
        
        VStack {
            VStack {
                Image(systemName: "xmark")
                    .renderingMode(.template)
                    .padding(20)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showView.wrappedValue.toggle()
                    }
            }.matchParent(axis: .width, alignment: .topTrailing)
            
            Text(LocalizedStringKey("MyerSeries apps"), bundle: .module)
                .font(.largeTitle.bold())
            
            Text("by JuniperPhoton")
                .padding(0)
                .font(.body)
            
            Spacer().frame(height: 20)

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(apps, id: \.title) { app in
                        AppView(app: app).padding(.horizontal)
                    }
                }
            }
            
        }.padding(0)
        #if os(macOS)
        .frame(minWidth: 500, minHeight: 500)
        #endif
        .background(Image(packageResource: colorScheme == .light ? "background_light" : "background_dark", ofType: "png"))
    }
}

struct AppView: View {
    @Environment(\.openURL) var openURL
    let app: MyerSeriesApp
    
    var body: some View {
        HStack {
            Image(packageResource: app.icon, ofType: "png")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(app.title)
                        .foregroundColor(app.themeColor)
                        .font(.title2.bold())
                    
                    Spacer()
                    
                    Image(packageResource: "apple_b", ofType: "png")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(app.themeColor)
                        .frame(width: 20, height: 20)
                }
                
                Text(LocalizedStringKey(app.description), bundle: .module)
                    .foregroundColor(app.themeColor)
                    .lineLimit(10)
            }
        }
        .frame(maxWidth: 400, maxHeight: .infinity, alignment: .leading)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12).fill(app.themeColor.opacity(0.02)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(app.themeColor.opacity(1.0), lineWidth: 1.5))
        .onTapGesture {
            openURL(app.storeLink)
        }
    }
}

extension Image {
    init(packageResource name: String, ofType type: String) {
#if canImport(UIKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let image = UIImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(uiImage: image)
#elseif canImport(AppKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let image = NSImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(nsImage: image)
#else
        self.init(name)
#endif
    }
}