//
//  TargetLangViewController.swift
//  MyTranslate
//
//  Created by 정지현 on 2021/01/29.
//

import UIKit

class TargetLangViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "targetCell"
    
    var selectedLang: String?
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        let ud = UserDefaults.standard
        ud.set(self.selectedLang, forKey: "targetLang")
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
    let langList = ["한국어", "영어", "일본어", "중국어", "베트남어", "인도네시아어", "아랍어", "뱅갈어", "독일어", "스페인어", "프랑스어", "힌디어", "이탈리아어", "말레이시아어", "네덜란드어", "포르투갈어", "러시아어", "태국어", "터키어"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return langList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        cell.textLabel?.text = self.langList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedLang = self.langList[indexPath.row]
    }
    

}
