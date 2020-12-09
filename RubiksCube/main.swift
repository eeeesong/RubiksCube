
import Foundation

var model = StepTwo()

print(SystemMessage.info)
print(SystemMessage.startingCube)

main()

func main() {
    print("\nCUBE👉🏻", terminator: "")
    
    let input = readLine() ?? ""
    let checkInput = model.actionCheck(for: input)
    
    //잘못된 입력일 경우 다시 시작
    guard checkInput == SystemMessage.noError else {
        print(checkInput + "\n" + SystemMessage.info)
        return main()
    }

    //올바른 입력일 경우 차례로 액션 실행
    let actionList = model.actionList
    changeCube(for: model.startingCube, actionList: actionList)
}

func changeCube(for cube: [[String]], actionList: [String]) {
    var cubeNow = cube
    var delayAmount = 0.0
    let totalDelayAmount = Double(actionList.count)
    
    for action in actionList {
        
        Timer.scheduledTimer(withTimeInterval: delayAmount , repeats: false) { (timer) in

            guard action != "Q" else {
                print("Q가 입력되어 프로그램을 종료합니다. Bye~🙋")
                exit(9)
            }
            let result = model.startAction(for: action, cube: cubeNow)
            let resultToString = model.cubeToString(result)
            cubeNow = result
            print("\n액션 \(action)를 적용한 큐브:\n\(resultToString)")
        }
        delayAmount += 1
    }
    Timer.scheduledTimer(withTimeInterval: totalDelayAmount-1, repeats: false) { (timer) in
        model.startingCube = cubeNow
        main()
    }
}

RunLoop.main.run()
