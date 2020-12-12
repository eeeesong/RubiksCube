
import Foundation

var model = StepThree()
var cubeAction = CubeAction()

let startTime = Int(Date().timeIntervalSince1970)

printInfo()
shuffleCube()

main()


//MARK: - 명령 입력 관련
func main() {
    print(SM.prompt, terminator: "")
    
    let input = readLine() ?? ""
    let inputUppercased = input.uppercased()
    
    switch inputUppercased {
    case SM.help:
        printInfo()
        main()
    case SM.shuffle:
        shuffleCube()
        main()
    case SM.timeSet:
        delayTimeSet()
    default:
        getAction(from: inputUppercased)
    }
}

func shuffleCube() {
    let shuffledCube = cubeAction.getCubeShuffled(model.cubeSolved)
    print(SM.cubeNow + model.cubeToString(shuffledCube))
    model.startingCube = shuffledCube
}

func printInfo() {
    print(SM.info)
}

func delayTimeSet() {
    print(SM.timeSetprompt, terminator: "")
    
    let input = readLine() ?? ""
    
    guard Double(input) != nil,
          Double(input)! >= 0 else {
        return delayTimeSet()
    }
    
    SM.timeDelay = Double(input)!
    print(SM.timeDelayMessage)
    main()
}

func getAction(from input: String){
    let checkInput = model.actionCheck(for: input)
    
    guard checkInput == SM.noError else {
        print(checkInput)
        return main()
    }
    let actionList = model.actionList
    changeCube(for: model.startingCube, with: actionList)
}



//MARK: - 큐브 액션 수행 관련
func changeCube(for cube: [[String]], with actionList: [String]) {
    var cubeNow = cube
    var delayAmount = 0.0
    let userTimeDelay = SM.timeDelay
    let totalDelayAmount = Double(actionList.count-1) * userTimeDelay
    
    for action in actionList {
        Timer.scheduledTimer(withTimeInterval: delayAmount , repeats: false) { (timer) in
            cubeNow = getNewCube(with: action, cube: cubeNow)
        }
        delayAmount += userTimeDelay
    }
    Timer.scheduledTimer(withTimeInterval: totalDelayAmount, repeats: false) { (timer) in
        model.startingCube = cubeNow
        main()
    }
}


func getNewCube(with action: String, cube: [[String]]) -> [[String]] {
    
    checkQuit(for: action)
    
    let result = cubeAction.startAction(action, cube)
    let resultToString = model.cubeToString(result)
    SM.actionCount += 1
    print(SM.actionMessage(action, resultToString))
    
    checkAnswer(for: result)
    return result
}



//MARK: - 프로그램 종료 관련
func checkQuit(for action: String) {
    if action == SM.quit {
        calcTime(from: startTime)
        print(SM.quitMessage)
        exit(EXIT_SUCCESS)
    }
}

func checkAnswer(for cube: [[String]]) {
    if cube == model.cubeSolved {
        calcTime(from: startTime)
        print(SM.doneMessage)
        exit(EXIT_SUCCESS)
    }
}

func calcTime(from startTime: Int) {
    let endTime = Int(Date().timeIntervalSince1970)
    
    let timeInSecond = endTime - startTime
    let minute = timeInSecond / 60
    let second = timeInSecond % 60
    
    SM.getTimeMessageFrom(minute, second)
}

RunLoop.main.run()
