//
//  ViewController.swift
//  TableViewApp
//
//  Created by VERTEX21 on 2019/08/10.
//  Copyright © 2019 k-kougi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //viewの動作をコントロールする
    @IBOutlet weak var baseCard: UIView!
    //スワイプ中にgood or bad の表示
    @IBOutlet weak var likeImage: UIImageView!
    
    //ユーザーカード
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    @IBOutlet weak var person5: UIView!
    
    
    //ベースカードの中心
    var centerOfCard: CGPoint!
    //ユーザーカードの配列
    var personList: [UIView] = []
    //選択されたカードの配列
    var selectedCardCount: Int = 0
    //ユーザーリスト
    let nameList: [String] =
    ["津田梅子","ジョージワシントン","ガリレオガリレイ","板垣退助","ジョン万次郎"]
    //「いいね」をされた名前の配列
    var likedName: [String] = []
    
    //viewのレイアウト処理が完了した時に呼ばれる
     override func viewDidLayoutSubviews() {
        //ベースカードの中心を代入
        centerOfCard = baseCard.center
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // personListにperson1から5を追加
        personList.append(person1)
        personList.append(person2)
        personList.append(person3)
        personList.append(person4)
        personList.append(person5)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToLikedList" {
            let vc = segue.destination as!
            LikedListTableViewController
           vc.likedName = likedName
        }
    }
    
    //ペースカードを元に戻す
    func resetCard(){
        //位置を戻す
        baseCard.center = centerOfCard
        //角度を戻す
        baseCard.transform = .identity
    }
    
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        //ペースカード
        let card = sender.view!
        //動いた距離
        let point = sender.translation(in: view)
        //取得できた距離をcard.centerに加算
        card.center = CGPoint(x: card.center.x + point.x,y: card.center.y + point.y)
        //ユーザーカードにも同じ動きをさせる
        personList[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y:card.center.y + point.y)
        
        // 元々の位置と移動先との差
        let xfromCenter = card.center.x - view.center.x - view.center.x
        
        //角度をつける処理
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        
        //ユーザーカードに角度をつける
        personList[selectedCardCount].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)

        
        if xfromCenter > 0 {
            // goodボタンの表示
            likeImage.image = #imageLiteral(resourceName: "いいね")
            likeImage.isHidden = false
        } else if xfromCenter < 0 {
            // badボタンの表示
            likeImage.image = #imageLiteral(resourceName: "よくないね")
            likeImage.isHidden = false
        }
        

        
        // 元の位置に戻す処理
        if sender.state == UIGestureRecognizer.State.ended {
            
            if card.center.x < 50 {
                
            UIView.animate(withDuration: 0.5, animations: {
            // 左に大きくスワイプしたときの処理
            // 左へ飛ばす場合
            // X座標を左に500とばす(-500)
            self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x - 500, y :self.personList[self.selectedCardCount].center.y)

        })
            //ペースカードの角度と位置を戻す
            resetCard()
                
            //likeImagaを隠す
            likeImage.isHidden = true
                
            likedName.append(nameList[selectedCardCount])
            //次のカードへ
            selectedCardCount += 1
            if selectedCardCount >= personList.count {
                //処理
                performSegue(withIdentifier: "ToLikedList", sender: self)
            }
                
            //ベースカードはもとの位置に戻す
            baseCard.center = centerOfCard
                
            //角度を元にもどす
            self.baseCard.transform = .identity
        } else if card.center.x > self.view.frame.width - 50 {
                
            // 右に大きくスワイプしたときの処理
            UIView.animate(withDuration: 0.5, animations: {
                
            // 右へ飛ばす場合
            // X座標を右に500とばす(-500)
            self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x + 500, y :self.personList[self.selectedCardCount].center.y)
                
            })
            //likeImagaを隠す
            self.likeImage.isHidden = true
            
            // いいねされたリストに追加
            likedName.append(nameList[selectedCardCount])
            // 次のカードへ
            selectedCardCount += 1
                
            //ペースカードの角度と位置を戻す
            resetCard()
                
            if selectedCardCount >= personList.count {
                performSegue(withIdentifier: "ToLikedList", sender: self)
            }
                
        }else{
            //アニメーションをつける
            UIView.animate(withDuration: 0.5, animations:  {
            // ベースカードを元の位置に戻す
            self.baseCard.center = self.centerOfCard
            //角度を戻す
            self.baseCard.transform = .identity
                self.personList[self.selectedCardCount].transform = .identity
            // ユーザーカードを元の位置に戻す
            self.personList[self.selectedCardCount].center = self.centerOfCard
            //ペースカードの角度と位置を戻す
            self.resetCard()
            //likeImagaを隠す
            self.likeImage.isHidden =
                true
                
        })
    }
    
    }
}
    @IBAction func dislikeButtonTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, animations: {
            //スペースカードをリッセット
            self.resetCard()
            //ユーザーカードを左にとばす
            self.personList[self.selectedCardCount].center = CGPoint(x:self.personList[self.selectedCardCount].center.x - 500, y:self.personList[self.selectedCardCount].center.y)
        })
        selectedCardCount += 1
        
        if selectedCardCount >= personList.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
    }
    @IBAction func likeButtunTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.resetCard()
            self.personList[self.selectedCardCount].center = CGPoint(x:self.personList[self.selectedCardCount].center.x + 500, y:self.personList[self.selectedCardCount].center.y)
        })
        likedName.append(nameList[selectedCardCount])
        selectedCardCount += 1
        
        if selectedCardCount >= personList.count {
            // 画面遷移
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
    }
    
    
}
