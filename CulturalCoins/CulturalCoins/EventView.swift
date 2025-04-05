//
//  EventView.swift
//  CulturalCoins
//
//  Created by Mac25 on 2025/3/19.
//

import SwiftUI

struct EventView: View {
    @State private var input = ""
    
    let eventTypes = ["音樂", "戲劇", "舞蹈", "展覽", "電影", "閱讀"]
    @State private var eventTypesIndex = 0
    
    let areas = ["台北", "新北", "基隆", "桃園", "新竹", "苗栗"]
    @State private var areaIndex = 0
    @State private var showTempView = false
    @State var showMenu = false
    @State var showOption = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // background
                Image("eventBackground")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    TopToolBarView(showingOption: $showOption, showingMenu: $showMenu)
                    
                    // 尋找活動輸入欄位
                    HStack {
                        Picker("活動類別", selection: $eventTypesIndex) {
                            ForEach(eventTypes.indices, id: \.self) {index in
                                Text(eventTypes[index])
                            }
                        }
                        
                        Picker("地區", selection: $areaIndex) {
                            ForEach(areas.indices, id: \.self) {index in
                                Text(areas[index])
                            }
                        }
                        
                        TextField("尋找活動", text: $input)
                        Image(systemName: "arrowshape.turn.up.right.circle")
                            .imageScale(.large)
                            .padding(.trailing, 10)
                            .foregroundColor(.orange)
                    }
                    .padding(10)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 25)
                    )
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                    .padding(.top, 100)
                    
                    ScrollEventView()
                }
                
                OptionView(isShowingOptionView: $showOption)
                SideMenuView(isShowing: $showMenu)
            } // ZStack
        }
    }
}
