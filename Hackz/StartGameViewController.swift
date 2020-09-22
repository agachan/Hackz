//
//  StartGameViewController.swift
//  Hackz
//
//  Created by AGA TOMOHIRO on 2020/09/19.
//  Copyright © 2020 AGA TOMOHIRO. All rights reserved.
//

import UIKit
import GRPC

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

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
}

class StartGameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collection: UICollectionView!
    var numbers: [Int] = []
    override func viewDidLoad() {
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.delegate = self
        collection.dataSource = self
        for n in 0..<100 {
                    numbers.append(n)
                }

        addLongPressGestureListner()
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        reorderCells(sourceIndex: sourceIndexPath.item, destinationIndex: destinationIndexPath.item)
    }
    private func reorderCells(sourceIndex: Int, destinationIndex: Int) {
        let n = numbers.remove(at: sourceIndex)
        numbers.insert(n, at: destinationIndex)
    }

    
    /// セルの長押しのリスナーの登録
    func addLongPressGestureListner() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        collection.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - PRIVATE METHODS
    
    /// セルの長押しジェスチャーのアクション
    ///
    /// - Parameters: gesture
    @objc
    private func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collection.indexPathForItem(at: gesture.location(in: collection)) else {break}
            collection.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collection.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
        case .ended:
            collection.endInteractiveMovement()
        default:
            collection.cancelInteractiveMovement()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 例えば端末サイズの半分の width と height にして 2 列にする場合
        let width: CGFloat = UIScreen.main.bounds.width / 5
        let height = width
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let kReorderCardsCollectionViewCell = "CollectionViewCell"
                let c = collectionView.dequeueReusableCell(withReuseIdentifier: kReorderCardsCollectionViewCell, for: indexPath)
                guard let cell = c as? CollectionViewCell else {
                    return c
                }
                cell.label.text = "\(numbers[indexPath.item])"

                return cell
    }
    
}
