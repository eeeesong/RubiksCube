
struct SM {
    
    static let info = """
    ⚡️F/F' – 앞 (Front)          ⚡️B/B' – 뒤 (Back)
    ⚡️R/R' – 오른쪽 (Right)       ⚡️L/L' – 왼쪽 (Left)
    ⚡️U/U' – 위 (Up)             ⚡️D/D' – 아랫쪽 (Down)
    🙋Q - 프로그램 종료             ❓HELP - 도움말
    🤹🏼SHUFFLE - 큐브 다시 섞기
    \n
    """
    
    static let quit = "Q"
    static let help = "HELP"
    static let shuffle = "SHUFFLE"
    
    static let cubeNow = "현재 큐브:\n"
    static let prompt = "CUBE👉🏻"

    static let inputError = "\nError😯 값을 입력해주세요\n\n" + info
    static let actionError = "\nError😯 - 올바른 값을 입력해주세요\n\n" + info
    static let noError = "정상 작동"
    
    static var actionCount = 0
    static var time = "0분 0초"
    
    static func successMessage(_ action: String, _ result: String) -> String {
        return "\n액션 \(action)(을)를 적용한 큐브:\n\(result)"
    }
    
    static func getTimeMessageFrom(_ minute: Int, _ second: Int) {
        time = "\(minute)분 \(second)초"
    }
    
    static let quitMessage = """

    총 \(actionCount)개의 액션을 수행하였습니다.
    경과 시간은 \(time)입니다. Bye~🙋

    """
    
    static let doneMessage = """

    ✨   축하합니다!  ✨
    ✨   \(actionCount)번, \(time)만에 모든 면을 맞추셨어요!  ✨
    ✨   당신은 큐브의 천재인가요?  ✨

    """
}
