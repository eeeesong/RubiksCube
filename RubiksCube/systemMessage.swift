
struct SystemMessage {
    
    static let info = """
    ⚡️F/F' – 앞 (Front)
    ⚡️R/R' – 오른쪽 (Right)
    ⚡️U/U' – 위 (Up)
    ⚡️B/B' – 뒤 (Back)
    ⚡️L/L' – 왼쪽 (Left)
    ⚡️D/D' – 아랫쪽 (Down)
    🙋Q - 프로그램 종료\n
    """
    
    static let cubeNow = "현재 큐브:\n"
    static let prompt = "CUBE👉🏻"

    static let inputError = "\nError😯 값을 입력해주세요\n\n" + info
    static let actionError = "\nError😯 - 올바른 값을 입력해주세요\n\n" + info
    static let noError = "정상 작동"
    
    static let quit = "총 \(actionCount)개의 액션을 수행하였습니다. Bye~🙋"
    static var actionCount = 0
    
    static func successMessage(_ action: String, _ result: String) -> String {
        return "\n액션 \(action)(을)를 적용한 큐브:\n\(result)"
    }
    
    static let doneMessage = """
    ✨   축하합니다!  ✨
    ✨   \(actionCount)번 만에 모든 면을 맞추셨어요!  ✨
    ✨   당신은 큐브의 천재인가요?  ✨
    """
}
