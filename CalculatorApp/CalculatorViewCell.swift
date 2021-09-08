import Foundation
import UIKit

class CalculatorViewCell: UICollectionViewCell {
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 32)
        label.clipsToBounds = true
        label.backgroundColor = .systemRed
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(numberLabel)
    }
    
    override var isHighlighted: Bool {
        didSet{
            if isHighlighted {
                self.numberLabel.alpha = 0.3
            }else {
                self.numberLabel.alpha = 1
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
