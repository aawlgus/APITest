//
//  PapagoResultViewController.swift
//  MyTranslate
//
//  Created by 정지현 on 2021/01/27.
//

import UIKit

class PapagoResultViewController: UIViewController {
    
    var queryText: String?
    let clientID = ""
    let clientSecret = ""
    
    @IBOutlet weak var outputText: UITextView!
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    
    func translateText() {
        guard let query = queryText else {return}
        let param = "source=ko&target=es&text=\(query)"
        let urlString = "https://openapi.naver.com/v1/papago/n2mt?" + param
        let urlWithPercentEscapes = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url = URL(string: urlWithPercentEscapes)
        
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        //request.httpBody = paramData
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let str = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? ""
                print(str)
                DispatchQueue.main.async {
                    self.outputLabel.text = str
                    self.outputText.text = str
                }
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleNavigationItem.title = "번역 결과"
        translateText()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
