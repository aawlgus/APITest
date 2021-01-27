//
//  MainTableViewController.swift
//  MyTranslate
//
//  Created by 정지현 on 2021/01/26.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    @IBOutlet weak var koreanTextView: UITextView!
    @IBOutlet weak var englishTextView: UITextView!
    
    let apiKey = "898e6b6efa37d9a20f92d0dd6903889c"
    var dataStructure: Translated?
    
    @IBAction func translate(_ sender: Any) {
        guard let query = koreanTextView.text else {return}
        let urlString = "https://dapi.kakao.com/v2/translation/translate?query=\(query)&src_lang=kr&target_lang=en"
        let urlWithPercentEscapes = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url = URL(string: urlWithPercentEscapes)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let e = error {
                NSLog("An error has occurred: \(e.localizedDescription)")
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                            return
                        }
            // 통신에 성공한 경우 data에 Data 객체가 전달됨
            print(data)
            print(response)
            
            let decoder = JSONDecoder()
            do {
                let json = try decoder.decode(Translated.self, from: data)
                print(json)
                if let list = json.translatedText {
                    for line in list {
                        print(line)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
            
            
            /*
            // 응답 처리 메소드
            DispatchQueue.main.async {
                self.englishTextView.text = nil
                
                do {
                    let object = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    guard let jsonObject = object else { return }
                    print(jsonObject)
                    let result = jsonObject["translated_text"] as? [[String]]
                    let resultText = result![0][0]
                    print(result ?? "No Results")
                    for line in result![0] {
                        print(line)
                        self.englishTextView.text = "\(line) \n"
                    }
                    //self.englishTextView.text = resultText
                    
                } catch let e as NSError {
                    print("An error has occurred while parsing JSONObject: \(e.localizedDescription)")
                }
            }
            */
 
            
        }
        task.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    

}
