//
//  EnimeAPI.swift
//
//
//  Created by ErrorErrorError on 1/18/23.
//
//

import Foundation
import SharedModels

// MARK: - EnimeEndpoint

public struct EnimeEndpoint<D: Decodable>: Endpoint {
    var base = URL(string: "https://api.enime.moe").unsafelyUnwrapped
    var path: [CustomStringConvertible] = []
    var query: [Query] = []
    var method: Request<D>.Method = .get
    var headers: [String: CustomStringConvertible]?
}

public extension EnimeEndpoint {
    static func recentEpisodes(
        page: Int = 1,
        perPage: Int = 25
    ) -> EnimeEndpoint<EnimeModels.Response> {
        .init(
            path: ["recent"],
            query: [
                .init(name: "page", page),
                .init(name: "perPage", perPage)
            ]
        )
    }
}

public extension Request {
    static func enime<D: Decodable>(_ endpoint: EnimeEndpoint<D>) -> Request<D> {
        endpoint.build()
    }
}

// MARK: - EnimeModels

public enum EnimeModels {}

public extension EnimeModels {
    struct Response: Decodable {
        public let data: [RecentItem]
    }

    struct RecentItem: Decodable {
        let id: String // EpisodeId
        let number: Int
        let image: String?
        let updatedAt: String?
        let airedAt: String?
        let anime: Anime
        let titleVariations: Title?
        let description: String?
    }

    struct Anime: Decodable {
        let id: String
        let anilistId: Int
        let coverImage: String?
        let bannerImage: String?
        let title: Title?
        let status: String
        let format: String
        let description: String?
        let genre: [String]?
    }

    struct Title: Decodable {
        let native: String?
        let romaji: String?
        let english: String?
    }
}

public extension EnimeModels {
    static func convert(from item: RecentItem) -> SharedModels.UpdatedAnimeEpisode {
        var posterImage = [SharedModels.ImageSize]()
        var coverImage = [SharedModels.ImageSize]()

        var categories = [String]()

        if let coverImage = item.anime.coverImage, let url = URL(string: coverImage) {
            posterImage.append(.original(url))
        }

        if let bannerImage = item.anime.bannerImage, let url = URL(string: bannerImage) {
            coverImage.append(.original(url))
        }

        if let genre = item.anime.genre {
            categories = genre
        }

        let anilistFormat = AniListModels.Media.Format(rawValue: item.anime.format) ?? .TV
        let format: SharedModels.Anime.Format

        switch anilistFormat {
        case .MOVIE:
            format = .movie
        case .TV:
            format = .tv
        case .TV_SHORT:
            format = .tvShort
        case .OVA:
            format = .ova
        case .ONA:
            format = .ona
        case .SPECIAL:
            format = .special
        }

        let anilistStatus = AniListModels.Media.Status(rawValue: item.anime.status) ?? .RELEASING
        let status: SharedModels.Anime.Status

        switch anilistStatus {
        case .FINISHED:
            status = .finished
        case .RELEASING:
            status = .current
        case .NOT_YET_RELEASED:
            status = .upcoming
        case .CANCELLED:
            status = .unreleased
        case .HIATUS:
            status = .tba
        }

        let thumbnail = item.image
            .flatMap { URL(string: $0) }
            .flatMap { ImageSize.original($0) }

        return .init(
            anime: .init(
                id: item.anime.anilistId,
                title: item.anime.title?.english ?? item.anime.title?.romaji ?? item.anime.title?.native ?? "Unknown",
                description: item.anime.description ?? "Description unavailable",
                posterImage: posterImage,
                coverImage: coverImage,
                categories: categories,
                status: status,
                format: format
            ),
            episode: .init(
                title: item.titleVariations?.english ?? item.titleVariations?.romaji ?? "Episode \(item.number)",
                number: item.number,
                description: item.description ?? "No description available.",
                thumbnail: thumbnail ?? posterImage.largest,
                isFiller: false
            )
        )
    }
}
