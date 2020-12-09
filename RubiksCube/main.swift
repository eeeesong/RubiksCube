
import Foundation

var model = StepTwo()

print(SystemMessage.info)
print(SystemMessage.startingCube)

let input = readLine() ?? ""
let checkInput = model.actionCheck(for: input)

//잘못된 입력일 경우 프로그램 종료
guard checkInput == SystemMessage.noError else {
    print(checkInput)
    exit(0)
}

//올바른 입력일 경우 차례로 액션 실행
let actionList = model.actionList
var cubeNow = model.startingCube

for action in actionList {
    let result = model.startAction(for: action, cube: cubeNow)
    cubeNow = result
    let resultToString = model.cubeToString(result)
    print("액션 \(action)를 적용한 큐브:\n\(resultToString)\n")
}
