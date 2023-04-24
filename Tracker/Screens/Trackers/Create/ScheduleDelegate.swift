//
//  ScheduleDelegate.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 13.04.2023.
//

protocol ScheduleDelegate : AnyObject {
    func onSelectSchedule(selectedDays: Set<Day>)
}
