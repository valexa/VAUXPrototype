//
//  LoadView.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 11/08/2023.
//

import SwiftUI

struct LoadView: View {

    @ObservedObject var viewModel = LoadViewModel(source: LoadViewSource(), threshold: 1, pageSize: 1)

    var body: some View {
        ScrollView {
            Text("This shows a pagination loader that is loading new pages every second, you can also drag down to force a reload.")
            .font(.caption2)
            .foregroundColor(.secondary)
            ForEach(viewModel.items) { item in
                CtaView()
                    .onAppear {
                        viewModel.onItemAppear(item)
                    }
            }
            if viewModel.state != .loaded {
                paginationLoader
            }
        }
        .refreshable {
            await viewModel.fetchAll()
        }
        .task {
            await viewModel.loadMoreItems()
        }
    }

    var paginationLoader: some View {
        LazyVStack(spacing: 12) {
            HStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
                Spacer()
            }
            Spacer(minLength: 12)
        }
        .padding(12)
    }

}

struct LoadView_Previews: PreviewProvider {
    static var previews: some View {
        LoadView()
    }
}
