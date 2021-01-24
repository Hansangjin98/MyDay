//
//  FindPasswordViewController.swift
//  MyDay
//
//  Created by 한상진 on 2021/01/19.
//

import UIKit
import Firebase

class FindPasswordViewController: UIViewController {
    @IBOutlet var inform: UILabel!
    @IBOutlet var email: UITextField!
    @IBOutlet var sendEmail: UIButton!
    @IBOutlet var mainImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        informTextSet()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        designSet()
        keyboardNoti()
    }
    
    // MARK: - 비밀번호 재설정 버튼 구현
    @IBAction func btnSendEmail(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: email.text!, completion: nil)
        
        let alert = UIAlertController(title: "알림", message: "재설정 이메일이 발송되었습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in
            let view = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            view?.modalPresentationStyle = .fullScreen
            self.present(view!, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 키보드 높이 세팅
    @objc func keyboardWillShow(_ sender: Notification) {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        if height > 800 {
            self.view.frame.origin.y = -240
        } else {
            self.view.frame.origin.y = -200
        }
    }
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
    // MARK: - 키보드 노티피케이션
    func keyboardNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - 키보드 터치 세팅
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    // MARK: - 메인 텍스트 구성
    func informTextSet() {
        inform.text = "MyDay계정의 비밀번호를 재설정합니다.\n\n비밀번호를 재설정 할 이메일을 입력해주세요."
        inform.numberOfLines = 3
        let attributedString = NSMutableAttributedString(string: inform.text!)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .medium), range: (inform.text! as NSString).range(of: "비밀번호를 재설정 할 이메일을 입력해주세요."))
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemGray, range: (inform.text! as NSString).range(of: "비밀번호를 재설정 할 이메일을 입력해주세요."))
        self.inform.attributedText = attributedString
    }
    
    // MARK: - 디자인 세팅
    func designSet() {
        mainImageView.image = UIImage(named: "icon.png")
        inform.adjustsFontSizeToFitWidth = true
        sendEmail.backgroundColor = UIColor(rgb: 0xF6E29A)
    }
    
}
