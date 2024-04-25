//
//  StepperView.swift
//  GetirLiteApp
//
//  Created by Damla Sahin on 18.04.2024.
//

import UIKit

enum StackViewOrientation {
    case horizontal
    case vertical
}

protocol StepperViewProtocol: AnyObject {
    func setCount(_ count: Int32)
    func getCount() -> Int32
}

protocol StepperViewDelegate: AnyObject {
    func stepperViewDidTapIncrease(_ stepperView: StepperView)
    func stepperViewDidTapDecrease(_ stepperView: StepperView)
    func stepperViewDidTapDelete(_ stepperView: StepperView)
}

class StepperView: UIView {
    weak var delegate: StepperViewDelegate?

    private var count: Int32 = 0 {
        didSet {
            countLabel.text = "\(count)"
            let decreaseButtonImage = count > 1 ? UIImage(systemName: "minus") : UIImage(named: "trashIcon")
            decreaseButton.setImage(decreaseButtonImage, for: .normal)
        }
    }
    
    private lazy var decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.addTarget(self, action: #selector(decreaseButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.tintColor = UIColor(named: "text-primary")
        button.isUserInteractionEnabled = true
        button.accessibilityIdentifier = "stepperDecrease"
        return button
    }()
    
    private lazy var increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(increaseButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.tintColor = UIColor(named: "text-primary")
        button.isUserInteractionEnabled = true
        button.accessibilityIdentifier = "stepperIncrease"
        return button
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0"
        label.font = UIFont(name: "OpenSans-Bold", size: 16)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(named: "text-primary")
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [decreaseButton, countLabel, increaseButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 0
        return stack
    }()
    
    var stackViewOrientation: StackViewOrientation = .horizontal {
        didSet {
            updateStackViewOrientation()
        }
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
        count = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateStackViewOrientation() {
        stackView.axis = (stackViewOrientation == .horizontal) ? .horizontal : .vertical
    }
    
    private func setupView() {
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        stackView.addSubview(decreaseButton)
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            decreaseButton.heightAnchor.constraint(equalToConstant: 48),
            decreaseButton.widthAnchor.constraint(equalToConstant: 48)
        ])
        
        stackView.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countLabel.widthAnchor.constraint(equalToConstant: 50),
            countLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        stackView.addSubview(increaseButton)
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            increaseButton.heightAnchor.constraint(equalToConstant: 48),
            increaseButton.widthAnchor.constraint(equalToConstant: 48)
        ])
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(named: "bg-body")?.cgColor
        self.layer.cornerRadius = 8
        
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
    }
    
    @objc private func decreaseButtonTapped() {
        if count > 0 {
            count -= 1
            delegate?.stepperViewDidTapDecrease(self)
        } else {
            delegate?.stepperViewDidTapDelete(self)
        }
    }
    
    @objc private func increaseButtonTapped() {
        count += 1
        delegate?.stepperViewDidTapIncrease(self)
        
    }
}

extension StepperView: StepperViewProtocol {
    func setCount(_ newCount: Int32) {
        DispatchQueue.main.async {
            self.count = newCount
            self.countLabel.text = "\(newCount)"
        }
    }
    
    func getCount() -> Int32 {
        return count
    }
}
