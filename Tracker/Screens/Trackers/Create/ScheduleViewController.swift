//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 11.04.2023.
//

import UIKit

final class ScheduleViewController: UIViewController {
    weak var scheduleDelegate: ScheduleDelegate? = nil
    var selectedDays: Set<Day> = []
    
    private let days = Day.allCases
    
    private lazy var readyButton: UIButton = {
        let readyButton = UIButton()
        readyButton.backgroundColor = UIColor.dsColor(dsColor: DSColor.black)
        readyButton.setTitle("Готово", for: UIControl.State.normal)
        readyButton.setTitleColor(UIColor.dsColor(dsColor: DSColor.white), for: UIControl.State.normal)
        readyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        readyButton.layer.cornerRadius = 16
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.addTarget(self, action: #selector(onReadyButtonClick), for: .touchUpInside)
        return readyButton
    }()
    
    private lazy var scheduleTable: UITableView = {
        let scheduleTable = UITableView()
        scheduleTable.register(ScheduleViewCell.self, forCellReuseIdentifier: ScheduleViewCell.identifier)
        scheduleTable.separatorInset = UIEdgeInsets.init(top: 0, left: 32, bottom: 0, right: 32)
        scheduleTable.separatorColor = UIColor.dsColor(dsColor: DSColor.gray)
        scheduleTable.layer.masksToBounds = true
        scheduleTable.delegate = self
        scheduleTable.dataSource = self
        scheduleTable.translatesAutoresizingMaskIntoConstraints = false
        return scheduleTable
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @objc private func onReadyButtonClick() {
        scheduleDelegate?.onSelectSchedule(selectedDays: selectedDays)
        navigationController?.popViewController(animated: true)
    }
    
    private func configureUI() {
        title = "Расписание"
        navigationItem.hidesBackButton = true
        view.backgroundColor = UIColor.dsColor(dsColor: DSColor.white)
        view.addSubview(scheduleTable)
        view.addSubview(readyButton)
        
        NSLayoutConstraint.activate([
            scheduleTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scheduleTable.bottomAnchor.constraint(equalTo: readyButton.topAnchor, constant: -47),
            scheduleTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scheduleTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            readyButton.heightAnchor.constraint(equalToConstant: 60),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        scheduleTable.tableFooterView = UIView.init()
        scheduleTable.tableHeaderView = UIView.init()
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ScheduleViewCell else { return }
        
        let day = days[indexPath.row]
        if selectedDays.contains(day) {
            selectedDays.remove(day)
            cell.setSwitchPosition(isOn: false)
        } else {
            selectedDays.insert(day)
            cell.setSwitchPosition(isOn: true)
        }
    }
}


extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = scheduleTable.dequeueReusableCell(withIdentifier: ScheduleViewCell.identifier, for: indexPath) as? ScheduleViewCell else { return .init() }
        let day = days[indexPath.row]
        let cornerMask: CACornerMask
        let isLastRow = indexPath.row == days.count - 1
        
        switch (indexPath.row) {
        case 0: cornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case days.count - 1: cornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        default: cornerMask = []
        }
        
        cell.bindCell(
            day: day.rawValue,
            isOn: selectedDays.contains(day),
            corners: cornerMask,
            isShowDivider: !isLastRow
        )
        return cell
    }
}
