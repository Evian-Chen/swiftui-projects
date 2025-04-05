//
//  ContentView.swift
//  Navigation
//
//  Created by Mac25 on 2025/3/13.
//

import SwiftUI

struct FriendListView: View {
    @State private var path = NavigationPath() // 用來記錄當前的
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Button("進入聊天室") {
                    path.append("chatroom") // Push 到 ChatRoomView
                }
                Button("進入貼文") {
                    path.append("postDetail") // Push 到 PostDetailView
                }
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "chatroom" {
                    ChatRoomView()
                } else if destination == "postDetail" {
                    ContentView()
                }
            }
            .navigationTitle("好友列表")
        }
    }
}

struct ChatRoomView: View {
    var body: some View {
        NavigationStack {
            List(0..<100) { i in
                Text("Row \(i)")
            }
            .navigationTitle("Title goes here")
            .toolbarColorScheme(.dark)
        }
        .navigationTitle("聊天室")
    }
}

struct ChatRoomView2: View {
    var body: some View {
        Text("這是聊天室頁面222")
            .navigationTitle("聊天室222")
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            //View1
            ChatRoomView()
                .tabItem {
                    Label("聊天室", systemImage: "message.fill")
                }
            //View2
            FriendListView()
                .tabItem {
                    Label("好友", systemImage: "person.2.fill")
                }
            //View3
            ChatRoomView2()
                .tabItem {
                    Label("聊聊天室", systemImage: "message.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
