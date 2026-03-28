import Foundation

// MARK: - 목 커뮤니티 서비스
/// 개발 및 프리뷰용 목 데이터 제공 서비스
final class MockCommunityService {
    /// 채널별 고정 UUID (게시글 연결용)
    private let channelIds: [InterestTag: UUID] = {
        var ids: [InterestTag: UUID] = [:]
        for tag in InterestTag.allCases {
            ids[tag] = UUID()
        }
        return ids
    }()

    /// 게시글별 고정 UUID (댓글 연결용)
    private var postIds: [UUID] = []

    init() {}

    // MARK: - 채널 목 데이터

    /// 태그별 채널 10개 생성
    /// - Returns: 목 채널 배열
    func loadChannels() -> [Channel] {
        let channelData: [(InterestTag, String, String, Int, Int)] = [
            (.gaming, "게이머즈 아지트", "게임 리뷰, 공략, 소식을 나누는 공간", 1247, 389),
            (.cooking, "오늘 뭐 먹지?", "레시피 공유와 요리 팁을 나누는 커뮤니티", 892, 256),
            (.photography, "찰칵 모멘트", "사진 작품 공유와 촬영 기법 토론", 634, 178),
            (.fitness, "헬스 메이트", "운동 루틴, 식단, 동기부여를 함께하는 곳", 1056, 312),
            (.music, "사운드 웨이브", "음악 추천, 리뷰, 플레이리스트 공유", 723, 201),
            (.reading, "책벌레 모임", "독서 토론과 서평을 나누는 독서 모임", 445, 134),
            (.travel, "여행자의 지도", "여행 후기, 꿀팁, 동행 모집", 867, 267),
            (.pets, "멍냥 가족", "반려동물 일상과 양육 정보 공유", 1389, 423),
            (.art, "아트 갤러리", "창작 작품 공유와 예술 이야기", 521, 156),
            (.tech, "테크 허브", "최신 기술 트렌드와 개발 이야기", 978, 289),
        ]

        return channelData.map { tag, name, description, members, posts in
            Channel(
                id: channelIds[tag] ?? UUID(),
                name: name,
                descriptionText: description,
                tag: tag,
                memberCount: members,
                postCount: posts,
                createdAt: Date().addingTimeInterval(-Double.random(in: 86400...2592000)),
                isJoined: [.gaming, .tech, .music].contains(tag)
            )
        }
    }

    // MARK: - 게시글 목 데이터

    /// 특정 채널의 게시글 생성
    /// - Parameter channelId: 채널 UUID
    /// - Returns: 목 게시글 배열
    func loadPosts(for channelId: UUID) -> [Post] {
        // 채널 ID로 태그 결정
        let tag = channelIds.first(where: { $0.value == channelId })?.key ?? .tech

        let postsData: [String: [(String, String, Int, Int)]] = [
            "gaming": [
                ("ProGamer김", "젤다 새 DLC 해보신 분? 난이도가 꽤 올라간 느낌인데 보스전이 정말 재밌어요.", 42, 8),
                ("게임러버", "이번 주말에 같이 발로란트 하실 분 구합니다! 실버~골드 티어 환영", 15, 12),
                ("닌텐도팬", "스위치 2 발표 보셨나요? 사전예약 해야 할지 고민 중입니다.", 89, 23),
                ("인디헌터", "최근 발견한 인디 게임 추천합니다. 분위기 게임 좋아하시는 분들 꼭 해보세요.", 31, 5),
            ],
            "cooking": [
                ("집밥요리사", "초간단 원팬 파스타 레시피 공유합니다! 재료 3가지면 끝이에요.", 67, 14),
                ("베이킹러버", "마카롱 꼬끄 드디어 성공했어요! 비결은 머랭 치기에 있었습니다.", 53, 9),
                ("혼밥킹", "자취생 일주일 식단 미리 준비하기 팁 공유합니다.", 38, 7),
            ],
            "photography": [
                ("렌즈마스터", "서울 야경 찍기 좋은 스팟 5곳 정리했습니다.", 72, 16),
                ("필름감성", "필름 카메라 입문자를 위한 추천 카메라와 필름 정리", 45, 11),
                ("스냅촬영", "길고양이 사진 시리즈 올립니다. 동네 고양이들이 너무 귀여워요.", 91, 19),
                ("풍경사진가", "제주도 일출 타임랩스 찍어왔습니다. 새벽 4시 기상은 힘들지만 결과물은 최고!", 56, 8),
            ],
            "fitness": [
                ("헬스초보", "벤치프레스 자세 교정 받고 왔는데 그립 폭이 문제였어요.", 34, 13),
                ("러닝맨", "첫 하프마라톤 완주했습니다! 2시간 15분 기록이에요.", 78, 21),
                ("홈트여왕", "덤벨 하나로 할 수 있는 전신 운동 루틴 공유합니다.", 61, 9),
                ("식단관리", "벌크업 중인데 하루 3000kcal 먹는 식단 공유합니다.", 25, 6),
                ("요가러버", "아침 15분 요가 루틴으로 허리 통증이 많이 좋아졌어요.", 47, 11),
            ],
            "music": [
                ("기타리스트", "어쿠스틱 기타 입문 한 달차 연습곡 추천해주세요.", 29, 15),
                ("플리큐레이터", "비 오는 날 듣기 좋은 재즈 플레이리스트 만들었어요.", 64, 7),
                ("인디밴드팬", "이번 주 홍대 인디 공연 일정 정리했습니다.", 33, 4),
            ],
            "reading": [
                ("다독가", "올해 읽은 책 중 베스트 3 공유합니다.", 41, 18),
                ("SF덕후", "테드 창 단편집 읽으신 분? 토론하고 싶어요.", 36, 22),
                ("자기계발", "습관의 힘 읽고 실천 중인데 정말 효과가 있네요.", 28, 8),
                ("북클럽장", "4월 북클럽 선정 도서 투표합니다! 댓글로 의견 주세요.", 19, 14),
            ],
            "travel": [
                ("세계여행자", "동남아 한 달 배낭여행 경비 정리 (2026년 기준)", 83, 25),
                ("국내여행", "강릉 당일치기 코스 추천합니다. 카페 투어 포함!", 57, 12),
                ("캠핑족", "봄 캠핑 시즌 오픈! 올해 처음 가볼 캠핑장 추천해주세요.", 44, 16),
            ],
            "pets": [
                ("댕댕맘", "우리 강아지 첫 미용 다녀왔어요! 너무 귀여운 비포 애프터", 112, 31),
                ("냥집사", "고양이 자동 급식기 비교 리뷰합니다. 3개 제품 사용 후기.", 68, 14),
                ("햄스터왕", "햄스터 케이지 인테리어 업그레이드 했어요!", 39, 7),
                ("반려인", "반려동물 보험 가입 고민 중인데 경험 있으신 분 조언 부탁드려요.", 45, 19),
                ("산책러", "우리 동네 강아지 산책 모임 만들었는데 참여하실 분!", 52, 9),
            ],
            "art": [
                ("디지털아트", "아이패드 프로크리에이트로 그린 풍경화 시리즈입니다.", 63, 11),
                ("수채화", "수채화 입문 한 달차 작품 올립니다. 피드백 부탁드려요!", 47, 15),
                ("캘리작가", "캘리그래피 연습 중인데 붓펜 추천 부탁드려요.", 22, 8),
            ],
            "tech": [
                ("개발자김", "Swift 6 동시성 모델 정리 글 올립니다.", 76, 18),
                ("AI열정맨", "로컬 LLM 돌리기 위한 맥 세팅 가이드 작성했습니다.", 94, 27),
                ("앱개발러", "SwiftUI로 커뮤니티 앱 만드는 중인데 아키텍처 고민이에요.", 51, 13),
                ("테크리뷰어", "맥북 프로 M5 칩 벤치마크 결과 공유합니다.", 68, 9),
            ],
        ]

        let tagKey = tag.rawValue
        let entries = postsData[tagKey] ?? postsData["tech"] ?? []

        let posts = entries.map { authorName, content, likes, comments in
            let post = Post(
                channelId: channelId,
                authorName: authorName,
                content: content,
                likeCount: likes,
                commentCount: comments,
                createdAt: Date().addingTimeInterval(-Double.random(in: 300...604800)),
                isLiked: Bool.random()
            )
            postIds.append(post.id)
            return post
        }

        return posts
    }

    // MARK: - 댓글 목 데이터

    /// 특정 게시글의 댓글 생성
    /// - Parameter postId: 게시글 UUID
    /// - Returns: 목 댓글 배열
    func loadComments(for postId: UUID) -> [Comment] {
        let commentData: [(String, String, Int)] = [
            ("유저A", "좋은 글이네요! 공감합니다.", 5),
            ("유저B", "저도 비슷한 경험 있어요. 정보 감사합니다!", 3),
            ("유저C", "혹시 더 자세한 내용 공유해주실 수 있나요?", 1),
            ("유저D", "완전 동의합니다. 저도 추천해요!", 7),
            ("유저E", "오 이거 몰랐는데 유용하네요. 북마크합니다.", 2),
        ]

        // 게시글마다 3~5개 댓글 생성
        let commentCount = Int.random(in: 3...5)
        let selectedComments = Array(commentData.shuffled().prefix(commentCount))

        return selectedComments.map { authorName, content, likes in
            Comment(
                postId: postId,
                authorName: authorName,
                content: content,
                likeCount: likes,
                createdAt: Date().addingTimeInterval(-Double.random(in: 60...86400))
            )
        }
    }
}
