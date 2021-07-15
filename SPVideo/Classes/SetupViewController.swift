//
//  SetupViewController.swift
//  SampleFramework
//
//  Created by Gowthaman G on 04/07/21.
//

import UIKit
import AVKit


public class SetupViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    internal var username : String!
    internal var cameraPos : String!
    internal var flow : MeetingFlow!
    internal var headphonesConnected : Bool!
    var setupViewModel: SetupViewModel!{
        didSet{
            tableview_options.dataSource = self
            tableview_options.delegate = self
        }
    }
    
    
    @IBOutlet weak var uiview_permission_denied: UIView!{
        didSet{
            let tap = UITapGestureRecognizer(target: self, action: #selector(navigateToSettings(_:)))
            uiview_permission_denied.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var uiview_camera: UIView!{
        didSet {
            
            Utilities.applyBorder(on: uiview_camera)
            let tap = UITapGestureRecognizer(target: self, action: #selector(showCameraOptions(_:)))
            uiview_camera.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var uiview_mic: UIView!{
        didSet {
            //setupViewModel = SetupViewModel(SetupConstants.videoOptions, tableview_options)
            Utilities.applyBorder(on: uiview_mic)
            let tap = UITapGestureRecognizer(target: self, action: #selector(showAudioOptions(_:)))
            uiview_mic.addGestureRecognizer(tap)
            
        }
    }
    
    @IBOutlet weak var uibutton_mic: UIButton!
    @IBOutlet weak var uibutton_camera: UIButton!
    @IBOutlet weak var label_camera_option: UILabel!
    @IBOutlet weak var label_audio_option: UILabel!
    
    @IBOutlet weak var button_join: UIButton!{
        didSet{
            Utilities.drawCornerView(on: button_join as Any)
        }
    }
    
    @IBOutlet weak var uibutton_cancel: UIButton!{
        didSet{
            Utilities.drawCornerView(on: uibutton_cancel as Any)
        }
    }
    @IBOutlet weak var tableview_options: UITableView!{
        didSet{
            Utilities.drawCornerView(on: tableview_options as Any)
            let bundle = Bundle(identifier: Constants.bundleId)
            tableview_options.register(UINib(nibName: ViewControllers.setupcell, bundle: bundle), forCellReuseIdentifier: ViewControllers.setupcell)
            
        }
    }
    @IBOutlet weak var uiview_options: UIView!
    @IBOutlet weak var uibutton_name: UIButton!{
        didSet{
            uibutton_name.setTitle("", for: .normal)
            
           // uibutton_name.setBackgroundImage(UIImage(named: "ic_empty_username"), for: .normal)
            uibutton_name.setBackgroundImage(UIImage(named: "ic_empty_username", in: Bundle(for: StarRateView.self), compatibleWith: nil), for: .normal)
//            @IBInspectable
//            var emptyImage = UIImage(named: "ic_star_empty", in: Bundle(for: StarRateView.self), compatibleWith: nil)
//            uibutton_name.isHidden = true
//            var initials = ""
//            if let initialsArray = username?.components(separatedBy: " ") {
//                if let firstWord = initialsArray.first {
//                    if let firstLetter = firstWord.first {
//                        initials += String(firstLetter).capitalized }
//                }
//                if initialsArray.count > 1, let lastWord = initialsArray.last {
//                    if let lastLetter = lastWord.first { initials += String(lastLetter).capitalized
//                    }
//                }
//            }
//            uibutton_name.setTitle(initials, for: .normal)
        }
    }
    @IBOutlet weak var uiview_transparent: UIView!
    @IBOutlet private weak var cameraPreview: UIView!{
        didSet {
            cameraPreview.isHidden = false
        }
    }
    
    @IBOutlet weak var uiscrollview_user_view: UIScrollView!
    @IBOutlet weak var uiview_guest_user: UIView!
    @IBOutlet weak var uitextfield_guest_name: UITextField!
    
    @IBOutlet weak var uitextfield_guest_message: UITextField!
    
    @IBOutlet weak var uiview_scroll_contentview: UIView!
    
    @IBOutlet weak var scrollview_options: UIScrollView!{
        didSet{
            scrollview_options.delegate = self
        }
    }
    
    @IBOutlet weak var constraint_tableview_options: NSLayoutConstraint!
    
    @IBOutlet weak var constraint_top_scroll_content: NSLayoutConstraint!
    @IBOutlet weak var constraint_guest_uiview: NSLayoutConstraint!
    
    private var session: AVCaptureSession?
    private var input: AVCaptureDeviceInput?
    private var output: AVCapturePhotoOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    private var meetStatus : Int = 0
    
    
    // MARK: - View Lifecycle
   public override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel = SetupViewModel(SetupConstants.videoOptions, tableview_options)
        
        setupViewModel.getMeetingPrivacy()
        
        UserDefaults.standard.set(true, forKey: Constants.publishAudio)
        UserDefaults.standard.set(true, forKey: Constants.publishVideo)
        
        checkPermissions()
        observerContent()
        
     
    }
    
   public override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar(animated: animated)
        
        initViews()
        
        print(#function,"SetupViewController")
        if uibutton_name.isHidden == false{
            uibutton_name.isHidden = true
        }
        if cameraPreview.isHidden == true{
            cameraPreview.isHidden = false
        }
        
        setupVideoPreview()
    }
    
   public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
   public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if UserDefaults.standard.value(forKey: Constants.role) as! String == "Host" {
            if scrollview_options.contentOffset.y > 0 || scrollview_options.contentOffset.y < 0 {
               scrollview_options.contentOffset.y = 0
            }
        }
         
      }
    
    private func checkPermissions(){
        AVCaptureDevice.authorizeVideo(completion: { (status) in
           print("Video status is\(status)")
            if status == AVCaptureDevice.AuthorizationStatus.alreadyAuthorized || status == AVCaptureDevice.AuthorizationStatus.justAuthorized {
                self.uiview_permission_denied.isHidden = true
                self.uiview_camera.isUserInteractionEnabled = true
                self.uiview_mic.isUserInteractionEnabled = true
                self.button_join.isUserInteractionEnabled = true
            }else{
                self.uiview_permission_denied.isHidden = false
                self.uiview_camera.isUserInteractionEnabled = false
                self.uiview_mic.isUserInteractionEnabled = false
                self.button_join.isUserInteractionEnabled = false
            }
        })
        
        AVCaptureDevice.authorizeAudio(completion: { (status) in
           print("Audio status is\(status)")
            if status == AVCaptureDevice.AuthorizationStatus.alreadyAuthorized || status == AVCaptureDevice.AuthorizationStatus.justAuthorized {
                self.uiview_permission_denied.isHidden = true
                self.uiview_camera.isUserInteractionEnabled = true
                self.uiview_mic.isUserInteractionEnabled = true
                self.button_join.isUserInteractionEnabled = true
            }else{
                
                self.uiview_permission_denied.isHidden = false
                self.uiview_camera.isUserInteractionEnabled = false
                self.uiview_mic.isUserInteractionEnabled = false
                self.button_join.isUserInteractionEnabled = false
            }
        })
    }
    
    func initViews(){
        self.scrollview_options.contentSize.height = 1.0
        uiview_guest_user.isHidden = true
        constraint_top_scroll_content.constant = 50
        constraint_guest_uiview.constant = 1 - (2.8 * self.uiview_mic.frame.size.height)
//        if UserDefaults.standard.value(forKey: Constants.role) as! String == "Host"{
//            self.scrollview_options.contentSize.height = 1.0
//            uiview_guest_user.isHidden = true
//            constraint_top_scroll_content.constant = 50
//            constraint_guest_uiview.constant = 1 - (2.8 * self.uiview_mic.frame.size.height)
//        }else{
//
//            uibutton_name.setBackgroundImage(UIImage(named: "ic_empty_username"), for: .normal)
//            constraint_top_scroll_content.constant = 0
//            uiview_guest_user.isHidden = false
//            constraint_guest_uiview.constant = 0
//        }
        
        if let flowRawValue = UserDefaults.standard.object(forKey: Constants.flow) as? String {
            let flowVal = MeetingFlow(rawValue: flowRawValue)!
            self.flow = flowVal
        }
        
        let route = AVAudioSession.sharedInstance().currentRoute
        for port in route.outputs {
            if port.portType == AVAudioSession.Port.headphones {
                print("Headphones  located")
               headphonesConnected = true
            }else{
                print("Headphones not located")
                headphonesConnected = false
            }
        }
    }
    
    
    private func useData(data: String) {
          print("data is \(data)")
      }
    
   public override func viewDidLayoutSubviews() {
        Utilities.drawCircle(on: uibutton_name)
    }
    
   public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        uiscrollview_user_view.contentSize.height =  uiview_scroll_contentview.frame.size.height + 200
    }
    
    func observerContent() {
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChangeListener(notification:)), name: AVAudioSession.routeChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openedAgain), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getMeetingPrivacy(notification:)), name: Notification.Name("MeetPrivacy"), object: nil)

    }
    
    @objc func openedAgain() {
        print(#function,"called")
        setupVideoPreview()
    }
    @objc func getMeetingPrivacy(notification: Notification){
        DispatchQueue.main.async {
            if let status = notification.userInfo?["Status"] as? Int {
                print("Meeting status is \(status)")
                if status == 1{
                    //self.showToast(message: "Current meeting is private")
                }else{
                    //self.showToast(message: "It's open meeting")
                }
                self.meetStatus = status
                
            }else{
                self.presentAlert("Meeting Id is invalid")
            }
        }
        
    }

    @objc func willResignActive() {
        
        let inputs = session!.inputs
        for oldInput:AVCaptureInput in inputs {
            session!.removeInput(oldInput)
        }
    }
    
    //MARK: tapgesture calls
    
    @objc func showCameraOptions(_ sender: UITapGestureRecognizer){
        print(#function,"size is \(self.constraint_tableview_options.constant)")
        
        self.constraint_tableview_options.constant = -50
        setupViewModel = SetupViewModel(SetupConstants.videoOptions, tableview_options)
        tableview_options.reloadData()
        self.uiview_transparent.isHidden = false
        self.uiview_options.isHidden = false
        
    }
    
    @objc func showAudioOptions(_ sender: UITapGestureRecognizer){
        self.constraint_tableview_options.constant = 10
        
        setupViewModel = SetupViewModel(SetupConstants.audioOptions, tableview_options)
        tableview_options.reloadData()
        self.uiview_transparent.isHidden = false
        self.uiview_options.isHidden = false
        
    }
    
    @objc func navigateToSettings(_ sender: UITapGestureRecognizer){
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    @objc private func audioRouteChangeListener(notification: Notification) {
        let rawReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        let reason = AVAudioSession.RouteChangeReason(rawValue: rawReason)!

        switch reason {
        case .newDeviceAvailable:
            print("headphone plugged in")
            self.headphonesConnected = true
        case .oldDeviceUnavailable:
            print("headphone pulled out")
            self.headphonesConnected = false
        default:
            break
        }
    }
    
    //MARK: Button clicks

    @IBAction func cancelPressed(_ sender: UIButton) {
        self.uiview_transparent.isHidden = true
        self.uiview_options.isHidden = true
        tableview_options.layoutIfNeeded()
    }
    
    @IBAction func micPressed(_ sender: UIButton) {
        AVAudioSession.sharedInstance().requestRecordPermission { _ in }
        UserDefaults.standard.set(sender.isSelected, forKey: Constants.publishAudio)
        sender.isSelected = !sender.isSelected
        
    }
    
    @IBAction func videoPressed(_ sender: UIButton) {
        
        UserDefaults.standard.set(sender.isSelected, forKey: Constants.publishVideo)
        sender.isSelected = !sender.isSelected

        if let session = session {
            if sender.isSelected {
                if session.isRunning {
                    session.stopRunning()
                    previewLayer?.removeFromSuperlayer()
                    self.uibutton_name.isHidden = false
                    self.cameraPreview.isHidden = true
                }else{
                    print(#function,"else called")
                }
            } else {
                if !session.isRunning {
                    session.startRunning()
                    self.uibutton_name.isHidden = true
                    self.cameraPreview.isHidden = false
                    cameraPreview.layer.addSublayer(previewLayer ?? CALayer())
                }else{
                    print(#function,"else of else called")
                }
            }
        }
    }
    
    @IBAction func joinRoomPressed(_ sender: UIButton) {
        let bundle = Bundle(identifier: Constants.bundleId)
        let viewController = UIStoryboard(name: Constants.meeting, bundle: bundle).instantiateInitialViewController() as? MeetingViewController
        viewController?.flow = self.flow
        viewController?.cameraPos = UserDefaults.standard.value(forKey: Constants.cameraPos) as? String
        
        // Create and add the view to the screen.
        
        
        self.uiview_transparent.isHidden = false
        let indicatorView = IndicatorView(text: "Joining Room")
        self.view.addSubview(indicatorView)
        //self.view.backgroundColor = UIColor.black
 
        
        RoomService.joinRoom(UserDefaults.standard.value(forKey: Constants().meetingId) as! String, UserDefaults.standard.value(forKey: Constants().token) as? String, completion: {lockedVal,error,roomData in
            if let roomData = roomData{
                DispatchQueue.main.async {
                    self.saveData(roomData)
                    self.uiview_transparent.isHidden = true
                    indicatorView.hide()
                    self.navigationController?.pushViewController(viewController!, animated: true)
                    self.cleanUp()
                }
            
            }
            if let lockedVal = lockedVal{
                print(#function,"lockedVal is \(lockedVal)")
            }
            if let err = error{
                print(#function,"err is \(err)")
                DispatchQueue.main.async {
                    self.presentAlert(err)
                    self.uiview_transparent.isHidden = true
                    indicatorView.hide()
                }
                
            }
        })
    }
    
    func saveData(_ roomData: RoomData){
        self.username = roomData.username
        Constants.agora_appID = roomData.chatAppId
        Constants.agora_temp_token = roomData.chatToken
        RoomConstants.managementToken = roomData.callToken
        UserDefaults.standard.setValue(roomData.token, forKey: Constants.mid)
        UserDefaults.standard.setValue(roomData.room, forKey: RoomConstants.roomIDKey)
        UserDefaults.standard.setValue(roomData.callToken, forKey: RoomConstants.tokenKey)
        UserDefaults.standard.setValue(roomData.username, forKey: Constants.defaultName)
        UserDefaults.standard.setValue(roomData.teamName, forKey: Constants.roomName)
        
        Utilities().segmenEvent("Join the call", ["RoomName": roomData.teamName as String,"Room Id": roomData.room as String, "Token": roomData.callToken as String])
    }
        
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
    
    //MARK: CleanupViews
    private func cleanUp(){
        self.uitextfield_guest_name.text = ""
        self.uitextfield_guest_message.text = ""
        if uibutton_name.isHidden == false{
            uibutton_name.isHidden = true
        }
        if uibutton_camera.isSelected == true{
            uibutton_camera.isSelected = false
        }
        if uibutton_mic.isSelected == true{
            uibutton_mic.isSelected = false
        }
    }
    
    
    //MARK: Setup Preview
    
    private func setupVideoPreview() {

        session = AVCaptureSession()
        output = AVCapturePhotoOutput()
        var position = AVCaptureDevice.Position.back
        if let pos = UserDefaults.standard.value(forKey: Constants.cameraPos){
            if pos as! String == "front"{
                position = AVCaptureDevice.Position.front
            }
        }
        
        if let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) {
            do {
                input = try AVCaptureDeviceInput(device: camera)
            } catch let error as NSError {
                print(error)
                input = nil
            }

            guard let input = input, let output = output, let session = session else { return }

            if session.canAddInput(input) {
                session.addInput(input)

                if session.canAddOutput(output) {
                    session.addOutput(output)
                }

                let settings = AVCapturePhotoSettings()
                let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!

                let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                                     kCVPixelBufferWidthKey as String: view.frame.size.width,
                                     kCVPixelBufferHeightKey as String: view.frame.size.height] as [String: Any]
                settings.previewPhotoFormat = previewFormat

                output.capturePhoto(with: settings, delegate: self)
//                if UserDefaults.standard.bool(forKey: Constants.publishVideo) == true{
//                    session.stopRunning()
//                }
            }
        }
    }

    private func updateCameraView() {
        let orientation = UIApplication.shared.statusBarOrientation
        let videoOrientation = AVCaptureVideoOrientation(rawValue: orientation.rawValue) ?? .portrait
        previewLayer?.connection?.videoOrientation = videoOrientation
        previewLayer?.frame = cameraPreview.bounds
    }
    
    func presentAlert(_ message: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        present(alertController, animated: true, completion: nil)
    }
    
    func changeCameraPosition(_ pos : String){
        UserDefaults.standard.setValue(pos, forKey: Constants.cameraPos)
        if let session = session {
            guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
                return
            }
            session.beginConfiguration()
            session.removeInput(currentCameraInput)
            
            //Get new input
            var newCamera: AVCaptureDevice! = nil
            if currentCameraInput is AVCaptureDeviceInput {
                if pos == "front"{
                   newCamera = cameraWithPosition(position: .front)
                }else{
                    newCamera = cameraWithPosition(position: .back)
                }
            }
            var err: NSError?
            var newVideoInput: AVCaptureDeviceInput!
            do {
                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            } catch let err1 as NSError {
                err = err1
                newVideoInput = nil
            }
            
            if newVideoInput == nil || err != nil {
                print("Error creating capture device input: \(err?.localizedDescription ?? "")")
            } else {
                session.addInput(newVideoInput)
            }
            session.commitConfiguration()
        }
    }
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }

        return nil
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setupViewModel.options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllers.setupcell) as! SetupOptionsTableViewCell
        cell.label_option.text = setupViewModel.options[indexPath.row]
        if self.headphonesConnected == false {
            if (cell.label_option.text?.contains("Headset"))! {
                cell.label_option.isEnabled = false
                cell.label_option.isUserInteractionEnabled = false
            }else{
               cell.label_option.isEnabled = true
                cell.label_option.isUserInteractionEnabled = true
            }
        }else{
            cell.label_option.isEnabled = true
            cell.label_option.isUserInteractionEnabled = true
        }
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.uiview_transparent.isHidden = true
        if self.uiview_options.isHidden == false{
            self.uiview_options.isHidden = true
        }
        
        if setupViewModel.options[indexPath.row].contains("camera"){
            label_camera_option.text = setupViewModel.options[indexPath.row]
            if setupViewModel.options[indexPath.row].contains("front"){
              self.changeCameraPosition("front")
                //self.cameraPos = "front"
            }else{
//                self.cameraPos = "back"
                self.changeCameraPosition("back")
            }
        }else if setupViewModel.options[indexPath.row].contains("Headset"){
            if self.headphonesConnected == true{
                label_audio_option.text = setupViewModel.options[indexPath.row]
            }
        }
        else{
            label_audio_option.text = setupViewModel.options[indexPath.row]
        }
    }
}

@available(iOS 11.0, *)
extension SetupViewController: AVCapturePhotoCaptureDelegate {

   public func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {

        if let session = session {
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.videoGravity = .resizeAspectFill
            updateCameraView()
            cameraPreview.layer.addSublayer(previewLayer!)
            session.startRunning()
        }
    }
   
    
    
    
}
