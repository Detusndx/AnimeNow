//
//  VideoPlayerV2View.swift
//  Anime Now!
//
//  Created Erik Bautista on 10/1/22.
//  Copyright © 2022. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct VideoPlayerV2View: View {
    let store: Store<VideoPlayerV2Core.State, VideoPlayerV2Core.Action>

    var body: some View {
        AVPlayerView(
            store: store.scope(
                state: \.player,
                action: VideoPlayerV2Core.Action.player
            )
        )
        .overlay(
            WithViewStore(store.scope(state: \.loadingState)) { loadingState in
                switch loadingState.state {
                case .some(.fetchingEpisodes):
                    buildLoadingIndicator("Loading Episodes")
                case .some(.fetchingSources):
                    buildLoadingIndicator("Loading Sources")
                case .some(.buffering):
                    buildLoadingIndicator()
                case .none:
                    EmptyView()
                }
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        )
        .overlay(
            WithViewStore(store.scope(state: \.error)) { errorState in
                switch errorState.state {
                case .some(.failedToLoadEpisodes):
                    Text("Failed to load episodes")
                case .some(.failedToFindProviders):
                    Text("No providers available for this episode.")
                case .some(.failedToLoadSources):
                    Text("Failed to load sources")
                case .none:
                    EmptyView()
                }
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .statusBar(hidden: true)
        .ignoresSafeArea(edges: .vertical)
        .background(Color.black.edgesIgnoringSafeArea(.all))

////        .overlay(
////            HStack(spacing: 0) {
////                Color.clear
////                    .contentShape(Rectangle())
////                    .onTapGesture(count: 2) {
////                        // TODO: Get Double Tap to work
////                        print("left tapped")
////                    }
////                Color.clear
////                    .contentShape(Rectangle())
////                    .onTapGesture(count: 2) {
////                        // TODO: Get Double Tap to work
////                        print("right tapped")
////                    }
////            }
////                .frame(
////                    maxWidth: .infinity,
////                    maxHeight: .infinity,
////                    alignment: .center
////                )
////        )
//        .onTapGesture {
//            ViewStore(store.stateless).send(.tappedPlayerBounds)
//        }
//        .overlay(playerOverlay)
//        .overlay(statusButton)
//        .overlay(sidepanelView)
//        .statusBar(hidden: true)
//        .ignoresSafeArea(edges: .vertical)
//        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            ViewStore(store.stateless).send(.onAppear)
        }
    }
}

// MARK: Player Overlay

extension VideoPlayerV2View {
//    @ViewBuilder
//    var playerOverlay: some View {
//        WithViewStore(
//            store.scope(state: ViewState.init)
//        ) { showingOverlayViewStore in
//            if showingOverlayViewStore.showPlayerControlsOverlay {
//                VStack(alignment: .leading, spacing: 8) {
//                    topPlayerItems
//                    Spacer()
//                    animeEpisodeInfo
//                    bottomPlayerItems
//                }
//                .frame(
//                    maxWidth: .infinity,
//                    maxHeight: .infinity,
//                    alignment: .center
//                )
//                .padding(.vertical, 24)
//                .background(
//                    LinearGradient(
//                        colors: [
//                            Color.black
//                        ],
//                        startPoint: .top,
//                        endPoint: .bottom
//                    )
//                    .opacity(0.5)
//                    .ignoresSafeArea()
//                )
//            }
//        }
//    }
}

extension VideoPlayerV2View {
    @ViewBuilder
    func buildLoadingIndicator(_ text: String? = nil) -> some View {
        VStack(spacing: 16) {
            ProgressView()
                .colorInvert()
                .brightness(1)
                .scaleEffect(1.5)
                .frame(width: 24, height: 24, alignment: .center)
            if let text = text {
                Text(text)
                    .font(.body.bold())
                    .foregroundColor(Color(white: 0.85))
            }
        }
        .foregroundColor(.white)
        .offset(y: text == nil ? 0 : 24)
    }
}

// MARK: Top Player Items

extension VideoPlayerV2View {
//    @ViewBuilder
//    var topPlayerItems: some View {
//        HStack {
//            closeButton
//        }
//            .transition(.move(edge: .top))
//    }
//
//    @ViewBuilder
//    var closeButton: some View {
//        Circle()
//            .foregroundColor(Color.white)
//            .padding(8)
//            .overlay(
//                Image(
//                    systemName: "xmark"
//                )
//                .foregroundColor(Color.black)
//                .font(.callout.weight(.black))
//            )
//            .frame(width: 46, height: 46)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                ViewStore(store.stateless).send(.closeButtonTapped)
//            }
//    }
}

// MARK: Sidebar Views

extension VideoPlayerV2View {
//    @ViewBuilder
//    var sidepanelView: some View {
//        IfLetStore(
//            store.scope(state: \.sidebarRoute)
//        ) { sidebarStore in
//            WithViewStore(sidebarStore) { sidebarViewStore in
//                VStack {
//                    HStack(alignment: .center) {
//                        Text(sidebarViewStore.state.stringVal)
//                            .foregroundColor(Color.white)
//                            .font(.title2)
//                            .bold()
//                        Spacer()
//                        sidebarCloseButton
//                    }
//
//                    switch sidebarViewStore.state {
//                    case .episodes:
//                        SidebarEpisodesView(
//                            store: store.scope(
//                                state: \.episodesState,
//                                action: VideoPlayerCore.Action.episodes
//                            )
//                        )
//                    case .sources:
//                        SidebarSourcesView(
//                            store: store.scope(
//                                state: \.sourcesState,
//                                action: VideoPlayerCore.Action.sources
//                            )
//                        )
//                    }
//                }
//                .padding([.horizontal, .top])
//            }
//            .aspectRatio(1.0, contentMode: .fit)
//            .frame(maxHeight: .infinity)
//            .background(
//                BlurView(style: .systemThickMaterialDark)
//            )
//            .cornerRadius(18)
//            .padding(.vertical, 24)
//            .transition(.move(edge: .trailing).combined(with: .opacity))
//        }
//        .frame(
//            maxWidth: .infinity,
//            maxHeight: .infinity,
//            alignment: .trailing
//        )
//    }
//
//    @ViewBuilder
//    var sidebarCloseButton: some View {
//        Circle()
//            .foregroundColor(Color.white)
//            .overlay(
//                Image(systemName: "xmark")
//                    .font(.system(size: 12).weight(.black))
//                    .foregroundColor(Color.black.opacity(0.75))
//            )
//            .frame(width: 24, height: 24)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                ViewStore(store.stateless).send(.closeSidebar)
//            }
//    }
}

// MARK: Anime Episode Info

extension VideoPlayerV2View {
//    @ViewBuilder
//    var animeEpisodeInfo: some View {
//        WithViewStore(
//            store.scope(
//                state: ViewState.init
//            )
//        ) { viewState in
//            HStack(alignment: .bottom) {
//                VStack(alignment: .leading) {
//                    if viewState.animeFormat == .tv {
//                        HStack(spacing: 4) {
//                            Text(viewState.animeName)
//                            Text("\u{2022}")
//                            Text("E\(viewState.episodeNumber)")
//                        }
//                        .font(.callout.bold())
//                        .foregroundColor(.white.opacity(0.8))
//                    }
//
//                    HStack {
//                        Text(viewState.animeFormat == .tv ? viewState.episodeName : viewState.animeName)
//                            .font(.title)
//                            .bold()
//
//                        if (viewState.animeFormat == .tv) {
//                            Image(systemName: "chevron.compact.right")
//                                .font(.body.weight(.black))
//                        }
//                    }
//                }
//                .foregroundColor(Color.white)
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    let viewStore = ViewStore(store)
//                    if viewStore.anime.format == .tv {
//                        viewStore.send(.tappedEpisodesSidebar)
//                    }
//                }
//
//                Spacer()
//                playerOptionsButton
//            }
//        }
//    }
}

// MARK: Player Options Buttons

extension VideoPlayerV2View {
//    @ViewBuilder
//    var playerOptionsButton: some View {
//        HStack(spacing: 16) {
//            airplayButton
//            subtitlesButton
//            sourcesButton
//        }
//    }
//
//    @ViewBuilder
//    var sourcesButton: some View {
//        Button {
//            ViewStore(store.stateless).send(.tappedSourcesSidebar)
//        } label: {
//            Image("play.rectangle.on.rectangle.fill")
//                .foregroundColor(Color.white)
//                .font(.title3)
//        }
//    }
//
//    @ViewBuilder
//    var subtitlesButton: some View {
//        Button {
//        } label: {
//            Image(
//                systemName: "captions.bubble.fill"
//            )
//            .foregroundColor(Color.white)
//            .font(.title3)
//        }
//    }
//
//    @ViewBuilder
//    var airplayButton: some View {
//        AirplayRouterPickerView()
//            .fixedSize()
//    }
}

// MARK: Player Controls

extension VideoPlayerV2View {
//    @ViewBuilder
//    var bottomPlayerItems: some View {
//        LazyVStack(alignment: .leading) {
//            seekbarView
//                .frame(height: 14)
//            progressInfo
//        }
//        .transition(.move(edge: .bottom))
//    }
//
//    @ViewBuilder
//    var statusButton: some View {
//        WithViewStore(
//            store.scope(state: ViewState.init(state:))
//        ) { viewState in
//            if viewState.state.isBuffering || !viewState.state.hasLoaded {
//                ProgressView()
//                    .scaleEffect(1.5)
//            } else if viewState.state.showPlayerControlsOverlay {
//                Circle()
//                    .foregroundColor(Color.clear)
//                    .padding(8)
//                    .overlay(
//                        Image(
//                            systemName: viewState.state.isPlaying ? "pause.fill" : "play.fill"
//                        )
//                        .foregroundColor(Color.white)
//                        .font(.title)
//                    )
//                    .frame(width: 48, height: 48)
//                    .contentShape(Circle())
//                    .onTapGesture {
//                        viewState.send(.togglePlayback)
//                    }
//            }
//        }
//        .frame(maxWidth: .infinity)
//    }
//
//    @ViewBuilder
//    var seekbarView: some View {
//        WithViewStore(
//            store.scope(
//                state: ViewState.init(state:)
//            )
//        ) { viewState in
//            SeekbarView(
//                progress: .init(
//                    get: {
//                        viewState.duration > 0 ?
//                        viewState.currentTime / viewState.duration :
//                        0
//                    },
//                    set: {
//                        viewState.send(.slidingSeeker($0))
//                    }
//                ),
//                preloaded: 0.0,
//                onEditingCallback: { editing in
//                    viewState.send(editing ? .startSeeking : .doneSeeking)
//                }
//            )
//            .disabled(viewState.state.duration == 0)
//        }
//        .frame(maxWidth: .infinity)
//    }
//
//    @ViewBuilder
//    var progressInfo: some View {
//        WithViewStore(
//            store.scope(state: ViewState.init)
//        ) { viewState in
//            HStack(spacing: 4) {
//                Text(
//                    viewState.duration > 0 ? viewState.currentTime.timeFormatted : "--:--"
//                )
//                Text("/")
//                Text(
//                    viewState.duration > 0 ? viewState.duration.timeFormatted : "--:--"
//                )
//            }
//            .foregroundColor(.white)
//            .font(.footnote.monospacedDigit())
//        }
//    }
}

struct VideoPlayerV2View_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            VideoPlayerV2View(
                store: .init(
                    initialState: .init(
                        anime: .narutoShippuden,
                        episodes: .init(uniqueElements: Episode.demoEpisodes),
                        selectedEpisode: Episode.demoEpisodes.first!.id
                    ),
                    reducer: VideoPlayerV2Core.reducer,
                    environment: .init(
                        animeClient: .mock,
                        mainQueue: .main.eraseToAnyScheduler(),
                        mainRunLoop: .main.eraseToAnyScheduler(),
                        repositoryClient: RepositoryClientMock.shared,
                        userDefaultsClient: .mock
                    )
                )
            )
            .previewInterfaceOrientation(.landscapeRight)
        } else {
            // Fallback on earlier versions
        }
    }
}
