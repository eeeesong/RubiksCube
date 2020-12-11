
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
    default:
        let checkInput = model.actionCheck(for: inputUppercased)
        
        guard checkInput == SM.noError else {
            print(checkInput)
            return main()
        }
        let actionList = model.actionList
        changeCube(for: model.startingCube, actionList: actionList)
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


//MARK: - 큐브 액션 수행 관련
func changeCube(for cube: [[String]], actionList: [String]) {
    var cubeNow = cube
    var delayAmount = 0.0
    let totalDelayAmount = Double(actionList.count)
    
    for action in actionList {
        Timer.scheduledTimer(withTimeInterval: delayAmount , repeats: false) { (timer) in
            cubeNow = getNewCube(with: action, cube: cubeNow)
        }
        delayAmount += 1
    }
    Timer.scheduledTimer(withTimeInterval: totalDelayAmount-1, repeats: false) { (timer) in
        model.startingCube = cubeNow
        main()
    }
}


func getNewCube(with action: String, cube: [[String]]) -> [[String]] {
    guard !checkQuit(for: action) else {
        exit(EXIT_SUCCESS)
    }
    
    let result = cubeAction.startAction(for: action, cube: cube)
    let resultToString = model.cubeToString(result)
    SM.actionCount += 1
    print(SM.successMessage(action, resultToString))
    
    checkAnswer(for: result)
    return result
}


//MARK: - 프로그램 종료 관련
func checkQuit(for action: String) -> Bool {
    if action == SM.quit {
        calcTime(from: startTime)
        print(SM.quitMessage)
        return true
    } else {
        return false
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

