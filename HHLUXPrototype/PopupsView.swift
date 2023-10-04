//
//  PopupsView.swift
//  HHLUXPrototype
//
//  Created by Vlad Alexa on 13/08/2023.
//

import SwiftUI

struct PopupsView: View {

    @State private var isShowingPop = false
    @State private var isShowingSheet = false
    @State private var isShowingDialog = false

    var body: some View {
        Form {
            presentation
            Section {
                Text("Tap any of the above to preview a popup, to dismiss either tap outside the popups or swipe them away")
                    .foregroundColor(.secondary)
            }
        }
    }

    var modalContent: some View {
        Text("Full screen modal")
    }

    var sheetContent: some View {
        Text("Resizable bottom sheet, can be dragged to dismiss or cover most screen, configurable size options are : .medium .large or custom screen size (multiple options can be provided together enabling the user to switch/resize between them)")
            .padding()
    }

    var dialogContent: some View {
        Group {
            Button("Standard Action") {
            }
            Button("Cancel Action", role: .cancel) {
            }
            Button("Destructive Action", role: .destructive) {
            }
        }
    }

    var presentation: some View {
        Section("Presentation options") {
            Button("Modal") {
                isShowingPop.toggle()
            }
            .sheet(isPresented: $isShowingPop) {
                modalContent
            }
            Button("Sheet") {
                isShowingSheet.toggle()
            }
            .sheet(isPresented: $isShowingSheet) {
                sheetContent
                .presentationDetents([.medium, .large])
            }
            Button("Dialog") {
                isShowingDialog.toggle()
            }
            .confirmationDialog("Dialog label that can not be configured or removed, it can however be set to a empty string", isPresented: $isShowingDialog, titleVisibility: .visible) {
                dialogContent
            }
        }
    }

}

struct PopupsView_Previews: PreviewProvider {
    static var previews: some View {
        PopupsView()
    }
}
