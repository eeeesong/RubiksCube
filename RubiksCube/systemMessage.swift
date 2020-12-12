
struct SM {
    
    //MARK: - 시작/기본
    static let prompt = "CUBE👉🏻"
    static let cubeNow = "현재 큐브:\n"
    
    static let info = """
    ⚡️F/F' – 앞 (Front)          ⚡️B/B' – 뒤 (Back)
    ⚡️R/R' – 오른쪽 (Right)       ⚡️L/L' – 왼쪽 (Left)
    ⚡️U/U' – 위 (Up)             ⚡️D/D' – 아랫쪽 (Down)
    🙋Q - 프로그램 종료             ❓HELP - 도움말
    🤹🏼SHUFFLE - 큐브 다시 섞기
    ⏰TIME - 출력 사이의 시간 설정\n
    """
    
    static let quit = "Q"
    static let help = "HELP"
    static let shuffle = "SHUFFLE"
    static let timeSet = "TIME"
    
    
    //MARK: - 시간 관련
    static let timeSetprompt = "0 이상의 수를 입력해주세요👉🏻"
    static var timeDelay = 0.1
    static var timeDelayMessage = "딜레이가 \(timeDelay)초로 설정되었습니다!\n"
    
    static var time = "0분 0초"
    static func getTimeMessageFrom(_ minute: Int, _ second: Int) {
        time = "\(minute)분 \(second)초"
    }
    
    
    //MARK: - 진행/종료
    static var actionCount = 0
    static func actionMessage(_ action: String, _ result: String) -> String {
        return "\n액션 \(action)(을)를 적용한 큐브:\n\(result)"
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
    
    //MARK: - 에러 관련
    static let inputError = "\nError😯 값을 입력해주세요\n\n" + info
    static let actionError = "\nError😯 - 올바른 값을 입력해주세요\n\n" + info
    static let noError = "정상 작동"
}
