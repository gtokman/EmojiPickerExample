//
//  ContentView.swift
//  EmojiPickerExample
//
//  Created by Gary Tokman on 4/14/21.
//

import SwiftUI

struct LetterView: View {
    
    @State var isPressed: Bool = false
    let expandedLetters = ["😠", "🙂", "🤩"]
    @State var position: CGSize = .zero
    @State var selectedIndex = 1
    
    var body: some View {
        ZStack {
            Picker(
                selectedIndex: $selectedIndex,
                isPressed: $isPressed,
                expandedLetters: expandedLetters
            )
            
            Text(expandedLetters[selectedIndex])
                .padding()
                .background(Color(.systemGray3))
                .cornerRadius(10)
                .shadow(color: Color(UIColor(white: 0, alpha: isPressed ? 0.05 : 0.35)), radius: 0, x: 0, y: 1)
                .gesture(
                    LongPressGesture(minimumDuration: 1.0)
                        .onChanged({ (success) in
                            isPressed = success
                        })
                )
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                            .onChanged { value in
                                switch value.translation.width {
                                case -20...20:
                                    selectedIndex = 1
                                case 20...:
                                    selectedIndex = 2
                                default:
                                    selectedIndex = 0
                                }
                            }
                            .onEnded { (value) in
                                isPressed = false
                            }
                )
                .animation(.easeInOut(duration: 0.23))
        }
    }
}

struct Picker: View {
    
    @Binding var selectedIndex: Int
    @Binding var isPressed: Bool
    let expandedLetters: [String]
    
    var body: some View {
        Rectangle()
            .overlay(
                GeometryReader { proxy in
                    HStack(spacing: 0) {
                        ForEach(Array(expandedLetters.enumerated()), id: \.offset) { index, letter in
                            Text(letter)
                                .frame(
                                    width: proxy.size.width / CGFloat(expandedLetters.count),
                                    height: proxy.size.height,
                                    alignment: .center
                                )
                                .foregroundColor(.black)
                                .background(
                                    index == selectedIndex
                                        ? Color(.systemGray2)
                                        : Color(.systemGray5)
                                )
                        }
                    }
                    .background(Color(.systemGray5))
                }
            )
            .frame(width: isPressed ? 100 : 30, height: 40)
            .foregroundColor(Color(.systemGray6))
            .cornerRadius(10)
            .offset(y: isPressed ? -46 : 0)
            .animation(.easeInOut(duration: 0.23))
    }
}


struct ContentView: View {
    var body: some View {
        LetterView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
