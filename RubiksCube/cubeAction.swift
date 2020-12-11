

struct CubeAction {
    
    let defaultAction = ["F","R","U","B","L","D"]
    
    //MARK: - 큐브 섞기
    func getCubeShuffled(_ cube: [[String]]) -> [[String]] {
        var newCube = cube
        let randomNumber = Int.random(in: 50...200)
        
        var actionArray = Array(repeating: "X", count: randomNumber)
        
        for n in 0...randomNumber-1 {
            actionArray[n] = defaultAction.randomElement()!
            newCube = startAction(for: actionArray[n], cube: newCube)
        }
        return newCube
    }
    
    //MARK: - 각 입력에 맞는 액션 수행
    func startAction(for action: String, cube: [[String]]) -> [[String]] {
        let isReverse = defaultAction.contains(action) ? false : true
    
        switch action {
        case "F","F\'":
            return actionF(isReverse, cube)
        case "B","B\'":
            return actionB(isReverse, cube)
        case "D","D\'":
            return actionD(isReverse, cube)
        case "U","U\'":
            return actionU(isReverse, cube)
        case "R","R\'":
            return actionR(isReverse, cube)
        case "L","L\'":
            return actionL(isReverse, cube)
        default:
            return actionQ(cube)
        }
    }
    
    //MARK: - 큐브 액션
    func actionF(_ isReverse: Bool,_ cube: [[String]]) -> [[String]] {
        var cube = cube
        let tryCount = isReverse ? 3 : 1
        
        for _ in 1...tryCount {
            let temp = cube[2]
            
            cube[2] = [cube[11][2],cube[7][2],cube[3][2]]
            
            cube[3][2] = cube[15][0]
            cube[7][2] = cube[15][1]
            cube[11][2] = cube[15][2]
            
            cube[15] = [cube[13][0],cube[9][0],cube[5][0]]
            
            cube[5][0] = temp[0]
            cube[9][0] = temp[1]
            cube[13][0] = temp[2]
            
            cube = rotateInside(cube, startAt: 4)
        }
        return cube
    }
    
    func actionB(_ isReverse: Bool,_ cube: [[String]]) -> [[String]] {
        var cube = cube
        let tryCount = isReverse ? 3 : 1
        
        for _ in 1...tryCount {
            let temp = cube[0]
            
            cube[0] = [cube[5][2],cube[9][2],cube[13][2]]

            cube[5][2] = cube[17][2]
            cube[9][2] = cube[17][1]
            cube[13][2] = cube[17][0]
            
            cube[17] = [cube[3][0],cube[7][0],cube[11][0]]
            
            cube[3][0] = temp[2]
            cube[7][0] = temp[1]
            cube[11][0] = temp[0]
            
            cube = rotateInside(cube, startAt: 6)
        }
        return cube
    }
    
    func actionR(_ isReverse: Bool,_ cube: [[String]]) -> [[String]] {
        var cube = cube
        let tryCount = isReverse ? 3 : 1
        
        for _ in 1...tryCount {
            let temp = [cube[0][2],cube[1][2],cube[2][2]]
            
            cube[0][2] = cube[4][2]
            cube[1][2] = cube[8][2]
            cube[2][2] = cube[12][2]
            
            cube[4][2] = cube[15][2]
            cube[8][2] = cube[16][2]
            cube[12][2] = cube[17][2]
            
            cube[15][2] = cube[14][0]
            cube[16][2] = cube[10][0]
            cube[17][2] = cube[6][0]
            
            cube[14][0] = temp[0]
            cube[10][0] = temp[1]
            cube[6][0] = temp[2]
            
            cube = rotateInside(cube, startAt: 5)
        }
        return cube
    }
    
    func actionL(_ isReverse: Bool,_ cube: [[String]]) -> [[String]] {
        var cube = cube
        let tryCount = isReverse ? 3 : 1
        
        for _ in 1...tryCount {
            let temp = [cube[0][0],cube[1][0],cube[2][0]]
            
            cube[0][0] = cube[14][2]
            cube[1][0] = cube[10][2]
            cube[2][0] = cube[6][2]
            
            cube[14][2] = cube[15][0]
            cube[10][2] = cube[16][0]
            cube[6][2] = cube[17][0]
            
            cube[15][0] = cube[4][0]
            cube[16][0] = cube[8][0]
            cube[17][0] = cube[12][0]
            
            cube[4][0] = temp[0]
            cube[8][0] = temp[1]
            cube[12][0] = temp[2]
            
            cube = rotateInside(cube, startAt: 3)
        }
        return cube
    }
    
    func actionU(_ isReverse: Bool,_ cube: [[String]]) -> [[String]] {
        var cube = cube
        let tryCount = isReverse ? 3 : 1

        for _ in 1...tryCount {
            let temp = cube[3]
            cube[3] = cube[4]
            cube[4] = cube[5]
            cube[5] = cube[6]
            cube[6] = temp
            cube = rotateInsideForUD(cube, startAt: 0)
        }
        return cube
    }
    
    func actionD(_ isReverse: Bool,_ cube: [[String]]) -> [[String]] {
        var cube = cube
        let tryCount = isReverse ? 3 : 1

        for _ in 1...tryCount {
            let temp = cube[11]
            cube[11] = cube[14]
            cube[14] = cube[13]
            cube[13] = cube[12]
            cube[12] = temp
            cube = rotateInsideForUD(cube, startAt: 15)
        }
        return cube
    }
    
    func actionQ(_ cube: [[String]]) -> [[String]] {
        return cube
    }
    
    //MARK: - 큐브 면 내부 회전
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
}
