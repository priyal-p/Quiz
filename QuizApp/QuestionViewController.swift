//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by Priyal PORWAL on 12/11/21.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var question = ""
    private var options = [String]()
    private var selection: (([String]) -> Void)? = nil
    private let reuseIdentifier = "Cell"
    
    convenience init(question: String,
                     options: [String],
                     selection: @escaping (([String]) -> Void)) {
        self.init()
        self.question = question
        self.options = options
        self.selection = selection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = question
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueCell(in: tableView)
        cell.contentConfiguration = OptionCellContentConfiguration(text: options[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    private func dequeueCell(in tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection?([options[indexPath.row]])
    }
}

class OptionCellContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            self.configureCell(with: configuration)
        }
    }
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configureCell(with: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension OptionCellContentView {
    func setupViews() {
        self.addSubview(textLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    func configureCell(with configuration: UIContentConfiguration) {
        guard let configuration = configuration as? OptionCellContentConfiguration else { return }
        self.textLabel.text = configuration.text
    }
}

struct OptionCellContentConfiguration: UIContentConfiguration {
    var text: String = ""
    func makeContentView() -> UIView & UIContentView {
        return OptionCellContentView(self)
    }
    
    func updated(for state: UIConfigurationState) -> OptionCellContentConfiguration {
        return self
    }
}
