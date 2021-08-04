//
//  ViewController.swift
//  AnimationDemo
//
//  Created by mac-0009 on 28/07/21.
//

import UIKit

class RoomCell: UICollectionViewCell{
	@IBOutlet weak var roomView: UIView!
	@IBOutlet private weak var roomImageView: UIImageView!
	
	override func awakeFromNib() {
		self.backgroundColor = .clear
	}
	
	var cellData: RoomModel?{
		didSet{
			configureCell()
		}
	}
	
	private func configureCell(){
		guard let data = self.cellData else { return }
		self.roomImageView.image = data.roomImage
	}
}

struct RoomModel {
	
	var isActive: Bool = false
	var roomImage: UIImage = #imageLiteral(resourceName: "pexels-photo-930004")
	var roomTitle: String = ""
	
	static var active: RoomModel {
		RoomModel.init()
	}
}


class ViewController: UIViewController {
	
	//Mark: Outlet
	//-------------------------------------------------------------------------------------
	@IBOutlet private weak var colRoom: UICollectionView!
	@IBOutlet private weak var vwContainer: UIView!
	@IBOutlet private weak var vwColContainer: UIView!
	@IBOutlet private weak var vwMapContainer: UIView!
	@IBOutlet private weak var vwAnimateContainer: UIView!
	
	@IBOutlet private weak var imgView: UIImageView!
	@IBOutlet private weak var selectedRoomImageView: UIImageView!
	@IBOutlet private weak var topConstraints: NSLayoutConstraint!
	@IBOutlet private weak var bottomConstraints: NSLayoutConstraint!
	@IBOutlet private weak var roomTitleLabel: UILabel!
	
	//Mark: Class Variable
	//-------------------------------------------------------------------------------------
	private var arrRooms: [RoomModel] = [.active,.active,.active,.active,.active,.active]
	private var originY: CGFloat = 0.0
	private var initialCenter: CGPoint = .zero
	private var isOpenBottomSheet: Bool = false
	private var bottomLine: CALayer!
	private var minDraggableValue: CGFloat?
	
	private let blurEffect = UIBlurEffect(style: .light)
	private var visualEffectView = UIVisualEffectView()
	
	var selectedCell: UIView?
	var selectedCellImageViewSnapshot: UIView?
	var animator: Animator?

	var selectedIndex: Int = -1{
		didSet{
			if let cell = self.colRoom.cellForItem(at: [0,self.selectedIndex]) as? RoomCell{
				UIView.animate(withDuration: 0.4, animations: {
					cell.center.y -= cell.roomView.frame.height/2
					cell.roomView.layer.cornerRadius = 5
					cell.roomView.layer.masksToBounds = true
					cell.roomView.layer.shadowColor = UIColor.black.cgColor
					cell.roomView.layer.shadowOffset = CGSize(width: 0, height: 10.0)
					cell.roomView.layer.shadowRadius = 2
					cell.roomView.layer.shadowOpacity = 0.1
					cell.roomView.layer.masksToBounds = false
					UIView.animate(withDuration: 0.4) {
						cell.transform = .init(scaleX: 1.2, y: 1.2)
					}
					
				}, completion: nil)
				self.bottomLine.frame = CGRect.init(x: cell.center.x - 15, y: cell.frame.height + 10, width: 30, height: 2)
				self.colRoom.selectItem(at: [0,self.selectedIndex], animated: true, scrollPosition: .centeredHorizontally)
			}
		}
	}
	var previousIndex: Int = -1{
		didSet{
			if let cell = self.colRoom.cellForItem(at: [0,self.previousIndex]) as? RoomCell{
				UIView.animate(withDuration: 0.4, animations: {
					cell.center.y += cell.roomView.frame.height/2
					cell.roomView.layer.cornerRadius = 5
					cell.roomView.layer.masksToBounds = true
					cell.roomView.layer.shadowColor = UIColor.black.cgColor
					cell.roomView.layer.shadowOffset = CGSize(width: 0, height: 0)
					cell.roomView.layer.shadowRadius = 0
					cell.roomView.layer.shadowOpacity = 0.0
					cell.roomView.layer.masksToBounds = false
					UIView.animate(withDuration: 0.4) {
						cell.transform = .identity
					}
				}, completion: nil)
			}
		}
	}
	
	deinit {
		debugPrint("!!!\(ViewController.self)!!!")
	}
	
	//Mark: Custom Methods
	//-------------------------------------------------------------------------------------
	func configUI(){
		self.colRoom.delegate = self
		self.colRoom.dataSource = self
		
		self.topConstraints.constant = (ScreenConstants.screenHeight - ScreenConstants.topPadding)
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
		self.vwContainer.addGestureRecognizer(panGestureRecognizer)
		
		self.roomTitleLabel.text = "Bed"
		
		self.selectedCell = self.vwAnimateContainer
		self.selectedCellImageViewSnapshot = self.vwAnimateContainer?.snapshotView(afterScreenUpdates: false)
		
		createBlur()
		configureData()
		tapConfiguration()

	}
	
	//Mark: Life Cycle Methods
	//-------------------------------------------------------------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		self.configUI()
		// Do any additional setup after loading the view.
	}
}


//MARK:- Configuring Data
//-------------------------------------------------------------------------------------
extension ViewController {
	
	func configureData(){
		
		self.arrRooms = [
			RoomModel.init(isActive: false, roomImage: UIImage.init(named: "room1")!, roomTitle: "Bed Room"),
			RoomModel.init(isActive: false, roomImage: UIImage.init(named: "room2")!, roomTitle: "Bed Room"),
			RoomModel.init(isActive: false, roomImage: UIImage.init(named: "room3")!, roomTitle: "Bed Room"),
			RoomModel.init(isActive: false, roomImage: UIImage.init(named: "room4")!, roomTitle: "Bed Room"),
			RoomModel.init(isActive: false, roomImage: UIImage.init(named: "room5")!, roomTitle: "Bed Room"),
			RoomModel.init(isActive: false, roomImage: #imageLiteral(resourceName: "pexels-photo-930004"), roomTitle: "Bed Room"),
		]
		
		self.imgView.image = self.arrRooms.first?.roomImage
	}
}

//MARK:- Actions
//-------------------------------------------------------------------------------------
extension ViewController {
	
	private func tapConfiguration(){
		let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.mapViewTapped(sender:)))
		self.vwMapContainer.isUserInteractionEnabled = true
		self.vwMapContainer.addGestureRecognizer(tapGesture)
	}
	
	@objc func mapViewTapped(sender: UIView){
		self.presentSecondViewController()
	}
	
}

//MARK:- Blur layer
//-------------------------------------------------------------------------------------
extension ViewController {
	
	func createBlur(){
		visualEffectView.frame = view.bounds
		selectedRoomImageView.addSubview(visualEffectView)
	}
	
	func presentSecondViewController() {
		let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController

		secondViewController.transitioningDelegate = self

		secondViewController.modalPresentationStyle = .fullScreen

		present(secondViewController, animated: true)
	}
}

//MARK:- Pangesture setup
//-------------------------------------------------------------------------------------
extension ViewController {
	
	func openSheetTranslation(translation: CGPoint){
		guard let dragValue = self.minDraggableValue else {
			minDraggableValue = self.vwContainer.frame.origin.y - self.vwMapContainer.frame.height
			return
		}
		
		if translation.y < 0 &&
			self.vwContainer.frame.origin.y > dragValue &&
			translation.y > -(self.vwMapContainer.frame.height) &&
			!self.isOpenBottomSheet{
			self.vwContainer.center = CGPoint(x: initialCenter.x,
											  y: initialCenter.y + translation.y)
			self.topConstraints.constant = self.vwContainer.frame.origin.y + self.colRoom.frame.height - ScreenConstants.topPadding
		}
	}
	
	func closeSheetTranslation(translation: CGPoint){
		
		guard let dragValue = self.minDraggableValue else {
			minDraggableValue = self.vwContainer.frame.origin.y + self.vwMapContainer.frame.height
			return
		}
		
		if translation.y > 0 &&
			self.vwContainer.frame.origin.y < dragValue &&
			translation.y < (self.vwMapContainer.frame.height) &&
			self.isOpenBottomSheet{
			self.vwContainer.center = CGPoint(x: initialCenter.x,
											  y: initialCenter.y + translation.y)
			self.topConstraints.constant = self.vwContainer.frame.origin.y + self.colRoom.frame.height - ScreenConstants.topPadding
			
		}
	}
	
	@objc private func didPan(_ sender: UIPanGestureRecognizer) {
		switch sender.state {
		case .began:
			initialCenter = vwContainer.center
		case .changed:
			let translation = sender.translation(in: view)
			if self.isOpenBottomSheet{
				self.closeSheetTranslation(translation: translation)
			}else{
				self.openSheetTranslation(translation: translation)
			}
		case .ended:
			self.minDraggableValue = nil
			
			let minDragEnd = ScreenConstants.screenHeight - self.colRoom.frame.height - self.vwMapContainer.frame.height/2
			
			if self.vwContainer.frame.origin.y < minDragEnd{
				self.isOpenBottomSheet = true
				self.vwContainer.center = CGPoint(x: initialCenter.x,
												  y: initialCenter.y)
				self.topConstraints.constant = (ScreenConstants.screenHeight - ScreenConstants.topPadding - self.vwMapContainer.frame.height)
				initialCenter = vwContainer.center
			}else {
				self.vwContainer.center = CGPoint(x: initialCenter.x,
												  y: initialCenter.y)
				self.topConstraints.constant = (ScreenConstants.screenHeight - ScreenConstants.topPadding)
				self.isOpenBottomSheet = false
				initialCenter = vwContainer.center
			}
			
		default:
			break
		}
	}
}



//MARK:- UICollectionView Delegate & Datasource
//-------------------------------------------------------------------------------------
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		arrRooms.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomCell", for: indexPath) as? RoomCell else {
			return UICollectionViewCell()
		}
		cell.cellData = self.arrRooms[indexPath.row]
		
		guard let _ = self.bottomLine else {
			self.bottomLine = CALayer()
			self.colRoom.layer.addSublayer(self.bottomLine)
			self.bottomLine.backgroundColor = UIColor.black.cgColor
			self.bottomLine.frame = CGRect.init(x: cell.center.x - 15, y: cell.frame.height + 30, width: 30, height: 2)
			return cell
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard self.selectedIndex != indexPath.row else { return }

		self.previousIndex = self.selectedIndex
		self.selectedIndex = indexPath.row
		
		self.selectedRoomImageView.image = self.arrRooms[indexPath.row].roomImage
		
		self.visualEffectView.frame = self.imgView.frame
		self.visualEffectView.effect = self.blurEffect
		self.visualEffectView.alpha = 0.8
		
		self.selectedRoomImageView.frame = CGRect.init(x: self.imgView.frame.origin.x, y: ScreenConstants.screenHeight, width: self.imgView.frame.width, height: self.imgView.frame.height)
		
		UIView.animate(withDuration: 0.1) {
			
			self.selectedRoomImageView.frame = CGRect.init(x: self.imgView.frame.origin.x, y: 0, width: self.imgView.frame.width, height: self.imgView.frame.height)
		} completion: {_ in
			
			UIView.animate(withDuration: 0.2) {
				self.visualEffectView.frame = CGRect.init(x: 0, y: ScreenConstants.screenHeight, width: ScreenConstants.screenWidth, height: ScreenConstants.screenHeight)
			} completion: { (_) in
				
				self.visualEffectView.effect = nil
				self.selectedRoomImageView.frame = CGRect.init(x: self.imgView.frame.origin.x, y: 0, width: self.imgView.frame.width, height: 0)
				self.imgView.image = self.arrRooms[indexPath.row].roomImage
			}
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize.init(width: 70, height: 70)
	}
}

//MARK:- GestureRecognizerDelegate
//-------------------------------------------------------------------------------------
extension ViewController: UIGestureRecognizerDelegate{
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		if (gestureRecognizer is UIPanGestureRecognizer || gestureRecognizer is UIRotationGestureRecognizer) {
			return true
		} else {
			return false
		}
	}
}


//MARK:- Constants
//-------------------------------------------------------------------------------------
struct ScreenConstants {
	static let screenWidth = UIScreen.main.bounds.width
	static let screenHeight = UIScreen.main.bounds.height
	static let window = UIApplication.shared.windows.first
	static let topPadding = window?.safeAreaInsets.top ?? 0.0
	static let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
}
