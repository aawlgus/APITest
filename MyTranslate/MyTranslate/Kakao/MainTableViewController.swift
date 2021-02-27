//
//  MainTableViewController.swift
//  MyTranslate
//
//  Created by 정지현 on 2021/01/26.
//

import UIKit
import Alamofire

class MainTableViewController: UITableViewController {
    
    let apiKey = KakaoKey.KAKAO_KEY
    
    @IBOutlet weak var koreanTextView: UITextView!
    @IBOutlet weak var englishTextView: UITextView!
    
    @IBOutlet weak var searchLangBtn: UIButton!
    @IBOutlet weak var targetLangBtn: UIButton!
    
    var searchLang: String = "kr"
    var targetLang: String = "en"
   
    @IBAction func translate(_ sender: Any) {
        
        let ud = UserDefaults.standard
        let srclang = ud.string(forKey: "searchLang")!
        self.searchLang = changeLangType(lang: srclang)
        let tgtlang = ud.string(forKey: "targetLang")!
        self.targetLang = changeLangType(lang: tgtlang)
        
        self.englishTextView.text = nil
        guard let query = koreanTextView.text else {return}
        self.koreanTextView.resignFirstResponder()
        
        let urlString = "https://dapi.kakao.com/v2/translation/translate?query=\(query)&src_lang=\(searchLang)&target_lang=\(targetLang)"
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
                self.alert(message: "에러가 발생했습니다.")
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
                        DispatchQueue.main.async {
                            if line == [] {
                                print("no data")
                                self.alert(message: "입력값이 존재하지 않습니다.")
                            } else if list == Optional([["."]]) {
                                self.alert(message: "입력값이 존재하지 않습니다.")
                            }
                            else {
                                self.englishTextView.text += "\(line[0]) \n"
                            }
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
                self.alert(message: "입력값이 존재하지 않습니다.")
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
    
    @IBAction func translateByAlamofire(_ sender: Any) {
        
        let ud = UserDefaults.standard
        let srclang = ud.string(forKey: "searchLang")!
        self.searchLang = changeLangType(lang: srclang)
        let tgtlang = ud.string(forKey: "targetLang")!
        self.targetLang = changeLangType(lang: tgtlang)
        
        self.englishTextView.text = nil
        guard let query = koreanTextView.text else {return}
        self.koreanTextView.resignFirstResponder()
        let url = "https://dapi.kakao.com/v2/translation/translate"
        let parameters = ["query" : query, "src_lang" : searchLang, "target_lang" : targetLang]
        let headers: HTTPHeaders = ["Authorization" : "KakaoAK \(apiKey)"]
        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .queryString), headers: headers).validate().responseJSON{ response in
            //debugPrint(response)
            switch response.result {
            case .success(let value):
                //print("Validation Successful")
                //print(value)
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let json = try JSONDecoder().decode(Translated.self, from: data)
                    print("json: \(json)")
                    if let list = json.translatedText {
                        for line in list {
                            print("line: \(line)")
                            DispatchQueue.main.async {
                                if line == [] {
                                    print("no data")
                                    self.alert(message: "입력값이 존재하지 않습니다.")
                                } else if list == Optional([["."]]) {
                                    self.alert(message: "입력값이 존재하지 않습니다.")
                                } else {
                                    self.englishTextView.text += "\(line[0]) \n"
                                }
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.alert(message: "입력값이 존재하지 않습니다.")
                }
                print("error: \(error)")
                //print("result: \(response.result)")
            
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        koreanTextView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        
        let ud = UserDefaults.standard
        let srclang = ud.string(forKey: "searchLang")
        let tgtlang = ud.string(forKey: "targetLang")
        self.searchLangBtn.setTitle(srclang, for: .normal)
        self.targetLangBtn.setTitle(tgtlang, for: .normal)
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
    
    //override func performSegue(withIdentifier identifier: String, sender: Any?) {
    //    self.performSegue(withIdentifier: "srcSegue", sender: self)
    //}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination
        guard let svc = dest as? SrcLangViewController else {
            return
        }
        svc.selectedLang = self.searchLang
    }

    

}

extension MainTableViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetup()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if koreanTextView.text == "" {
            textViewSetup()
        }
    }
    
    // TextView Placeholder 셋업
    func textViewSetup() {
        if koreanTextView.text == "내용을 입력하세요. " {
            koreanTextView.text = ""
            koreanTextView.textColor = UIColor.black
        } else if koreanTextView.text == "" {
            koreanTextView.text = "내용을 입력하세요. "
            koreanTextView.textColor = UIColor.lightGray
        }
    }
    
    func alert(title: String = "Alert", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func changeLangType(lang:String) -> String {
        var resultLang: String?
        if lang == "한국어" {
            resultLang = "kr"
        } else if lang == "영어" {
            resultLang = "en"
        } else if lang == "일본어" {
            resultLang = "jp"
        } else if lang == "중국어" {
            resultLang = "cn"
        } else if lang == "베트남어" {
            resultLang = "vi"
        } else if lang == "인도네시아어" {
            resultLang = "id"
        } else if lang == "아랍어" {
            resultLang = "ar"
        } else if lang == "뱅갈어" {
            resultLang = "bn"
        } else if lang == "독일어" {
            resultLang = "de"
        } else if lang == "스페인어" {
            resultLang = "es"
        } else if lang == "프랑스어" {
            resultLang = "fr"
        } else if lang == "힌디어" {
            resultLang = "hi"
        } else if lang == "이탈리아어" {
            resultLang = "it"
        } else if lang == "말레이시아어" {
            resultLang = "ms"
        } else if lang == "네덜란드어" {
            resultLang = "nl"
        } else if lang == "포르투갈어" {
            resultLang = "pt"
        } else if lang == "러시아어" {
            resultLang = "ru"
        } else if lang == "태국어" {
            resultLang = "th"
        } else if lang == "터키어" {
            resultLang = "tr"
        }
        return resultLang!
    }
    
}
