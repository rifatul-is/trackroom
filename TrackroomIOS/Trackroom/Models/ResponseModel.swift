import Foundation

struct LoginResponse : Codable{
    let refresh: String
    let access: String
}

struct getUserInfoResponse : Codable{
    let pk: Int
    let email: String
    let username: String
    let profile_image: String?
    let bio: String?
}

struct NotificationList : Hashable, Codable{
    let classroom: String
    let message: String
    let date_created: String
}

struct ClassroomList : Hashable, Codable{
    let pk: Int
    let creator: String
    let title: String
    let class_type: String
    let description: String
    let class_category: String
    let ratings: String
    let creator_image: String
}

struct PostList : Hashable, Codable{
    let pk: Int
    let title: String
    let description: String
    let date_created: String
    let post_type: String
}

struct PostDetails : Hashable, Codable{
    let file: String
    let file_type: String
}

struct QuizDetails : Hashable, Codable{
    let pk: Int
    let title: String
    let start_time: String
    let end_time: String
    let description: String
    let date_created: String
}

struct StudentQuizData : Hashable, Codable{
    let pk: Int
    let question: String
    var options: [String] = []
}

struct StudentQuizStatus : Hashable, Codable{
    let has_attended: Bool
    let grade: String
}

struct CreatorQuizStatus : Hashable, Codable{
    let subscriber: String
    let has_attended: Bool
    let grade: String
}

struct PostComments : Hashable, Codable{
    let pk: Int
    let comment: String
    let date_created: String
    let creator: String
    let creator_image: String
}
