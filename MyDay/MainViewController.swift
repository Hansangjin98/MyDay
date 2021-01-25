//
//  MainViewController.swift
//  MyDay
//
//  Created by 한상진 on 2021/01/19.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    @IBOutlet var categoryText: UILabel!
    @IBOutlet var addCategorybtn: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    var databaseRef = Database.database().reference()
    var categoryList = [CategoryList]()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTextSet()
        backBarButtonStyle()
        makeCategory()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenHeight/5)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        
    }
    
    // MARK: - 프로필 이동 버튼 구현
    @IBAction func btnProfile(_ sender: UIBarButtonItem) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! UIViewController
        let transition = CATransition()
        obj.modalPresentationStyle = .fullScreen
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(obj, animated: false, completion: nil)
    }
    
    // MARK: - 카테고리 추가 버튼 구현
    @IBAction func btnAddCategory(_ sender: UIButton) {
        let alert = UIAlertController(title: "알림", message: "추가할 카테고리의 제목을 입력하세요", preferredStyle: .alert)
        let ok = UIAlertAction(title: "추가", style: .default, handler: { _ in
            if let text = alert.textFields?[0].text {
                let item: CategoryList = CategoryList(categoryName: text)
                self.categoryList.append(item)
                self.collectionView.reloadData()
            }
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addTextField(configurationHandler: { (mytf) in
            mytf.placeholder = "제목"
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - 네비게이션 바 세팅
    func backBarButtonStyle() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .systemPink
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    // MARK: - 메인 텍스트 세팅
    func categoryTextSet() {
        if let userID = Auth.auth().currentUser?.uid {
            databaseRef.child("profile").child(userID).observe(.value, with: { (snapshot) in
                let values = snapshot.value as? NSDictionary
                if let mainText = values?["name"] as? String {
                    self.categoryText.text = "\(mainText)님의 카테고리"
                }
            })}
    }
    
    // MARK: - 컬렉션 뷰 셀 세팅
    func makeCategory() {
        let item: CategoryList = CategoryList(categoryName: "일기")
        categoryList.append(item)
        
        let item2: CategoryList = CategoryList(categoryName: "영화")
        categoryList.append(item2)
        
        let item3: CategoryList = CategoryList(categoryName: "음악")
        categoryList.append(item3)
    }
}

    // MARK: - 컬렉션 뷰 델리게이트

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MyCollectionViewCell
        cell.categoryBtn.setTitle("\(categoryList[indexPath.row].categoryName)", for: .normal)
        cell.frame.size = CGSize(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/5)
        return cell
    }
}
