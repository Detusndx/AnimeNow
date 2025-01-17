//
//  Episode.swift
//  Anime Now!
//
//  Created by ErrorErrorError on 9/4/22.
//

import Foundation

// MARK: - EpisodeRepresentable

public protocol EpisodeRepresentable: Hashable, Identifiable {
    var number: Int { get }
    var title: String { get }
    var thumbnail: ImageSize? { get }
    var isFiller: Bool { get }
    var links: Set<EpisodeLink> { get }

    func isEqualTo(_ item: some EpisodeRepresentable) -> Bool
    func eraseAsRepresentable() -> AnyEpisodeRepresentable
}

// MARK: - EpisodeLink

public enum EpisodeLink: Hashable, Identifiable, CustomStringConvertible {
    public var id: String {
        switch self {
        case let .stream(id: id, audio: audio):
            return "\(id)-\(audio)"
        case let .offline(url: url):
            return "\(url.description)"
        }
    }

    public var description: String { audio.description }

    case stream(id: String, audio: Audio)
    case offline(url: URL)

    public var audio: Audio {
        switch self {
        case let .stream(_, audio):
            return audio
        default:
            return .sub
        }
    }

    public enum Audio: Hashable, CustomStringConvertible, Codable {
        case sub
        case dub
        case custom(String)

        public var isDub: Bool {
            self != .sub
        }

        public var description: String {
            switch self {
            case .sub:
                return "Sub"
            case .dub:
                return "Dub"
            case let .custom(custom):
                return custom
            }
        }
    }
}

public extension EpisodeRepresentable where Self: Equatable {
    func isEqualTo(_ item: some EpisodeRepresentable) -> Bool {
        guard let item = item as? Self else {
            return false
        }
        return self == item
    }
}

public extension EpisodeRepresentable {
    func eraseAsRepresentable() -> AnyEpisodeRepresentable {
        .init(self)
    }
}

// MARK: - AnyEpisodeRepresentable

public struct AnyEpisodeRepresentable: EpisodeRepresentable, Identifiable {
    private let episode: any EpisodeRepresentable

    public var id: Int {
        episode.number
    }

    public var number: Int {
        episode.number
    }

    public var title: String {
        episode.title
    }

    public var thumbnail: ImageSize? {
        episode.thumbnail
    }

    public var isFiller: Bool {
        episode.isFiller
    }

    public var links: Set<EpisodeLink> {
        episode.links
    }

    init(_ episode: some EpisodeRepresentable) {
        self.episode = episode
    }
}

// MARK: Hashable

extension AnyEpisodeRepresentable: Hashable {
    public static func == (lhs: AnyEpisodeRepresentable, rhs: AnyEpisodeRepresentable) -> Bool {
        lhs.episode.isEqualTo(rhs.episode)
    }

    public func hash(into hasher: inout Hasher) {
        episode.hash(into: &hasher)
    }
}

// MARK: - Episode

public struct Episode: EpisodeRepresentable {
    public var id: Int { number }
    public let title: String
    public let number: Int
    public let description: String
    public let thumbnail: ImageSize?
    public let isFiller: Bool
    public var links: Set<EpisodeLink>

    public init(
        title: String,
        number: Int,
        description: String,
        thumbnail: ImageSize? = nil,
        isFiller: Bool,
        links: Set<EpisodeLink> = .init()
    ) {
        self.title = title
        self.number = number
        self.description = description
        self.thumbnail = thumbnail
        self.isFiller = isFiller
        self.links = links
    }
}

public extension Episode {
    static let empty = Episode(
        title: "",
        number: 0,
        description: "",
        thumbnail: nil,
        isFiller: false
    )

    // swiftlint:disable force_unwrapping
    static let demoEpisodes: [Episode] = [
        .init(
            title: "Homecoming",
            number: 1,
            description:
            """
            An older and stronger Naruto returns from his two and a half years of training with Jiraiya.
            """,
            thumbnail: .original(URL(string: "https://artworks.thetvdb.com/banners/episodes/79824/320623.jpg")!),
            isFiller: false
        ),
        .init(
            title: "Homecoming 2",
            number: 2,
            description:
            """
            An older and stronger Naruto returns from his two and a half years of training with Jiraiya.
            """,
            thumbnail: .original(URL(string: "https://artworks.thetvdb.com/banners/episodes/79824/320623.jpg")!),
            isFiller: true
        )
    ]

    static let placeholder = createPlaceholder(0)

    private static func createPlaceholder(_ id: Int) -> Episode {
        .init(
            title: "Placeholder",
            number: id,
            description: "Placeholder",
            thumbnail: nil,
            isFiller: false
        )
    }

    static func placeholders(_ count: Int) -> [Episode] {
        (0..<count).map(createPlaceholder(_:))
    }
}
