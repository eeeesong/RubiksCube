
struct SystemMessage {
    
    static let info = """
    📍변경할 문자(word)
    📍움직일 정도(moveBy) * -100 이상 100 미만의 정수
    📍방향(direction) * 오른쪽: R / 왼쪽: L
    을 공백 포함하여 차례로 입력해주세요.
    """
    
    static let inputError = "값을 모두 입력해주세요"
    static let actionError = "올바른 값을 입력해주세요"
    
    static func successMessage(_ word: String, _ moveBy: String, _ direction: String,
                               _ result: String) -> String {
        return "👉🏻 \(word)가 \(moveBy)만큼 \(direction) 방향으로 움직입니다.\n결과: \(result)"
    }
    
}
