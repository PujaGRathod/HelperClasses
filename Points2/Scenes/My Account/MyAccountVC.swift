//
//  MyAccountVC.swift
//  Points2Miles
//
//  Created by Arjav Lad on 14/04/18.
//

import UIKit
import SDWebImage

class MyAccountVC: UIViewController, PastTripsCollectionViewAdapterDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnEditProfilepicture: UIButton!
    @IBOutlet weak var btnSettings: UIBarButtonItem!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewProfileImage: UIView!
    @IBOutlet weak var viewProfileImageWithCornerRadius: UIView!
    @IBOutlet weak var viewPointsDetails: UIView!
    @IBOutlet weak var viewPointsDetailsWithCornerRadius: UIView!
    @IBOutlet weak var viewMilesWrapper: UIView!
    @IBOutlet weak var lblMilesValue: UILabel!
    @IBOutlet weak var lblMilesTitle: UILabel!
    @IBOutlet weak var viewPointsWrapper: UIView!
    @IBOutlet weak var lblPointsValue: UILabel!
    @IBOutlet weak var lblPointsTitle: UILabel!
    @IBOutlet weak var viewPastTripsWrapper: UIView!
    @IBOutlet weak var collectionPastTrips: UICollectionView!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var btnSave: UIBarButtonItem!
    @IBOutlet var btnCancel: UIBarButtonItem!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    
    var user:User!
    var selectedHotel:Trips?
    let pastTripsAdapter = PastTripsCollectionViewAdapter()
    let imagePickerVC = UIImagePickerController.init()
    let cropper = UIImageCropper.init(cropRatio: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        self.activityIndicator.isHidden = true
        self.scrollview.delegate = self
        
        if let user = NetworkServices.shared.loginSession?.user {
            self.user = user
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        
        if #available(iOS 11.0, *) {
            self.scrollview.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.setEditProfileMode(false)
        self.pastTripsAdapter.set(collectionview: self.collectionPastTrips)
        self.pastTripsAdapter.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupProfileView()
        self.setupPointsDetailsView()
        self.loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: - Class methods
    func setupProfileView() {
        // KEEP THIS CODE FOR REFERENCE
        //        self.viewProfileImage.layer.shadowColor = #colorLiteral(red: 0.09019607843, green: 0.1294117647, blue: 0.1490196078, alpha: 1)
        //        self.viewProfileImage.layer.shadowOffset = CGSize.init(width: 0, height: 10)
        //        self.viewProfileImage.layer.shadowRadius = 10
        //        self.viewProfileImage.layer.shadowOpacity = 0.7
        //        self.viewProfileImage.layer.shadowPath = UIBezierPath(roundedRect: self.viewProfileImage.bounds, cornerRadius: 45).cgPath
        //        self.viewProfileImage.layer.shouldRasterize = true
        //        self.viewProfileImage.layer.rasterizationScale = UIScreen.main.scale
        
        self.viewProfileImageWithCornerRadius.layer.borderColor = #colorLiteral(red: 0.2470588235, green: 0.8588235294, blue: 0.9529411765, alpha: 1)
        self.viewProfileImageWithCornerRadius.layer.borderWidth = 2.5
        self.viewProfileImageWithCornerRadius.layer.cornerRadius = 45
        self.viewProfileImageWithCornerRadius.clipsToBounds = true
        self.viewProfileImageWithCornerRadius.alpha = 0.5
        
        self.imgProfile.layer.cornerRadius = 43
        self.imgProfile.clipsToBounds = true
    }
    
    func setupPointsDetailsView() {
        // KEEP THIS CODE FOR REFERENCE
        //        self.viewPointsDetails.layer.shadowColor = #colorLiteral(red: 0.09019607843, green: 0.1294117647, blue: 0.1490196078, alpha: 1)
        //        self.viewPointsDetails.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        //        self.viewPointsDetails.layer.shadowRadius = 23
        //        self.viewPointsDetails.layer.shadowOpacity = 0.27
        //        self.viewPointsDetails.layer.shadowPath = UIBezierPath(roundedRect: self.viewPointsDetails.bounds, cornerRadius: 17.5).cgPath
        //        self.viewPointsDetails.layer.shouldRasterize = true
        //        self.viewPointsDetails.layer.rasterizationScale = UIScreen.main.scale
        self.viewPointsDetailsWithCornerRadius.layer.cornerRadius = 17.5
        self.viewPointsDetailsWithCornerRadius.clipsToBounds = true
    }

    func loadData() {
        self.setUserDetails()
        NetworkServices.shared.loginSession?.updateUserDetails ({
            DispatchQueue.main.async {
                if let user = NetworkServices.shared.loginSession?.user {
                    self.user = user
                    print("New Past trips: \(user.userTrips.count)")
                } else {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
                self.setUserDetails()
            }
        })
    }

    func setupPastTrips() {
        if let trips = NetworkServices.shared.loginSession?.user.userTrips {
            print("Past trips: \(trips.count)")
            self.pastTripsAdapter.loadData(with: trips)
            self.viewPastTripsWrapper.isHidden = trips.isEmpty
        } else {
            self.viewPastTripsWrapper.isHidden = true
        }
    }
    
    /// Turn On/Off Edit Profile Mode
    ///
    /// - Parameter turnOn: true / false
    func setEditProfileMode(_ turnOn: Bool) {
        if turnOn {
            self.navigationItem.leftBarButtonItem = self.btnCancel
            self.navigationItem.rightBarButtonItem = self.btnSave
            self.enableTextFields(true)
            self.txtFirstName.becomeFirstResponder()
        } else {
            self.navigationItem.leftBarButtonItem = self.btnBack
            self.navigationItem.rightBarButtonItem = self.btnSettings
            self.enableTextFields(false)
        }
        
    }
    
    func enableTextFields(_ enable: Bool) {
        if enable {
            self.lblName.isHidden = true
            self.txtFirstName.isHidden = false
            self.txtLastName.isHidden = false
            self.txtEmail.placeholder = "email"
            self.txtFirstName.placeholder = "first name"
            self.txtLastName.placeholder = "last name"
            self.txtFirstName.isUserInteractionEnabled = true
            self.txtEmail.isUserInteractionEnabled = true
            self.txtLastName.isUserInteractionEnabled = true
        } else {
            self.lblName.isHidden = false
            self.txtFirstName.isHidden = true
            self.txtLastName.isHidden = true
            self.txtEmail.placeholder = ""
            self.txtFirstName.placeholder = ""
            self.txtLastName.placeholder = ""
            self.txtFirstName.isUserInteractionEnabled = false
            self.txtLastName.isUserInteractionEnabled = false
            self.txtEmail.isUserInteractionEnabled = false
            self.txtFirstName.resignFirstResponder()
            self.txtLastName.resignFirstResponder()
            self.txtEmail.resignFirstResponder()
        }
    }
    
    func setUserDetails() {
        self.txtFirstName.text = self.user.firstName
        self.txtLastName.text = self.user.lastName
        self.lblName.text = self.user.firstName + " " + self.user.lastName
        self.txtEmail.text = self.user.email
        self.imgProfile.sd_setImage(with: self.user.profilePicture) { (image, _, _, _) in
            if let image = image {
                self.imgProfile.image = image
                let size = image.size
                if size.width / size.height == 1 {
                    self.imgProfile.contentMode = .scaleAspectFit
                } else {
                    self.imgProfile.contentMode = .scaleAspectFill
                }
            } else {
                self.imgProfile.image = #imageLiteral(resourceName: "placeholderProfileImage")
            }
        }
        
        let totalMiles: Double = self.user.userTrips.reduce(0, { result, nextTrip in
            result + nextTrip.distance
        })
        self.lblMilesValue.text = totalMiles.formattedString
        
        let totalPoints: Double = self.user.userTrips.reduce(0, { result, nextTrip in
            if nextTrip.convertToRewardsPoint().status == RewardsPointStatus.approved {
                return result + nextTrip.rewardPoints
            }
            return result
        })
        self.lblPointsValue.text = totalPoints.formattedString
        self.setupPastTrips()
    }
    
    func validateInputData() -> NetworkServicesModels.user.request? {
        var allValid = true
        var request = NetworkServicesModels.user.request.init(userid: self.user.userId, email: "", firstName: "", lastName: "")
        if let fName = self.txtFirstName.text?.trimString(),
            fName != "" {
            request.firstName = fName
        } else {
            allValid = false
            self.showAlert("Required!", message: "First name is required!") { (_) in
                self.txtFirstName.becomeFirstResponder()
            }
        }
        
        if let lName = self.txtLastName.text?.trimString(),
            lName != "" {
            request.lastName = lName
        } else {
            allValid = false
            self.showAlert("Required!", message: "Last name is required!") { (_) in
                self.txtLastName.becomeFirstResponder()
            }
        }
        
        if let email = self.txtEmail.text?.trimString(),
            email.isValidEmail() {
            request.email = email
        } else {
            allValid = false
            self.showAlert("Required!", message: "A valid email is required!") { (_) in
                self.txtEmail.becomeFirstResponder()
            }
        }
        if allValid {
            return request
        } else {
            return nil
        }
    }
    
    func uploadProfileImage(_ image: UIImage) {
        self.imgProfile.image = image
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        let request = NetworkServicesModels.userProfileImage.request.init(userid: self.user.userId, image: image)
        NetworkServices.shared.updateProfileImage(with: request) { (user, error) in
            self.activityIndicator.stopAnimating()
            if let user = user {
                self.user = user
                self.setUserDetails()
            } else {
                if let error = error {
                    self.showAlert("Error!", message: error.localizedDescription)
                } else {
                    self.showAlert(nil, message: "Upload failed!")
                }
            }
        }
    }
    
    //MARK: - Action methods
    @IBAction func onBackTap(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSettingsTap(_ sender: UIBarButtonItem) {
        let actionHandler: ((UIAlertAction, Int) -> Void) = { (action, index) in
            if index == 0 {
                self.setEditProfileMode(true)
            } else if index == 1 {
                self.performSegue(withIdentifier: "ViewAllPastTrips", sender: self)
            } else if index == 2 {
                self.performSegue(withIdentifier: "segueShowRewardPointsVC", sender: nil)
            } else if index == 3 {
                NetworkServices.shared.loginSession?.logout {
                    print("Logged out")
                }
                self.performSegue(withIdentifier: "segueShowSignupVC", sender: nil)
            } else {
                assertionFailure("This is wrong!!")
            }
        }
        self.showActionSheet(nil, message: nil, actionTitles: [
            ("Edit Profile", UIAlertActionStyle.default),
            ("Past Trips", UIAlertActionStyle.default),
            ("Rewards Points History", UIAlertActionStyle.default),
            ("Logout", UIAlertActionStyle.destructive)
            ], cancelTitle: "Cancel", actionHandler: actionHandler, cancelActionHandler: nil)
    }
    
    @IBAction func onEditProfilepictureTap(_ sender: UIButton) {
        self.imagePickerVC.navigationBar.tintColor = #colorLiteral(red: 0.3215686275, green: 0.3803921569, blue: 0.4392156863, alpha: 1)
        self.imagePickerVC.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3215686275, green: 0.3803921569, blue: 0.4392156863, alpha: 1)
        self.cropper.picker = self.imagePickerVC
        self.cropper.delegate = self
        self.cropper.cancelButtonText = "cancel"
        self.cropper.cropButtonText = "done"
        self.cropper.view.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.3803921569, blue: 0.4392156863, alpha: 1)
        self.present(self.imagePickerVC, animated: true, completion: nil)
    }
    
    @IBAction func onCancelTap(_ sender: UIBarButtonItem) {
        self.setUserDetails()
        self.setEditProfileMode(false)
    }
    
    @IBAction func onSaveTap(_ sender: UIBarButtonItem) {
        if let apiRequest = self.validateInputData() {
            self.setEditProfileMode(false)
            self.lblName.text = apiRequest.firstName + " " + apiRequest.lastName
            NetworkServices.shared.updateUserDetails(request: apiRequest) { (user, error) in
                if let user = user {
                    self.user = user
                    self.setUserDetails()
                } else {
                    if let error = error {
                        self.showAlert("Error!", message: error.localizedDescription)
                    } else {
                        self.showAlert("Error!", message: "Request Failed!")
                    }
                }
            }
        }
    }
    
    @IBAction func onViewAllPastTripsTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ViewAllPastTrips", sender: self)
    }
    
    //MARK: - PastTripsCollectionViewAdapter delegate method
    func selectedHotel(objHotel: Trips) {
        self.selectedHotel = objHotel
        self.performSegue(withIdentifier:"segueShowPastTripDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController , let hotelVC = nav.topViewController as? PastTripDetailVC {
            hotelVC.hotelsDetail = self.selectedHotel
        }
    }
    
}

extension MyAccountVC: UIImageCropperProtocol {
    //MARK: - ImagePicker Delegate
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        if let image = croppedImage {
            self.uploadProfileImage(image)
        } else {
            assertionFailure("Wrong type of image selected")
        }
    }
}


extension MyAccountVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screenHeight = self.view.frame.height
        let currentOffsetY: CGFloat = scrollview.contentOffset.y
        let colorOpacity = (10000*currentOffsetY) / (27*screenHeight)
        self.navigationController?.navigationBar.alpha = 1-(colorOpacity/100)
    }
}
