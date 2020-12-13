# RubiksCube
## 3단계

> 📍 기본 구성
>
> 1. main: 입/출력 제어, 경과 시간을 관리하며 프로그램을 컨트롤합니다
> 2. stepThree: StepThree 구조체는 유저의 입력 내용을 검토하고, 큐브를 출력용으로 변환하는 메소드를 담고 있습니다. 또한 정답 큐브와 현재 큐브, 입력 받은 액션의 리스트를 배열로 저장합니다
> 3. cubeAction: CubeAction 구조체는 큐브를 섞거나 일부 변형하는 모든 액션 메소드를 담고 있습니다
> 4. systemMessage: SM 구조체는 모든 출력 문자열을 관리합니다



### 0. 프로그램 시작

프로그램이 시작되면 `StepThree`와 `CubeAction`의 인스턴스를 생성하고 현재 시간을 `startTime`에 저장합니다.<br>이때 저장한 시간은 종료 시 경과 시간을 출력하는 데에 쓰이게 됩니다.<br>

info를 출력하는 `printInfo`를 실행하고, `shuffleCube`를 통해 섞인 큐브를 출력합니다. (큐브 섞기에 관해서는 5에서 설명)<br>

```swift
//✏️main.swift
var model = StepThree()
var cubeAction = CubeAction()

let startTime = Int(Date().timeIntervalSince1970)

printInfo()
shuffleCube()

main()
.
.
.
RunLoop.main.run()

//✏️systemMessage.swift
    static let info = """
    ⚡️F/F' – 앞 (Front)          ⚡️B/B' – 뒤 (Back)
    ⚡️R/R' – 오른쪽 (Right)       ⚡️L/L' – 왼쪽 (Left)
    ⚡️U/U' – 위 (Up)             ⚡️D/D' – 아랫쪽 (Down)
    🙋Q - 프로그램 종료             ❓HELP - 도움말
    🤹🏼SHUFFLE - 큐브 다시 섞기
    ⏰TIME - 출력 사이의 시간 설정\n
    """
```

<br>

### 1. 명령 컨트롤

`main()`은 유저의 입력을 받은 뒤, 케이스에 따라 다른 함수를 호출하는 역할을 하도록 설계되었습니다. <br>문자열 점검을 용이하게 하기 위해 먼저 `input`에 `uppercased()`를 적용하고, 케이스 체크를 합니다.<br>이때 `help`, `shuffle`, `time` 등 세팅에 관한 입력이 들어왔을 경우 바로 해당 함수를 실행하고, 이외의 default 케이스에서는 입력 내용을 검토한 뒤 큐브 액션을 수행할 수 있도록 합니다. (유저 커스텀 세팅에 대해서는 5에서 설명)

```swift
//✏️main.swift
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
```

<br>

### 2. 입력 내용 체크

입력 내용을 확인하고 액션 리스트로 만드는 과정은 step-2와 같습니다. 에러를 검토하고 에러가 없을 시 다음으로 넘어가게 됩니다.

```swift
//✏️main.swift
func getAction(from input: String){
    let checkInput = model.actionCheck(for: input)
    
    guard checkInput == SM.noError else {
        print(checkInput)
        return main()
    }
    let actionList = model.actionList
    changeCube(for: model.startingCube, with: actionList)
}

//✏️stepThree.swift
    mutating func actionCheck(for input: String) -> String {
        
        guard input != "" else { return SM.inputError }
        
        let stringArray = makeStringArray(for: input)
        let filterArray = makeFilteredAction(for: stringArray)
        
        if filterArray == stringArray {
            actionList = filterArray
            return SM.noError
        } else {
            return SM.actionError
        }
    }
```

<br>

다만, **2분의 1회전** 액션(R2 등)이 추가되었기 때문에 해당 내용을 반영했습니다.

```swift
//✏️stepThree.swift
    func makeStringArray(for text: String) -> [String] {
        var stringArray = text.map{ String($0) }
        
        for (i,v) in stringArray.enumerated() {
            if v == "'" || v == "2", i > 0 { //바뀐 부분
                stringArray[i-1].append(v)
                stringArray[i] = "delete"
            }
        }
        stringArray = stringArray.filter{ $0 != "delete" }
        return stringArray
    }
    
    func makeFilteredAction(for array: [String]) -> [String] {
        var filterArray = [String]()
        let allAction = ["F","F\'","F2", //바뀐 부분
                         "R","R\'","R2",
                         "U","U\'","U2",
                         "B","B\'","B2",
                         "L","L\'","L2",
                         "D","D\'","D2",
                         "Q"]
        
        filterArray = array.filter {(s: String) -> Bool in
            return allAction.contains(s)
        }
        return filterArray
    }
```



### 3. 액션 수행

액션 리스트의 액션이 순차적으로 실행되는 과정도 step-2와 같습니다.<br>

다만, step-3에서는 **출력 딜레이**를 유저가 직접 설정할 수 있게 하여 액션이 실행될 때마다 고정 값 1초가 아닌 `userTimeDelay`만큼의 딜레이가 발생합니다. (타임 딜레이 설정에 대해서는 5에서 설명)

```swift
//✏️stepThree.swift
func changeCube(for cube: [[String]], with actionList: [String]) {
    var cubeNow = cube
    var delayAmount = 0.0
    let userTimeDelay = SM.timeDelay //바뀐 부분
    let totalDelayAmount = Double(actionList.count-1) * userTimeDelay //바뀐 부분
    
    for action in actionList {
        Timer.scheduledTimer(withTimeInterval: delayAmount , repeats: false) { (timer) in
            cubeNow = getNewCube(with: action, cube: cubeNow)
        }
        delayAmount += userTimeDelay //바뀐 부분
    }
    Timer.scheduledTimer(withTimeInterval: totalDelayAmount, repeats: false) { (timer) in
        model.startingCube = cubeNow
        main()
    }
}
```

<br>

또한, 큐브가 몇 번 변경되었는지 체크하는 `actionCount` 역시 추가되어 큐브가 바뀌어 출력되기 직전 `actionCount`가 올라가도록 구현하였으며<br>종료 시 수행되어야 하는 동작이 많아져 `checkQuit`을 개별 함수로 구현하였고<br>큐브를 모두 맞췄을 시 자동 종료되는 `checkAnswer` 함수 역시 추가로 구현하였습니다.

```swift
//✏️stepThree.swift
func getNewCube(with action: String, cube: [[String]]) -> [[String]] {
    
    checkQuit(for: action) //바뀐 부분
    
    let result = cubeAction.startAction(action, cube)
    let resultToString = model.cubeToString(result)
    SM.actionCount += 1 //바뀐 부분
    print(SM.actionMessage(action, resultToString))
    
    checkAnswer(for: result) //바뀐 부분
    return result
}
```

<br>

### 3-1. 큐브 액션 분류

step-3의 액션은 크게 default, reverse, double로 분류되며, 정방향의 실행을 기준으로 두었을 때 각각 실행 회수가 다릅니다.<br>default의 경우 1번, double은 2번이며 reverse는 3번입니다. 액션 수행 시 총 4면이 회전하며, 4번 회전 시 원위치이기 때문에 정방향으로 3번 실행 시 역방향 1번과 같아집니다.<br>따라서, 각 액션의 분류를 파악한 뒤 `tryCount`를 계산하여 각 큐브 액션의 전달인자로 넘기는 것으로 구현하였습니다.

```swift
//✏️cubeAction.swift
    let defaultAction = ["F","R","U","B","L","D"]
    let reverseAction = ["F\'","R\'","U\'","B\'","L\'","D\'"]
    let doubleAction = ["F2","R2","U2","B2","L2","D2"]

    func startAction(_ action: String,_ cube: [[String]]) -> [[String]] {
        let reverseCount = reverseAction.contains(action) ? 3 : 1
        let doubleCount = doubleAction.contains(action) ? 2 : 1
        let tryCount = reverseCount * doubleCount
    
        switch action {
        case "F","F\'","F2":
            return actionF(tryCount, cube)
        case "B","B\'","B2":
            return actionB(tryCount, cube)
        case "D","D\'","D2":
            return actionD(tryCount, cube)
        case "U","U\'","U2":
            return actionU(tryCount, cube)
        case "R","R\'","R2":
            return actionR(tryCount, cube)
        case "L","L\'","L2":
            return actionL(tryCount, cube)
        default:
            return cube
        }
    }
```

<br>

### 3-2. 큐브 액션 

step-3의 큐브 역시 **2차원 배열**로 구성하였습니다. `StepThree` 구조체에 모든 면이 맞춰진 정답 큐브가 저장되어 있습니다.

```swift
//✏️stepThree.swift
    let cubeSolved = [
                                ["B", "B", "B"],
                                ["B", "B", "B"],
                                ["B", "B", "B"],
        
        ["W", "W", "W"], ["O", "O", "O"], ["G", "G", "G"], ["Y", "Y", "Y"],
        ["W", "W", "W"], ["O", "O", "O"], ["G", "G", "G"], ["Y", "Y", "Y"],
        ["W", "W", "W"], ["O", "O", "O"], ["G", "G", "G"], ["Y", "Y", "Y"],
        
                                ["R", "R", "R"],
                                ["R", "R", "R"],
                                ["R", "R", "R"]
    ]
```

<br>

각 큐브 액션은 다음과 같은 두 파트로 나뉩니다.

> 1️⃣ - 4면 회전
>
> 2️⃣ - 바닥 회전

**4면**은 큐브가 회전하는 방향에 있어 변화를 직접 겪는 옆면들을 가리키며, **바닥**은 회전하는 큐브 셀들에 공통으로 인접하고 있는 바닥 면을 말합니다. <br>

두 회전 모두 변경을 시작하는 큐브의 셀 한세트(3개)를 임시 값으로 저장해놓고 <br>밀어내기 방식으로 차례로 변경한 뒤 마지막 큐브 세트에 임시 값을 대입하는 방식으로 구현하였습니다.<br>

다만 1️⃣의 경우 액션 마다 가리켜야 하는 큐브 셀의 변동이 커서 반복 구현이 어려웠으나, 2️⃣는 규칙을 띄어 별개의 메소드로 구현하였습니다.

```swift
//✏️cubeAction.swift
    func actionF(_ tryCount: Int, _ cube: [[String]]) -> [[String]] {
        var cube = cube
        
        for _ in 1...tryCount {
          	
            //1️⃣
            let temp = cube[2]
            
            cube[2] = [cube[11][2],cube[7][2],cube[3][2]]
            
            cube[3][2] = cube[15][0]
            cube[7][2] = cube[15][1]
            cube[11][2] = cube[15][2]
            
            cube[15] = [cube[13][0],cube[9][0],cube[5][0]]
            
            cube[5][0] = temp[0]
            cube[9][0] = temp[1]
            cube[13][0] = temp[2]
            
            //2️⃣
            cube = rotateInside(cube, startAt: 4)
        }
        return cube
    }
```

<br>

```swift
                  [cube[0 ]]
                  [cube[1 ]]   1번
                  [cube[2 ]]     
[cube[3 ]]  [cube[4 ]]  [cube[5 ]]  [cube[6 ]]
[cube[7 ]]  [cube[8 ]]  [cube[9 ]]  [cube[10]]   2~5번
[cube[11]]  [cube[12]]  [cube[13]]  [cube[14]]
                  [cube[15]]
                  [cube[16]]   6번
                  [cube[17]]
```

위와 같이 십자 모양으로 펼친 큐브의 전개도를 기준으로 보았을 때, 아래의 메소드는 2-5번 면에 적용될 수 있습니다.<br>만약 2번 면을 변경하려 한다면 `startAt`으로 3을, 5번 면이라면 6을 전달합니다.<br>한 면을 이루는 배열의 인덱스가 4씩 차이나므로 `startAt`을 기준으로 +4 혹은 +8 하는 것으로 각기 다른 셀을 지칭했습니다.<br>각각 2-5번 면의 변경이 필요한 액션 L, F, R, B에서 이 메소드를 호출하도록 했습니다.

```swift
//✏️cubeAction.swift
    func rotateInside(_ cube: [[String]], startAt: Int) -> [[String]] {
        var cube = cube
        let s = startAt
        let temp = cube[s]
        
        cube[s] = [cube[s+8][0],cube[s+4][0],cube[s][0]]
        
        cube[s][0] = cube[s+8][0]
        cube[s+4][0] = cube[s+8][1]
        cube[s+8][0] = cube[s+8][2]
        
        cube[s+8] = [cube[s+8][2],cube[s+4][2],cube[s][2]]
        
        cube[s+8][2] = temp[2]
        cube[s+4][2] = temp[1]
        cube[s][2] = temp[0]
        
        return cube
    }
```

<br>

1번 면을 변경하는 U, 6번 면을 변경하는 D는 아래의 메소드를 호출하도록 했습니다.<br>1번과 6번의 경우 각 배열의 인덱스의 차이가 1이므로 +1, +2로 작성하였습니다.<br>

```swift
//✏️cubeAction.swift    
    func rotateInsideForUD(_ cube: [[String]], startAt: Int) -> [[String]] {
        var cube = cube
        let s = startAt
        let temp = cube[s]
        
        cube[s] = [cube[s+2][0],cube[s+1][0],cube[s][0]]
        
        cube[s][0] = cube[s+2][0]
        cube[s+1][0] = cube[s+2][1]
        cube[s+2][0] = cube[s+2][2]
        
        cube[s+2] = [cube[s+2][2],cube[s+1][2],cube[s][2]]
        
        cube[s+2][2] = temp[2]
        cube[s+1][2] = temp[1]
        cube[s][2] = temp[0]
        
        return cube
    }
```

단, 2️⃣의 바닥 회전은 어떤 액션이든 default라면 모두 시계 방향으로 진행됩니다. <br>그렇기 때문에 1️⃣의 4면 회전 역시 회전 방향과 무관하게 default의 경우 모두 1회, reverse는 3회를 회전하는 것으로 변경하였습니다.<br>

(step-2에서는 방향이 반대되는 액션(R <-> L 등)에 대해 초기 구현은 모두 정방향으로 하되, 실제 정/역방향 여부에 따라 카운트를 반대로 주는 방식으로 구현하였음)
<br>


### 3-3. 큐브 -> 문자열 변환

아래와 같이 각 파트 별로 공백이 다른 큐브의 출력을 위해 큐브를 문자열로 변환하는 과정을 2단계로 나눴습니다.<br>

```swift
                  [cube[0 ]]
                  [cube[1 ]]   1번
                  [cube[2 ]]     
[cube[3 ]]  [cube[4 ]]  [cube[5 ]]  [cube[6 ]]
[cube[7 ]]  [cube[8 ]]  [cube[9 ]]  [cube[10]]   2~5번
[cube[11]]  [cube[12]]  [cube[13]]  [cube[14]]
                  [cube[15]]
                  [cube[16]]   6번
                  [cube[17]]
```

<br>

먼저, 큐브 전개도를 기준으로 2-5번 큐브에 해당되는 배열을, 가로줄을 기준으로 각각 하나의 배열로 펴 3개의 line으로 묶습니다.<br>이 과정에서 각 배열 사이사이에 적당한 공간을 준 후 반환합니다.

```swift
//✏️stepThree.swift     
    func flatMultiLine(_ cube: [[String]], startFrom arrayNum: Int) -> [String] {
    
        var cubeToChange = cube
        var result = [String]()
        let space = "\t  "
        
        for a in arrayNum...arrayNum+3 {
            cubeToChange[a].append(space)
            result.append(contentsOf: cubeToChange[a])
        }
        return result
    }
```

<br>

그 후 각 큐브 셀 간 간격을 더한 문자열로 각각 추출한 뒤<br>1번, 6번 면에 대해서는 왼쪽 여백을 주고, 모든 라인에 줄간격을 더하여 문자열로 반환하도록 구현했습니다.

```swift
//✏️stepThree.swift      
func cubeToString(_ cube: [[String]]) -> String {

        let firstLineA = cube[0].reduce(""){ $0 + " " + $1 }
        let firstLineB = cube[1].reduce(""){ $0 + " " + $1 }
        let firstLineC = cube[2].reduce(""){ $0 + " " + $1 }
        let secondLineA = flatMultiLine(cube, startFrom: 3).reduce(""){ $0 + " " + $1 }
        let secondLineB = flatMultiLine(cube, startFrom: 7).reduce(""){ $0 + " " + $1 }
        let secondLineC = flatMultiLine(cube, startFrom: 11).reduce(""){ $0 + " " + $1 }
        let lastLineA = cube[15].reduce(""){ $0 + " " + $1 }
        let lastLineB = cube[16].reduce(""){ $0 + " " + $1 }
        let lastLineC = cube[17].reduce(""){ $0 + " " + $1 }
        
        let space = "\t\t\t\t"
        
        return """
            \(space)\(firstLineA)\n\(space)\(firstLineB)\n\(space)\(firstLineC)\n
            \(secondLineA)\n\(secondLineB)\n\(secondLineC)\n
            \(space)\(lastLineA)\n\(space)\(lastLineB)\n\(space)\(lastLineC)
            """
    }
```

<br>

### 3-4. 결과 출력

step-2와 마찬가지로, 정상적으로 액션이 수행됐을 경우 직전 수행한 액션과 함께 문자열로 전환된 큐브가 출력됩니다.

```swift
//✏️main.swift  
func getNewCube(with action: String, cube: [[String]]) -> [[String]] {
    
    checkQuit(for: action)
    
    let result = cubeAction.startAction(action, cube)
    let resultToString = model.cubeToString(result)
    SM.actionCount += 1
    print(SM.actionMessage(action, resultToString))
    
    checkAnswer(for: result)
    return result
}

//✏️systemMessage.swift  
    static func actionMessage(_ action: String, _ result: String) -> String {
        return "\n액션 \(action)(을)를 적용한 큐브:\n\(result)"
    }
```

<br>

### 4. 프로그램 종료

개별 큐브 액션 수행 시 종료 상황이 체크(바로 위의 `getNewCube` 참조)됩니다.<br>프로그램 종료 상황은 2가지이며, 두 경우 모두 경과 시간 출력을 포함합니다.<br>

종료 액션(Q)으로 프로그램이 종료되는 경우, 액션이 수행되기 직전 체크 후 종료 상황이 맞다면 `quitMessage`를 출력하며 프로그램이 종료되도록 했습니다.

```swift
//✏️main.swift
func checkQuit(for action: String) {
    if action == SM.quit {
        calcTime(from: startTime)
        print(SM.quitMessage)
        exit(EXIT_SUCCESS)
    }
}

//✏️systemMessage.swift
    static let quitMessage = """

    총 \(actionCount)개의 액션을 수행하였습니다.
    경과 시간은 \(time)입니다. Bye~🙋

    """
```

<br>

큐브를 모두 풀어 프로그램이 종료되는 경우, 액션 수행 직후 함수를 실행하여 현재 큐브와 `cubeSolved`가 같을 때 `doneMessage`를 출력하며 프로그램이 종료되도록 구현했습니다.

```swift
//✏️main.swift
func checkAnswer(for cube: [[String]]) {
    if cube == model.cubeSolved {
        calcTime(from: startTime)
        print(SM.doneMessage)
        exit(EXIT_SUCCESS)
    }
}

//✏️systemMessage.swift
    static let doneMessage = """

    ✨   축하합니다!  ✨
    ✨   \(actionCount)번, \(time)만에 모든 면을 맞추셨어요!  ✨
    ✨   당신은 큐브의 천재인가요?  ✨

    """
```

<br>

각 종료 상황에서 `calcTime`이 호출되면, 현재 시간을 상수로 저장하고 프로그램 시작 시 저장한 `startTime`과의 차를 구하여 경과 초를 계산하고<br>60으로 나눈 값과 나머지를 각각 `minute`과 `second`에 대입한 뒤 문자열로 변경하는 방식으로 경과 시간을 구현했습니다.

```swift
//✏️main.swift
func calcTime(from startTime: Int) {
    let endTime = Int(Date().timeIntervalSince1970)
    
    let timeInSecond = endTime - startTime
    let minute = timeInSecond / 60
    let second = timeInSecond % 60
    
    SM.getTimeMessageFrom(minute, second)
}

//✏️systemMessage.swift
    static func getTimeMessageFrom(_ minute: Int, _ second: Int) {
        time = "\(minute)분 \(second)초"
    }
```

<br>

### 5. 유저 커스텀 세팅

### 5-1. 큐브 섞기 (shuffle)

프로그램 실행 시 셔플된 큐브가 출력되며, "shuffle" 명령어를 통해 큐브를 다시 섞을 수 있도록 구현하였습니다.<br>두 경우 모두 기반이 되는 큐브는 모든 면이 풀려 있는 `cubeSolved`입니다.<br>

```swift
//✏️main.swift
func shuffleCube() {
    let shuffledCube = cubeAction.getCubeShuffled(model.cubeSolved)
    print(SM.cubeNow + model.cubeToString(shuffledCube))
    model.startingCube = shuffledCube
}
```

<br>

배열 안의 글자를 무작위로 섞는 셔플의 경우 루빅스큐브에서 나올 수 없는 큐브가 생성되는 오류가 있으므로, 기존의 액션을 랜덤 회수만큼 수행하여 섞인 큐브를 반환하도록 구현하였습니다.<br>큐브 섞기를 실행하면 50에서 200번 사이의 회수만큼 `defaultAction` 중 하나가 랜덤으로 실행됩니다.<br>

```swift
//✏️cubeAction.swift  
    let defaultAction = ["F","R","U","B","L","D"]

    func getCubeShuffled(_ cube: [[String]]) -> [[String]] {
        var newCube = cube
        let randomNumber = Int.random(in: 50...200)
        
        for _ in 0...randomNumber-1 {
            let action = defaultAction.randomElement()!
            newCube = startAction(action, newCube)
        }
        return newCube
    }
```

<br>

### 5-2. 딜레이 설정

step-3의 기본 딜레이는 0.1초인데, 유저마다 원하는 딜레이 시간의 차이가 있을 수 있으므로 커스텀 설정이 가능하도록 구현했습니다.<br>

"time" 명령어 입력 시 `delayTimeSet` 호출이 가능하도록 구현했으며, 입력 값이 Double이며 음수가 아닐 때 설정이 가능하도록 했습니다.<br>

```swift
//✏️main.swift  
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
```

