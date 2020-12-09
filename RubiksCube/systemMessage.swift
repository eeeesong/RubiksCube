
struct SystemMessage {
    
    static let info = """
    ⚡️R/R': 가장 오른쪽 줄 이동
    ⚡️L/L': 가장 왼쪽 줄 이동
    ⚡️U/U': 가장 윗줄 이동
    ⚡️B/B': 가장 아랫 줄 이동
    ⚡️Q: 프로그램 종료
    """
    
    static let startingCube = """
    \n현재 큐브:
      R  R  W
      G  C  W
      G  B  B
    """
    
    static let inputError = "값을 입력해주세요"
    static let actionError = "올바른 값을 입력해주세요"
    static let noError = "정상 작동"
    
//    static func successMessage(_ word: String, _ moveBy: String, _ direction: String,
//                               _ result: String) -> String {
//        return "👉🏻 \(word)가 \(moveBy)만큼 \(direction) 방향으로 움직입니다.\n결과: \(result)"
//    }
    
}
