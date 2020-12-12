
import Foundation

var model = StepTwo()

print(SM.info)
print(SM.startingCube)

main()


func main() {
    print(SM.prompt, terminator: "")
    
    let input = readLine() ?? ""
    let checkInput = model.actionCheck(for: input)
    
    guard checkInput == SM.noError else {
        print(checkInput)
        return main()
    }

    let actionList = model.actionList
    changeCube(for: model.startingCube, with: actionList)
}


func changeCube(for cube: [[String]], with actionList: [String]) {
    var cubeNow = cube
    var delayAmount = 0.0
    let totalDelayAmount = Double(actionList.count-1)
    
    for action in actionList {
        Timer.scheduledTimer(withTimeInterval: delayAmount, repeats: false) { (timer) in
            cubeNow = getNewCube(with: action, cube: cubeNow)
        }
        delayAmount += 1
    }
    Timer.scheduledTimer(withTimeInterval: totalDelayAmount, repeats: false) { (timer) in
        model.startingCube = cubeNow
        main()
    }
}


func getNewCube(with action: String, cube: [[String]]) -> [[String]] {
    guard action != "Q" else {
        print(SM.quit)
        exit(EXIT_SUCCESS)
    }
    let result = model.startAction(with: action, for: cube)
    let resultToString = model.cubeToString(result)
    print(SM.successMessage(action, resultToString))
    return result
}


RunLoop.main.run()
