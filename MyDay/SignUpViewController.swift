//
//  SignUpViewController.swift
//  MyDay
//
//  Created by 한상진 on 2021/01/19.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var passwordCheck: UITextField!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var signUp: UIButton!
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        designSet()
        keyboardNoti()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
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
    
    // MARK: - 회원가입 버튼 구현
    @IBAction func btnSignUp(_ sender: UIButton) {
        if (password.text == passwordCheck.text) {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { [self] (user, error) in
                let uid = user?.user.uid
                self.databaseRef.child("profile").child(uid!).updateChildValues(["name": self.name.text!, "email": self.email.text!])
                if error != nil { print(error!) } else { return }
            })
            
            let alert = UIAlertController(title: "알림", message: "회원가입 되었습니다", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in
                self.initCategory()
                self.navigationController?.popViewController(animated: true)
                
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "알림", message: "비밀번호와 비밀번호 확인 문자가 다릅니다", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - 초기 데이터베이스 세팅
    func initCategory() {
        let mvc = MainViewController()
        if let userID = Auth.auth().currentUser?.uid {
            mvc.dbRef = mvc.db.collection("\(userID)").document("CategoryList")
            mvc.dbRef?.setData(["Category1" : "일기"])
            mvc.dbRef?.setData(["Category2" : "영화"])
            mvc.dbRef?.setData(["Category3" : "음악"])
        }
    }
    
    // MARK: - 디자인 세팅
    func designSet() {
        mainImageView.image = UIImage(named: "icon.png")
        signUp.backgroundColor = UIColor(rgb: 0xF6E29A)
    }
    
    // MARK: - 키보드 터치 세팅
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    // MARK: - 키보드 노티피케이션
    func keyboardNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
