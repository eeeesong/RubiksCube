
struct SystemMessage {
    
    static let info = """
    ⚡️F/F' – 앞 (Front)
    ⚡️R/R' – 오른쪽 (Right)
    ⚡️U/U' – 위 (Up)
    ⚡️B/B' – 뒤 (Back)
    ⚡️L/L' – 왼쪽 (Left)
    ⚡️D/D' – 아랫쪽 (Down)
    🙋Q - 프로그램 종료
    """
    
    static let cubeNow = "\n현재 큐브:\n"
    static let prompt = "CUBE👉🏻"
    static let quit = "종료 액션 Q가 입력되었습니다. Bye~🙋"
    static let inputError = "값을 입력해주세요\n" + info
    static let actionError = "올바른 값을 입력해주세요\n" + info
    static let noError = "정상 작동"
    
    static func successMessage(_ action: String, _ result: String) -> String {
        return "\n액션 \(action)(을)를 적용한 큐브:\n\(result)"
    }
}
