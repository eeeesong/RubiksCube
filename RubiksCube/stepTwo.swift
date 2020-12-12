
struct StepTwo {
    
    var startingCube = [
        ["R", "R", "W"],
        ["G", "C", "W"],
        ["G", "B", "B"]
    ]
    
    var actionList = [String]()
    
    
    //MARK: - input의 유효성 체크, 액션 리스트 만들기
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
    
    
    func makeStringArray(for text: String) -> [String] {
        var stringArray = text.map{ $0.uppercased() }
        
        for (i,v) in stringArray.enumerated() {
            if v == "'" && i > 0 {
                stringArray[i-1].append(v)
                stringArray[i] = "delete"
            }
        }
        stringArray = stringArray.filter{ $0 != "delete" }
        return stringArray
    }
    
    
    func makeFilteredAction(for array: [String]) -> [String] {
        var filterArray = [String]()
        let allAction = ["U","R","L","B","Q","U\'","R\'","L\'","B\'"]
        
        filterArray = array.filter {(s: String) -> Bool in
            return allAction.contains(s)
        }
        return filterArray
    }
    
    
    //MARK: - 큐브 액션
    func startAction(with action: String, for cube: [[String]]) -> [[String]] {
        let reverseAction = ["U\'","R\'","L\'","B\'"]
        let isReverse = reverseAction.contains(action) ? true : false

        switch action {
        case "B","B'":
            return actionB(isReverse, cube)
        case "U","U'":
            return actionU(isReverse, cube)
        case "R","R'":
            return actionR(isReverse, cube)
        case "L","L'":
            return actionL(isReverse, cube)

        default:
            return cube
        }
    }
    
    
    func actionB(_ isReverse: Bool,_ cube: [[String]]) -> [[String]] {
        var cube = cube
        let tryCount = isReverse ? 2 : 1
        for _ in 1...tryCount {
            cube[2].insert(cube[2][2], at: 0)
            cube[2].removeLast()
        }
        return cube
    }
    
    func actionU(_ isReverse: Bool,_ cube: [[String]]) -> [[String]] {
        var cube = cube
        let tryCount = isReverse ? 1 : 2
        for _ in 1...tryCount {
            cube[0].insert(cube[0][2], at: 0)
            cube[0].removeLast()
        }
        return cube
    }

    func actionR(_ isReverse: Bool,_ cube: [[String]]) -> [[String]] {
        var cube = cube
        let tryCount = isReverse ? 2 : 1
        for _ in 1...tryCount {
            cube[2].insert(cube[0][2], at: 2)
            cube[1].insert(cube[2][3], at: 2)
            cube[0].insert(cube[1][3], at: 2)
            cube[0].removeLast()
            cube[1].removeLast()
            cube[2].removeLast()
        }
        return cube
    }

    func actionL(_ isReverse: Bool,_ cube: [[String]]) -> [[String]] {
        var cube = cube
        let tryCount = isReverse ? 1 : 2
        for _ in 1...tryCount {
            cube[2].insert(cube[0][0], at: 1)
            cube[1].insert(cube[2][0], at: 1)
            cube[0].insert(cube[1][0], at: 1)
            cube[0].removeFirst()
            cube[1].removeFirst()
            cube[2].removeFirst()
        }
        return cube
    }

    //MARK: - 큐브 -> 문자열
    func cubeToString(_ cube: [[String]]) -> String {
        
        let firstLine = cube[0].reduce(""){ $0 + " " + $1 }
        let secondLine = cube[1].reduce(""){ $0 + " " + $1 }
        let lastLine = cube[2].reduce(""){ $0 + " " + $1 }
        
        return firstLine + "\n" + secondLine + "\n" + lastLine
    }
}
