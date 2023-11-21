//
//  TipsView.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 17/08/2023.
//

import SwiftUI
import TipKit

struct FavoriteLandmarkTip: Tip {
    var title: Text {
        Text("Save as a Favorite")
    }
    var message: Text? {
        Text("Your favorite landmarks always appear at the top of the list.")
    }
    var asset: Image? {
        Image(systemName: "star")
    }
}

struct FavoriteSongTip: Tip {
    var title: Text {
        Text("Save song")
    }
    var message: Text? {
        Text("Your favorite songs always appear at the top of the list.")
    }
    var asset: Image? {
        Image(systemName: "music.note.list")
    }
}

struct FavoritePhotoTip: Tip {
    var title: Text {
        Text("Save photo")
    }
    var message: Text? {
        Text("Your favorite photos always appear at the top of the list.")
    }
    var asset: Image? {
        Image(systemName: "photo")
    }
}

struct TipsView: View {

    var landmarkTip = FavoriteLandmarkTip()
    var songTip = FavoriteSongTip()
    var photoTip = FavoritePhotoTip()

    var body: some View {
        List {
            Text("iOS 17 has a facility for showing contextual tips that highlight new, interesting, or unused features people haven’t discovered on their own yet, Don’t use tips to guide people through your app, or for advertising and promotion purposes.")
            .font(.caption2)
            .foregroundColor(.secondary)
            VStack {
                TipView(landmarkTip, arrowEdge: .bottom)
                Image(systemName: "star")
                    .imageScale(.large)
            }
            .padding()
            HStack {
                Image(systemName: "music.note.list")
                    .imageScale(.large)
                TipView(songTip, arrowEdge: .leading)
            }
            .padding()
            HStack {
                TipView(photoTip, arrowEdge: .trailing)
                Image(systemName: "photo")
                    .imageScale(.large)
            }
            .padding()
        }
        .task {
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView()
    }
}
