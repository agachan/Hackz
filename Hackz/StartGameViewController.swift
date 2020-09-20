//
//  StartGameViewController.swift
//  Hackz
//
//  Created by AGA TOMOHIRO on 2020/09/19.
//  Copyright © 2020 AGA TOMOHIRO. All rights reserved.
//

import UIKit
class StartButton:UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    private func commonInit() {
        //角丸・枠線・背景色を設定する
        self.layer.cornerRadius = self.frame.width/2
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}

class StartGameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var memberCollection: UICollectionView!
    
    override func viewDidLoad() {
        memberCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        memberCollection.delegate = self
        memberCollection.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 例えば端末サイズの半分の width と height にして 2 列にする場合
        let width: CGFloat = UIScreen.main.bounds.width / 5
        let height = width
        return CGSize(width: width, height: height)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.lightGray
        
        return cell
    }
    
}
