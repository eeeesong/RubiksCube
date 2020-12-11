
import Foundation

var model = StepThree()
var cubeAction = CubeAction()

print(SystemMessage.info)
print(SystemMessage.cubeNow + model.cubeToString(model.cubeShuffled()))

main()


func main() {
    print(SystemMessage.prompt, terminator: "")
    
    let input = readLine() ?? ""
    let checkInput = model.actionCheck(for: input)
    
    guard checkInput == SystemMessage.noError else {
        print(checkInput)
        return main()
    }

    let actionList = model.actionList
    changeCube(for: model.startingCube, actionList: actionList)
}


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
    guard action != "Q" else {
        print(SystemMessage.quit)
        exit(EXIT_SUCCESS)
    }
    
    let result = cubeAction.startAction(for: action, cube: cube)
    let resultToString = model.cubeToString(result)
    SystemMessage.actionCount += 1
    print(SystemMessage.successMessage(action, resultToString))
    
    checkAnswer(for: result)
    return result
}

func checkAnswer(for cube: [[String]]) {
    if cube == model.startingCube {
        print(SystemMessage.doneMessage)
        exit(EXIT_SUCCESS)
    }
}

RunLoop.main.run()

