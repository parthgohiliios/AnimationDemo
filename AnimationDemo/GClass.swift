//
//  GClass.swift
//  AnimationDemo
//
//  Created by mac-0009 on 28/07/21.
//

import UIKit

//MARK:- UIView
//-------------------------------------------------------------------------------------
class RoundCornerRadius15: UIView{

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setCornerRadius()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setCornerRadius()
	}

	func setCornerRadius(){
		self.layer.cornerRadius = 5
	}

}


//MARK:- UIImageView
//-------------------------------------------------------------------------------------
class RoundCornerImageView15: UIImageView{
		
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setCornerRadius()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setCornerRadius()
	}

	func setCornerRadius(){
		self.layer.cornerRadius = 5
	}
}
