//
//  CalanderViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit

class CalendarVc: UIViewController {
    
    var dates = [Date]()
    var dateComponents = [DateComponents]()
    
 lazy var calendar = {
        
        let calendar = UICalendarView()
        calendar.calendar = .current
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.locale = .current
        calendar.fontDesign = .rounded
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendar.selectionBehavior = selection
        calendar.delegate = self
     
        return calendar
     
    }()
    
    
    lazy var todayBarButton = {
        
        let barButton = UIBarButtonItem()
        barButton.title = "Today"
        barButton.target = self
        barButton.action = #selector(setToday)
        
        return barButton
        
    }()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.setRightBarButton(todayBarButton, animated: false)
        self.title = "Calendar"
        
        dates = getDates()
        setupDatepicker()
   }
    
    
    func setupDatepicker() {
        
        view.addSubview(calendar)
        setDatePickerContraints()
    }

    
    func reloadDecoration(forDates:[Date]) {
        
        dateComponents.removeAll()
        
        dates.forEach { Date in
            
            if Calendar.current.isDate(Date, equalTo: calendar.visibleDateComponents.date!, toGranularity: .month) {
                dateComponents.append(Calendar.current.dateComponents(in: TimeZone.current, from: Date))
            }
        }
        
       calendar.reloadDecorations(forDateComponents: dateComponents , animated: true)
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dates = getDates()
        reloadDecoration(forDates: dates)
        setAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
       setAppearance()
        
    }
    
    func setAppearance() {
        
        view.backgroundColor = currentTheme.backgroundColor
        calendar.tintColor = currentTheme.tintColor
        calendar.backgroundColor = .tertiarySystemGroupedBackground
   
    }
    
    func setDatePickerContraints() {
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    

    
    @objc func setToday() {
        
        let dateComponent = Calendar.current.dateComponents(in: .current, from: Date())
        calendar.setVisibleDateComponents(dateComponent, animated: true)
        
    }
    
    
    func getDates()->[Date] {

        let output = DatabaseHelper.shared.selectFrom(table: TaskTable.title, columns:
                                                        [TaskTable.startDate], wherec: nil)
        var dates = [Date]()
        
        output.forEach { row in
            
           var contains = false
            
            guard let deadline =  row[TaskTable.startDate] as? Double else {
                return
            }
            
            let date = Date(timeIntervalSince1970: deadline)
            
            dates.forEach { Date in
                if Calendar.current.isDate(Date, equalTo: date, toGranularity: .day) {
                    contains = true
                }
            }
            
            if contains == false {
                dates.append(date)
            }
          
        }
       
        return dates
    }

  
}




extension CalendarVc:UICalendarViewDelegate,UICalendarSelectionSingleDateDelegate {
  
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
        guard let dateComp = dateComponents else {
            return
        }
        
        let date = Calendar.current.date(from: dateComp)
        
        let taskVc = YourTasksVc(stateForVc: .TaskForDate)
        taskVc.date = date
        
        navigationController?.pushViewController(taskVc, animated: true)
    }
    
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
    
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
      
        guard let dateFromComponent = dateComponents.date else {
            return nil
        }
        
        for date in dates {
            if calendarView.calendar.isDate(date, inSameDayAs: dateFromComponent) {
                return .default(color: .tintColor, size: .large)
            }
        }
           
        return nil
    }
    
    
}

