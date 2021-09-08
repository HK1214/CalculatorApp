import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var calculatorCollectionView: UICollectionView!
    @IBOutlet weak var calculatorHeightConstraint: NSLayoutConstraint!
    let cellId = "cellId"
    let numbers = [
        ["C", "", "", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    var firstNumber = ""
    var secondNumber = ""
    var calculateStatus: CalculateStatus = .none
    
    enum CalculateStatus {
        case none
        case plus
        case minus
        case multiplication
        case division
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        calculatorCollectionView.delegate = self
        calculatorCollectionView.dataSource = self
        calculatorCollectionView.register(CalculatorViewCell.self, forCellWithReuseIdentifier: cellId)
        calculatorCollectionView.backgroundColor = .clear
        calculatorCollectionView.contentInset = .init(top: 0, left: 14, bottom: 0, right: 14)
        calculatorHeightConstraint.constant = view.frame.width * 1.4
        numberLabel.text = "0"
    }
    
    func clear() {
        firstNumber = ""
        secondNumber = ""
        numberLabel.text = "0"
        calculateStatus = .none
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calculatorCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CalculatorViewCell
        cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
        cell.numberLabel.frame.size = cell.frame.size
        cell.numberLabel.layer.cornerRadius = cell.frame.height / 2
        
        numbers[indexPath.section][indexPath.row].forEach { numberString in
            if "0"..."9" ~= numberString || "." == numberString {
                cell.numberLabel.backgroundColor = .lightGray
            }else if "C" == numberString {
                cell.numberLabel.backgroundColor = .yellow
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSizeWidth: CGFloat = 0
        cellSizeWidth = ((collectionView.frame.width - 10) - 14 * 5) / 4
        let cellSizeHeigth: CGFloat = cellSizeWidth
        
        if indexPath.section == 4 && indexPath.row == 0 {
            cellSizeWidth = cellSizeWidth * 2 + 14 + 10
        }
        
        return CGSize(width: cellSizeWidth, height: cellSizeHeigth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number = numbers[indexPath.section][indexPath.row]
        
        switch calculateStatus {
        case .none:
            handleFirstNumberSelected(number)
        case .plus, .minus, .multiplication, .division:
            handleSecondNumberSelected(number)
        }
    }
    
    private func handleFirstNumberSelected(_ number: String) {
        switch number {
        case "0"..."9":
            firstNumber += number
            numberLabel.text = firstNumber
            
            if firstNumber.hasPrefix("0") {
                firstNumber = ""
            }
        case ".":
            if !confirmIncludeDecimalPoint(firstNumber) {
                firstNumber += number
                numberLabel.text = firstNumber
            }
        case "+" :
            calculateStatus = .plus
        case "-":
            calculateStatus = .minus
        case "×":
            calculateStatus = .multiplication
        case "÷":
            calculateStatus = .division
        case "C":
            clear()
        default:
            break
        }
    }
    
    private func handleSecondNumberSelected(_ number: String) {
        switch number {
        case "0"..."9":
            secondNumber += number
            numberLabel.text = secondNumber
            
            if secondNumber.hasPrefix("0") {
                secondNumber = ""
            }
        case ".":
            if !confirmIncludeDecimalPoint(secondNumber) {
                secondNumber += number
                numberLabel.text = secondNumber
            }
        case "=":
            calculateResultNumber()
        case "C":
            clear()
        default:
            break
        }
    }
    
    private func calculateResultNumber() {
        let firstNum = Double(firstNumber) ?? 0
        let secondNum = Double(secondNumber) ?? 0
        var resultString: String?
        
        switch calculateStatus {
        case .plus:
            resultString = String(firstNum + secondNum)
        case .minus:
            resultString = String(firstNum - secondNum)
        case .multiplication:
            resultString = String(firstNum * secondNum)
        case .division:
            resultString = String(firstNum / secondNum)
        default:
            break
        }
        
        if let result = resultString, result.hasSuffix(".0") {
            resultString = result.replacingOccurrences(of: ".0", with: "")
        }
        
        numberLabel.text = resultString
        firstNumber = resultString ?? ""
        secondNumber = ""
        calculateStatus = .none
    }
    
    private func confirmIncludeDecimalPoint(_ numberString: String) -> Bool {
        if numberString.range(of: ".") != nil || numberString.count == 0 {
            return true
        }else {
            return false
        }
    }
    
}
