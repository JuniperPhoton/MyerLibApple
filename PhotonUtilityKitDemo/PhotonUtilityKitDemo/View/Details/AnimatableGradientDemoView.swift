//
//  AnimatableGradientExample.swift
//  PhotonUtilityKitDemo
//
//  Created by Photon Juniper on 2023/7/10.
//

import SwiftUI
import PhotonUtilityView

struct AnimatableGradientDemoView: View {
    @State private var progress: CGFloat = 0
    
    var body: some View {
        VStack {
            let from = Gradient(colors: [.accentColor, .red, .green])
            let to = Gradient(colors: [.green, .orange, .gray])
            
            Text("Capsule linear")
                .font(.title.bold())
                .foregroundColor(.white)
                .padding()
                .padding()
                .background(
                    Capsule()
                        .fillAnimatableGradient(fromGradient: from,
                                                toGradient: to,
                                                progress: progress) { gradient in
                                                    LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .trailing)
                                                }
                )

            Text("RoundedRectangle angular")
                .font(.title.bold())
                .foregroundColor(.white)
                .padding()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fillAnimatableGradient(fromGradient: from,
                                                toGradient: to,
                                                progress: progress) { gradient in
                                                    AngularGradient(gradient: gradient, center: .center, angle: .degrees(progress == 1.0 ? 30 : 0.0))
                                                }
                )
            
            HStack {
                Text("Circle")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .addShadow(x: 0, y: 0)
                    .padding()
                    .padding()
                    .background(
                        Circle()
                            .fillAnimatableGradient(fromGradient: Gradient(colors: [Color("ThemeAwareColor"), Color.white]),
                                                    toGradient:Gradient(colors: [Color("ThemeAwareColor"), Color.white]),
                                                    progress: progress) { gradient in
                                                        LinearGradient(gradient: gradient, startPoint: progress == 1.0 ? .bottomTrailing : .topLeading, endPoint: .trailing)
                                                    }
                    )
                
                Text("Surface")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .addShadow(x: 0, y: 0)
                    .padding()
                    .padding()
                    .background(
                        Circle()
                            .fillAnimatableGradient(fromGradient: Gradient(colors: [Color("SurfaceColor"), Color.white]),
                                                    toGradient:Gradient(colors: [Color.white, Color("SurfaceColor")]),
                                                    progress: progress) { gradient in
                                                        LinearGradient(gradient: gradient,
                                                                       startPoint: .topLeading,
                                                                       endPoint: .bottomTrailing)
                                                    }
                    )
            }
            
            Button("Animate") {
                withAnimation(.easeOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    self.progress = self.progress == 1.0 ? 0.0 : 1.0
                }
            }.padding()
        }
        .matchParent()
        .background(
            Rectangle()
                .fillAnimatableGradient(
                    fromGradient: .init(colors: [.accentColor.opacity(0.2), .red.opacity(0.1)]),
                    toGradient: .init(colors: [.red.opacity(0.1), .accentColor.opacity(0.2)]),
                    progress: progress,
                    fillShape: { gradient in
                        LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .bottomTrailing)
                    }
                ).ignoresSafeArea()
        )
    }
}
