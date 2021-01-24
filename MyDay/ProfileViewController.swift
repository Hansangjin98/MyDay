//
//  ProfileViewController.swift
//  MyDay
//
//  Created by 한상진 on 2021/01/19.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet var userName: UILabel!
    @IBOutlet var userEmail: UILabel!
    @IBOutlet var userPosting: UILabel!
    @IBOutlet var mainImageView: UIImageView!
    
    @IBOutlet var nameChangeBtn: UIButton!
    @IBOutlet var resetPasswordBtn: UIButton!
    @IBOutlet var signOutBtn: UIButton!
    
    
    var userEmailAddress: String!
    var databaseRef: DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        loadProfileDate()
        designSet()
    }
    
    // MARK: - 뒤로가기 버튼 구현
    @IBAction func btnBackButton(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! UIViewController
        let transition = CATransition()
        obj.modalPresentationStyle = .fullScreen
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(obj, animated: false, completion: nil)
    }
    
    
    // MARK: - 이름 재설정 버튼 구현
    @IBAction func btnReName(_ sender: UIButton) {
        let alert = UIAlertController(title: "이름 변경", message: "새 이름을 입력하세요", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: { (ok) in
            if let uid = Auth.auth().currentUser?.uid {
                self.databaseRef.child("profile/\(uid)/name").setValue(alert.textFields?[0].text)
            }
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: { (cancel) in
        })
        alert.addTextField(configurationHandler: { (mytf) in
            mytf.placeholder = "이름"
        })
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 비밀번호 재설정 버튼 구현
    @IBAction func btnPasswordReset(_ sender: UIButton) {
        let alert = UIAlertController(title: "알림", message: "비밀번호 재설정 이메일을 발송할까요?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: {_ in
            Auth.auth().sendPasswordReset(withEmail: self.userEmailAddress, completion: nil)
            if let reset = self.userEmailAddress {
                let finish = UIAlertController(title: "알림", message: "\(reset) 으로 발송되었습니다.", preferredStyle: .alert)
                let finishOk = UIAlertAction(title: "확인", style: .default, handler: {_ in
                    try! Auth.auth().signOut()
                    let view = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
                    view?.modalPresentationStyle = .fullScreen
                    self.present(view!, animated: true, completion: nil)
                })
                finish.addAction(finishOk)
                self.present(finish, animated: true, completion: nil)
            }
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 로그아웃 버튼 구현
    @IBAction func btnSignOut(_ sender: UIButton) {
        let alert = UIAlertController(title: "알림", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: {_ in
            try! Auth.auth().signOut()
            let view = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            view?.modalPresentationStyle = .fullScreen
            self.present(view!, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 프로필 데이터 불러오기
    func loadProfileDate() {
        if let userID = Auth.auth().currentUser?.uid {
            databaseRef.child("profile").child(userID).observe(.value, with: { (snapshot) in
                let values = snapshot.value as? NSDictionary
                if let usn = values?["name"] as? String {
                    self.userName.text = "이름 : \(usn)"
                }

                if let use = values?["email"] as? String {
                    self.userEmail.text = "이메일 : \(use)"
                    self.userEmailAddress = use
                }
            })
        }
    }
    // MARK: - 디자인 세팅
    func designSet() {
        mainImageView.image = UIImage(named: "icon.png")
        
        nameChangeBtn.backgroundColor = UIColor(rgb: 0xF6E29A)
        resetPasswordBtn.backgroundColor = UIColor(rgb: 0xF6E29A)
        signOutBtn.backgroundColor = UIColor(rgb: 0xF6E29A)
    }
}
