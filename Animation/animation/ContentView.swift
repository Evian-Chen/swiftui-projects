//
//  ContentView.swift
//  Animation
//
//  Created by Mac25 on 2025/3/6.
//

import SwiftUI

struct ContentView: View {
    @State private var animationAmount1 = 1.0
    @State private var animationAmount2 = 1.0
    
    var body: some View {
        return VStack {
            Stepper("Scale amount", value: $animationAmount1.animation(
                .easeInOut(duration: 1)
                .repeatCount(3, autoreverses: true)
            ), in: 1...10)
            
            Spacer()
            
            Button("Tap Me") {
                // animationAmount += 1
            }
            .padding(50)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .overlay(
                Circle()
                    .stroke(.red)
                    .scaleEffect(animationAmount1)
                    .opacity(2 - animationAmount1)
                    .animation(
                        .easeInOut(duration: 1)
                        .repeatForever(autoreverses: false),
                        value: animationAmount1
                    )
            )
            .onAppear {
                animationAmount1 = 2
            }
            .padding()
            
            Button("Tap Me") {
                animationAmount2 += 0.5
            }
            .padding(50)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .scaleEffect(animationAmount2)
            .animation(.spring(duration: 0.5, bounce: 0.6), value: animationAmount2)
            .blur(radius: (animationAmount2 - 1) * 1.5)
        }
    }
}

struct ExplicitView: View {
    @State private var animationAmount = 0.0
    @State private var enabled = false
    
    var body: some View {
        Button("Tap Me") {
            withAnimation(.spring(duration: 1, bounce: 0.7)) {
                animationAmount += 360
            }
            enabled.toggle()
        }
        .padding(50)
        .background(enabled ? .blue: .red)
        .foregroundStyle(.white)
        .clipShape(.capsule)
        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 0, z: 1))
        .padding(100)
        
        Button("Tap Me") {
            withAnimation(.spring(duration: 1, bounce: 0.7)) {
                animationAmount += 360
            }
            enabled.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled ? .blue : .red)
        .animation(.default, value: enabled)
        .foregroundStyle(.white)
        .clipShape(.rect(cornerRadius: enabled ? 60 : 0))
        .animation(.spring(duration: 0.5, bounce: 0.9), value: enabled)
    }
}

struct GestureView: View {
    let letters = Array("Hello SwiftUI")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.linear.delay(Double(num) / 20), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded { _ in
                    dragAmount = .zero
                    enabled.toggle()
                }
        )
    }
}


struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct TransitionView: View {
    @State private var isShowingRed = false
    
    var body: some View {
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.asymmetric(insertion: .slide, removal: .scale))
            }
            
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        
//        ZStack {
//            Rectangle()
//                .fill(.blue)
//                .frame(width: 200, height: 200)
//            if isShowingRed {
//                Rectangle()
//                    .fill(.red)
//                    .frame(width: 200, height: 200)
//                    .transition(.pivot)
//            }
//        }
//        .onTapGesture {
//            withAnimation {
//                isShowingRed.toggle()
//            }
//        }
    }
}

#Preview {
//    ContentView()
    ExplicitView()
//    GestureView()
//    TransitionView()
}
