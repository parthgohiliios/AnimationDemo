//
//  MapViewController.swift
//  AnimationDemo
//
//  Created by mac-0009 on 04/08/21.
//

import UIKit

class MapViewController: UIViewController {
	
	
	@IBOutlet weak var mapContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.dismiss(animated: true, completion: nil)
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
