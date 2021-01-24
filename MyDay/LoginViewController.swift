//
//  LoginViewController.swift
//  MyDay
//
//  Created by 한상진 on 2021/01/19.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var findPassword: UIButton!
    @IBOutlet var signUp: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonStyleSet()
        designSet()
        keyboardNoti()
    }
    
    // MARK: - 로그인 버튼 구현
    @IBAction func btnSignIn(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, err) in
            if(err != nil) {
                let alert = UIAlertController(title: "로그인 실패", message: "이메일 혹은 비밀번호를 확인하세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let view = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
                view!.modalPresentationStyle = .fullScreen
                self.present(view!, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - 디자인 세팅
    func designSet() {
        mainImageView.image = UIImage(named: "icon.png")
        loginBtn.backgroundColor = UIColor(rgb: 0xF6E29A)
        findPassword.setTitleColor(UIColor(rgb: 0x999A9C), for: .normal)
        signUp.setTitleColor(UIColor(rgb: 0x999A9C), for: .normal)
    }
    
    // MARK: - 키보드 높이 세팅
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -200
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
    
    // MARK: - 네비게이션 바 세팅
    func backBarButtonStyleSet() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .systemPink
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}
