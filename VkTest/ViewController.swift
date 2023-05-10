//
//  ViewController.swift
//  VkTest
//
//  Created by Artur Imanbaev on 06.05.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let buttonStart: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .green
        $0.setTitle("Запустить моделирование", for: .normal)
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        return $0
    }(UIButton())
    let groupSize: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Введите количество людей"
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
        $0.keyboardType = .phonePad
        $0.returnKeyType = .done
       return $0
    }(UITextField())
    let infectionGroup: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Введите количество зараженных"
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
        $0.keyboardType = .numberPad
        $0.returnKeyType = .done
       return $0
    }(UITextField())
    let timeOfInfection: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Введите время заражения"
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
        $0.keyboardType = .numberPad
        $0.returnKeyType = .done
       return $0
    }(UITextField())
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        groupSize.delegate = self
        infectionGroup.delegate = self
        timeOfInfection.delegate = self
        setup()
        addToolbarToNumberPad()
    }
    func addToolbarToNumberPad()
    {
        let numberPadToolbar: UIToolbar = UIToolbar()
        numberPadToolbar.isTranslucent = true
        numberPadToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneAction)),
        ]
        numberPadToolbar.sizeToFit()

        groupSize.inputAccessoryView = numberPadToolbar
        infectionGroup.inputAccessoryView = numberPadToolbar
        timeOfInfection.inputAccessoryView = numberPadToolbar
    }
    @objc func doneAction()
    {
        groupSize.resignFirstResponder()
        infectionGroup.resignFirstResponder()
        timeOfInfection.resignFirstResponder()
    }
    @objc private func nextVC(){
        let layout = NodeLayout(itemWidth: 50, itemHeight: 50, space: 5)
        let nextVC = NodeMap(collectionViewLayout: layout)
        nextVC.time = Double(timeOfInfection.text!)!
        if Int(groupSize.text!)! % 2 == 0{
            nextVC.rows = Int(groupSize.text!)!/2
            nextVC.cols = Int(groupSize.text!)!/2
        } else {
            nextVC.rows = Int(groupSize.text!)!/2 + 1
            nextVC.cols = Int(groupSize.text!)!/2
        }
        nextVC.amountOfSick = Int(infectionGroup.text!)!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func setup(){
        view.addSubview(buttonStart)
        NSLayoutConstraint.activate([
            buttonStart.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            buttonStart.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50),
            buttonStart.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50)
        ])
        view.addSubview(groupSize)
        NSLayoutConstraint.activate([
            groupSize.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            groupSize.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            groupSize.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            groupSize.heightAnchor.constraint(equalToConstant: 50)
        ])
        view.addSubview(infectionGroup)
        NSLayoutConstraint.activate([
            infectionGroup.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            infectionGroup.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            infectionGroup.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            infectionGroup.heightAnchor.constraint(equalToConstant: 50)
        ])
        view.addSubview(timeOfInfection)
        NSLayoutConstraint.activate([
            timeOfInfection.topAnchor.constraint(equalTo: view.topAnchor, constant: 400),
            timeOfInfection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            timeOfInfection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            timeOfInfection.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {//когда нажимаем go то заканчиваем писать
        textField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {//если под конец еще что-то осталось то заходим в условие
        if textField.text != "" {
            return true
        } else{
            textField.placeholder = "Type something"
            return false
        }
    }

}
