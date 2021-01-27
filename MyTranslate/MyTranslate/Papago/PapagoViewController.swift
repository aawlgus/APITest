//
//  PapagoViewController.swift
//  MyTranslate
//
//  Created by 정지현 on 2021/01/27.
//

import UIKit

class PapagoViewController: UIViewController {
    
    @IBOutlet weak var inputText: UITextView!
    
    @IBAction func translateBtn(_ sender: Any) {
        guard let inputText = inputText.text else {return}
        if inputText == "" || inputText == " " || inputText == "   " {
            print("no input data")
        } else{
            performSegue(withIdentifier: "papagoSegue", sender: self)
        }
        self.inputText.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PapagoResultViewController {
            if let text = inputText.text {
                dest.queryText = text
            }
        }
    }

}
