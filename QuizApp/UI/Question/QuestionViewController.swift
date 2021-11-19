//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by Priyal PORWAL on 12/11/21.
//

import UIKit

class QuestionViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private(set) var allowsMultipleSelection: Bool = false
    private(set) var question = ""
    private(set) var options = [String]()
    private var selection: (([String]) -> Void)? = nil
    private let reuseIdentifier = "Cell"
    
    convenience init(question: String,
                     options: [String],
                     isMultipleSelection: Bool,
                     selection: @escaping (([String]) -> Void)) {
        self.init()
        self.question = question
        self.options = options
        self.allowsMultipleSelection = isMultipleSelection
        self.selection = selection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = question
        tableView.allowsMultipleSelection = allowsMultipleSelection
    }
}

extension QuestionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection?(selectedOptions(in: tableView))
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.allowsMultipleSelection {
            selection?(selectedOptions(in: tableView))
        }
    }
    
    private func selectedOptions(in tableView: UITableView) -> [String] {
        guard let indexPaths = tableView.indexPathsForSelectedRows else { return [] }
        return indexPaths.map { options[$0.row]
        }
    }
}

extension QuestionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueCell(in: tableView)
        cell.contentConfiguration = OptionCellContentConfiguration(text: options[indexPath.row])
        return cell
    }
    
    private func dequeueCell(in tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
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
