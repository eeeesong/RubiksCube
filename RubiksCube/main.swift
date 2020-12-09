
import Foundation

var model = StepTwo()

print(SystemMessage.info)
print(SystemMessage.startingCube)
print("\nCUBE👉🏻", terminator: "")

let input = readLine() ?? ""
let checkInput = model.actionCheck(for: input)

//잘못된 입력일 경우 프로그램 종료
guard checkInput == SystemMessage.noError else {
    print(checkInput)
    exit(0)
}

//올바른 입력일 경우 차례로 액션 실행
var actionList = model.actionList
var cubeNow = model.startingCube
var delayAmount = 0.0

for action in actionList {
    Timer.scheduledTimer(withTimeInterval: 1.0 * delayAmount , repeats: false) { (timer) in
        let result = model.startAction(for: action, cube: cubeNow)
        let resultToString = model.cubeToString(result)
        cubeNow = result
        print("\n액션 \(action)를 적용한 큐브:\n\(resultToString)")
        actionList.removeFirst()
    }
    delayAmount += 1
}

RunLoop.main.run(until: Date(timeIntervalSinceNow: delayAmount))
