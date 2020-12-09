
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
    
    static let prompt = "\nCUBE👉🏻"
    static let quit = "종료 액션 Q가 입력되었습니다. Bye~🙋"
    static let inputError = "값을 입력해주세요\n" + info
    static let actionError = "올바른 값을 입력해주세요\n" + info
    static let noError = "정상 작동"
    
    static func successMessage(_ action: String, _ result: String) -> String {
        return "\n액션 \(action)(을)를 적용한 큐브:\n\(result)"
    }
}
