//
//  MeetingViewController.swift
//  SampleFramework
//
//  Created by Gowthaman G on 04/07/21.
//

import UIKit
import HMSVideo
import MediaPlayer
import AVFoundation
import MessageUI

public class MeetingViewController: UIViewController {

    internal var user: String!
    internal var roomName: String!
    internal var flow: MeetingFlow!
    internal var cameraPos : String!
    internal var isVideo : Bool = true
    internal var isAudio : Bool = true
    
    private var viewModel: MeetingViewModel!
    var audioPlayer: AVAudioPlayer?
    lazy var list = [MessageChat]()
    internal var ratingValue = 0
    var displayName : String!
    
    
    @IBOutlet private weak var label_roomName: UILabel! {
        didSet {
            roomName = UserDefaults.standard.string(forKey: Constants.roomName)
            user = UserDefaults.standard.string(forKey: Constants.defaultName)
            label_roomName.text = roomName
        }
    }
    @IBOutlet weak var label_timer: UILabel!{
        didSet{
            Utilities.drawCornerView(on: label_timer as Any)
            label_timer.text = "00:00"
            label_timer.isHidden = true
        }
    }
    @IBOutlet private weak var collectionView: UICollectionView!

    //@IBOutlet private weak var badgeButton: BadgeButton!

    @IBOutlet private weak var publishVideoButton: UIButton! {
        didSet {
            if UserDefaults.standard.object(forKey: Constants.publishVideo) as! Bool == false{
                isVideo = false
                UserDefaults.standard.set(true, forKey: Constants.publishVideo)
            }
            
            if let publishVideo = UserDefaults.standard.object(forKey: Constants.publishVideo) as? Bool {
                publishVideoButton.isSelected = !publishVideo
            } else {
                publishVideoButton.isSelected = false
            }
        }
    }

    @IBOutlet private weak var publishAudioButton: UIButton! {
        didSet {
            if UserDefaults.standard.object(forKey: Constants.publishAudio) as! Bool == false{
                isAudio = false
                UserDefaults.standard.set(true, forKey: Constants.publishAudio)
            }
            if let publishAudio = UserDefaults.standard.object(forKey: Constants.publishAudio) as? Bool {
                publishAudioButton.isSelected = !publishAudio
            } else {
                publishAudioButton.isSelected = false
            }
        }
    }
    //MARK: Invite UI
    
    @IBOutlet weak var uiview_invite: UIView!{
        didSet{
            uiview_invite.isHidden = true
            Utilities.drawCornerView(on: uiview_invite as UIView)
        }
    }
    @IBOutlet weak var uiview_invite_link: UIView!{
        didSet{
            Utilities.applyBorder(on: uiview_invite_link)
        }
    }
    @IBOutlet weak var uibutton_invite_ok: UIButton!{
        didSet{
            Utilities.drawCornerView(on: uibutton_invite_ok as UIButton)
        }
        
    }
    
    @IBOutlet weak var uitextview_sharable_link: UILabel!
    
  // MARK: MORE option
    @IBOutlet weak var uiview_more_options: UIView!{
        didSet{
            uiview_more_options.isHidden = true
        }
    }
    
    @IBOutlet weak var uiview_more_options_subview: UIView!{
        didSet{
            Utilities.drawCornerView(on: uiview_more_options_subview as UIView)
        }
    }
    
    @IBOutlet weak var uibutton_more_options_cancel: UIButton!{
        didSet{
            Utilities.drawCornerView(on: uibutton_more_options_cancel as UIButton)
        }
    }
    
    @IBOutlet weak var uiview_transparent: UIView!{
        didSet{
            uiview_transparent.isHidden = true
        }
    }
    // MARK: Help View
    @IBOutlet weak var uiview_help: UIView!{
        didSet{
            Utilities.drawCornerView(on: uiview_help as UIView)
            uiview_help.isHidden = true
        }
    }
    
    @IBOutlet weak var uiview_refresh: UIView!{
        didSet{
            Utilities.applyBorder(on: uiview_refresh)
        }
    }
    
    @IBOutlet weak var uiview_sound_check: UIView!{
        didSet{
            Utilities.applyBorder(on: uiview_sound_check)
        }
    }
    
    @IBOutlet weak var uiview_connectivity_check: UIView!{
        didSet{
            Utilities.applyBorder(on: uiview_connectivity_check)
        }
    }
    
    
    @IBOutlet weak var uibutton_play_view: UIButton!{
        didSet{
            uibutton_play_view.isHidden = true
        }
    }
    
    
    @IBOutlet weak var uiview_audio_question: UIView!{
        didSet{
            uiview_audio_question.isHidden = true
        }
    }
    @IBOutlet weak var label_audio_yes: UILabel!{
       didSet{
            label_audio_yes.isHidden = true
        }
    }
    
    
    @IBOutlet weak var uiview_audio_no: UIView!{
        didSet{
            uiview_audio_no.isHidden = true
        }
    }
    
    
    @IBOutlet weak var uilabel_connection_status: UILabel!{
        didSet{
           uilabel_connection_status.isHidden = true
        }
    }
    
    // MARK: chat view
    @IBOutlet weak var uiview_chat: UIView!{
        didSet{
            uiview_chat.isHidden = true
        }
    }
    @IBOutlet weak var uiview_chat_empty: UIView!
    
    @IBOutlet weak var uiview_chat_message: UIView!{
        didSet{
            Utilities.applyBorder(on: uiview_chat_message)
        }
    }
    @IBOutlet weak var uitextfield_chat_message: UITextField!
    
    
    @IBOutlet weak var tableview_chat_message: UITableView!{
        didSet{
            let bundle = Bundle(identifier: Constants.bundleId)
            tableview_chat_message.register(UINib(nibName: ViewControllers.chatmessageCell, bundle: bundle), forCellReuseIdentifier: ViewControllers.chatmessageCell)
            tableview_chat_message.delegate = self
            tableview_chat_message.dataSource = self
            
            tableview_chat_message.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        }
    }
    
    
    @IBOutlet weak var constraint_chat_message_bottom: NSLayoutConstraint!
    
    @IBOutlet weak var constraint_feedback_bottom: NSLayoutConstraint!
    
    
    //MARK:feedback view
    @IBOutlet weak var uiview_rate_feedback: UIView!{
        didSet{
            uiview_rate_feedback.isHidden = true
        }
    }
    @IBOutlet weak var uiview_star_rating: StarRateView!{
        didSet{
            uiview_star_rating.delegate = self
            uiview_star_rating.ratingValue = -1
        }
    }
    
    @IBOutlet weak var uitextview_feedback_text: UITextView!{
        didSet{
            //uitextview_feedback_text.placeholder = "Additional comments.."
            let color = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
            uitextview_feedback_text.layer.borderColor = color
            uitextview_feedback_text.layer.borderWidth = 0.5
            uitextview_feedback_text.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var uibutton_feedback_submit: UIButton!{
        didSet{
            Utilities.drawCornerView(on: uibutton_feedback_submit as Any)
        }
    }
    
    
    @IBOutlet weak var uilabel_username: UILabel!{
        didSet{
            uilabel_username.text = UserDefaults.standard.object(forKey: Constants.defaultName) as? String
        }
    }
    
    
    private var chatBadgeCount = 0
    var counter = 0
    var timer = Timer()
    
    // MARK: - View Lifecycle

   public override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isIdleTimerDisabled = true

        viewModel = MeetingViewModel(self.user, UserDefaults.standard.string(forKey: RoomConstants.roomIDKey)!, flow, collectionView,cameraPos)
        addKeyboardObserver()
        
       
      
    }
    
    func addKeyboardObserver() {
        handleError()
        observeBroadcast()
        startTimer()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFrameWillChange(notification:)),
                                               name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    @objc func keyboardFrameWillChange(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
//        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIKit.UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIKit.UIView.AnimationOptions(rawValue: animationCurveRaw)
        print(#function,"Endframe val is \(endFrameY) screen height is \(UIScreen.main.bounds.size.height)")
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            if uiview_rate_feedback.isHidden == false{
                self.constraint_feedback_bottom?.constant = 0.0
            }else{
                self.constraint_chat_message_bottom?.constant = 0.0
            }
            
            
        } else {
            if uiview_rate_feedback.isHidden == false{
                self.constraint_feedback_bottom?.constant = endFrame?.size.height ?? 0.0
            }else{
                self.constraint_chat_message_bottom?.constant = endFrame?.size.height ?? 0.0
            }
            
        }
        
        UIKit.UIView.animate(
            withDuration: 0.1,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { },
            completion: nil)
    }
    

   public override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent {
            UIApplication.shared.isIdleTimerDisabled = false
            viewModel.cleanup()
        }
        view.endEditing(true)
    }
    
   public override func viewDidDisappear(_ animated: Bool) {
        viewModel.cleanup()
    }
    
    
   public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func hideKeyboard() {
      view.endEditing(true)
    }
    

    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
    }
    
    // MARK: - Action Handlers

    private func handleError() {
        _ = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: RoomConstants.hmsError),
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in

            let message = notification.userInfo?["error"] as? String ?? "Client Error!"

            print("Error: ", message)

            if let presentedVC = self?.presentedViewController {
                presentedVC.dismiss(animated: true) {
                    self?.presentAlert(message,"Error - Connection lost")
                }
                return
            }

            self?.presentAlert(message,"Error - Connection lost")
        }
    }

    func presentAlert(_ message: String, _ title: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .default,handler: { (action: UIAlertAction!) in
            if title == "Error - Connection lost"{
                self.navigationController?.popViewController(animated: true)
                
            }
            
            }))

        present(alertController, animated: true, completion: nil)
    }
    

    private func observeBroadcast() {
        
        _ = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "loaded"),
                                                   object: nil,
                                                   queue: .main) { [weak self] _ in
            print("Loaded Called now")
            if let strongSelf = self {
                if !strongSelf.isVideo{
                    UserDefaults.standard.set(strongSelf.isVideo, forKey: Constants.publishVideo)
                    strongSelf.viewModel.switchVideo(isOn: strongSelf.isVideo)
                    strongSelf.publishVideoButton.isSelected = !strongSelf.isVideo
                }
                
                if !strongSelf.isAudio{
                    UserDefaults.standard.set(strongSelf.isAudio, forKey: Constants.publishAudio)
                    strongSelf.viewModel.switchAudio(isOn: strongSelf.isAudio)
                    strongSelf.publishAudioButton.isSelected = !strongSelf.isAudio
                }
                
                if strongSelf.cameraPos == "back"{
                    strongSelf.viewModel.switchCamera()
                }
                
            }
        }
        
        _ = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: RoomConstants.feedbackSent),
                                                   object: nil,
                                                   queue: .main) { [weak self] _ in
            if let strongSelf = self {
                strongSelf.showToast(message: "Thanks for your valuable feedback.")
                strongSelf.uiview_rate_feedback.isHidden = true
                strongSelf.navigationController?.popViewController(animated: true)
                
                
            }
        }
        
        _ = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: RoomConstants.hmsError),
                                                   object: nil,
                                                   queue: .main) { [weak self] _ in
            if let strongSelf = self {
                if !strongSelf.isVideo{
                    UserDefaults.standard.set(strongSelf.isVideo, forKey: Constants.publishVideo)
                    strongSelf.viewModel.switchVideo(isOn: strongSelf.isVideo)
                    strongSelf.publishVideoButton.isSelected = !strongSelf.isVideo
                }
                
                if !strongSelf.isAudio{
                    UserDefaults.standard.set(strongSelf.isAudio, forKey: Constants.publishAudio)
                    strongSelf.viewModel.switchAudio(isOn: strongSelf.isAudio)
                    strongSelf.publishAudioButton.isSelected = !strongSelf.isAudio
                }
                
                if strongSelf.cameraPos == "back"{
                    strongSelf.viewModel.switchCamera()
                }
                
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getReceivedMessage(_:)), name: NSNotification.Name(rawValue: RoomConstants.broadcastReceived), object: nil)
    }
    
    @objc func getReceivedMessage(_ notification: NSNotification){
        if let dict = notification.userInfo as NSDictionary? {
            if let message = dict["message"] as? String  {
                if let name = dict["name"] as? String  {
                    if let timestamp = dict["timestamp"] as? String  {
                        self.appendMessage(message, name, timestamp)
                    }
                }
            }
        }
    }
    
    func startTimer(){
        if UserDefaults.standard.value(forKey: Constants.role) as! String == "Host"{
            self.label_timer.isHidden = false
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func countdown() {
        var hours: Int
        var minutes: Int
        var seconds: Int
        
        counter += 1
        hours = counter / 3600
        minutes = (counter % 3600) / 60
        seconds = (counter % 3600) % 60
        if hours > 0{
            label_timer.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            
        }else{
            label_timer.text = String(format: "%02d:%02d", minutes, seconds)
        }
        
        
    }

    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["support@superpro.ai"])
            mail.setMessageBody("Explain your issue here", isHTML: true)

            present(mail, animated: true)
        } else {
            self.presentAlert("Can't send a mail now!!!","Error")
        }
    }
    

    @IBAction private func muteRemoteStreamsTapped(_ sender: UIButton) {
       // viewModel.muteRemoteStreams(sender.isSelected)
        sender.isSelected = !sender.isSelected
    }


    @IBAction private func videoTapped(_ sender: UIButton) {
        Utilities().segmenEvent("Camera button Tapped", ["RoomName": roomName as String,"Room Id": UserDefaults.standard.value(forKey: RoomConstants.roomIDKey) as! String, "Value": sender.isSelected as Bool])
        viewModel.switchVideo(isOn: sender.isSelected)
        UserDefaults.standard.set(sender.isSelected, forKey: Constants.publishVideo)
        sender.isSelected = !sender.isSelected
        
        
        
    }

    @IBAction private func micTapped(_ sender: UIButton) {
        Utilities().segmenEvent("Audio button Tapped", ["RoomName": roomName as String,"Room Id": UserDefaults.standard.value(forKey: RoomConstants.roomIDKey) as! String, "Value": sender.isSelected as Bool])
        viewModel.switchAudio(isOn: sender.isSelected)
        UserDefaults.standard.set(sender.isSelected, forKey: Constants.publishAudio)
        sender.isSelected = !sender.isSelected
        
        
    }

    @IBAction private func chatTapped(_ sender: UIButton) {
        
        if sender.tag == 21{
           self.uiview_chat.isHidden = false
        }else if sender.tag == 22{
            view.endEditing(true)
            self.uiview_chat.isHidden = true
        }
        
    }
    
    
    @IBAction private func disconnectTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "",
                                                message: "Do you want to leave the call?",
                                                preferredStyle: .alert)
        
        if sender.tag == 11{
            alertController.title = "Leave Room"
        }else if sender.tag == 12{
            alertController.title = "End Call"
        }
        
        

        alertController.addAction(UIAlertAction(title: "YES", style: .default) { (_) in
            
            self.collectionView.isHidden = true
            self.uiview_rate_feedback.isHidden = false
            self.uiview_more_options.isHidden = true
            
            Utilities().segmenEvent("End Call", ["RoomName": self.roomName as String,"Room Id": UserDefaults.standard.value(forKey: RoomConstants.roomIDKey) as! String])
            
        })

        alertController.addAction(UIAlertAction(title: "NO", style: .destructive))

        self.present(alertController, animated: true, completion: nil)

    }
    
    
    @IBAction func inviteTapped(_ sender: UIButton) {

    }
    
    @IBAction func inviteCancelTapped(_ sender: UIButton) {
        self.uiview_invite.isHidden = true
    }
    
    @IBAction func moreOptionsPressed(_ sender: UIButton) {
        self.uiview_transparent.isHidden = false
        self.uiview_more_options.isHidden = false
    }
    
    @IBAction func helpPressed(_ sender: UIButton) {
        self.uiview_transparent.isHidden = false
        self.uiview_help.isHidden = false
        self.uiview_audio_question.isHidden = true
        self.uiview_audio_no.isHidden = true
        self.uilabel_connection_status.isHidden = true
        
        Utilities().segmenEvent("Help", ["RoomName": roomName as String,"Room Id": UserDefaults.standard.value(forKey: RoomConstants.roomIDKey) as! String, "Value": sender.isSelected as Bool])
    }
    
    @IBAction func switchCameraTapped(_ sender: UIButton) {
        viewModel.switchCamera()
        Utilities().segmenEvent("SwitchCamera", ["RoomName": roomName as String,"Room Id": UserDefaults.standard.value(forKey: RoomConstants.roomIDKey) as! String])
    }
    
    @IBAction func moreOptionCancelPressed(_ sender: UIButton) {
        self.uiview_transparent.isHidden = true
        self.uiview_more_options.isHidden = true
    }
    
    @IBAction func cancelHelpPressed(_ sender: UIButton) {
        if audioPlayer != nil{
            if audioPlayer!.isPlaying {
                audioPlayer?.stop()
            }
        }
        self.uiview_transparent.isHidden = true
        self.uiview_help.isHidden = true
        self.uiview_audio_no.isHidden = true
        self.label_audio_yes.isHidden = true
        self.uiview_audio_question.isHidden = true
        self.uibutton_play_view.isHidden = true
        self.uilabel_connection_status.isHidden = true
        
    }
    
    @IBAction func refreshPageTapped(_ sender: UIButton) {
        self.uiview_transparent.isHidden = true
        self.uiview_help.isHidden = true
        self.collectionView.reloadData()
        self.presentAlert("Page updated successfully","Success")
    }
    
    
    @IBAction func soundCheckPressed(_ sender: UIButton) {
        self.uibutton_play_view.isHidden = false
        
        let bundle = Bundle(identifier: Constants.bundleId)
        let path = bundle?.path(forResource: "sample_audio", ofType: "mp3")
        let url = URL(fileURLWithPath: path!)

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
        } catch {
            // couldn't load file :(
            self.presentAlert("Something went wrong.", "Error")
        }
    }
    
    
    @IBAction func connectionCheckTapped(_ sender: UIButton) {

        if Utilities.isConnectedToNetwork() == true{
            self.presentAlert("Network connection is stable.", "Connnection Status")
//            self.uilabel_connection_status.textColor = UIColor.green
//            self.uilabel_connection_status.text = "Network connection is stable."
        }else{
            self.presentAlert("There is a problem in your network connection.", "Connnection Status")
//            self.uilabel_connection_status.textColor = UIColor.red
//            self.uilabel_connection_status.text = "There is a problem in your network connection."
        }
        self.uiview_transparent.isHidden = true
        self.uiview_help.isHidden = true
    }
    
    @IBAction func audioYesTapped(_ sender: Any) {
        self.label_audio_yes.isHidden = false
        self.uiview_audio_question.isHidden = true
    }
    
    
    @IBAction func audioNoTapped(_ sender: UIButton) {
        self.uiview_audio_no.isHidden = false
        self.uiview_audio_question.isHidden = true
    }
    
    @IBAction func audioTestAgainTapped(_ sender: UIButton) {
        
        self.uiview_audio_no.isHidden = true
    
        soundCheckPressed(sender)
    }
    
    
    @IBAction func supportMailPressed(_ sender: UIButton) {
        self.uiview_help.isHidden = true
        self.uiview_transparent.isHidden = true
        self.sendEmail()
    }
    
    
    @IBAction func sendMessageTapped(_ sender: UIButton) {
        if pressedReturnToSendText(self.uitextfield_chat_message.text!) {
            self.uitextfield_chat_message.text = ""
        }
    }
    
    
    @IBAction func submitRatingTapped(_ sender: UIButton) {
        
        self.viewModel.cleanup()
        if ratingValue > 0{
            viewModel.sendFeedBack(view,self.ratingValue, self.uitextview_feedback_text.text ?? "" )
        }else{
            presentAlert("Rating field is empty","Error")
        }
    }
    
    
    @IBAction func closeFeedbackTapped(_ sender: UIButton) {
        viewModel.cleanup()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func pressedReturnToSendText(_ text: String?) -> Bool {
        guard let text = text, text.count > 0 else {
            return false
        }
        send(message: text)
        return true
    }
    
    func send(message: String) {
        viewModel.sendMessage(message)
    }
    
    func appendMessage(_ text: String,_ username: String,_ timeStamp: String){
        self.list.append(MessageChat(messageText: text, displayName: username, timestamp: timeStamp))
        if self.list.count > 100 {
            self.list.removeFirst()
        }
        let end = self.list.count - 1
        
        self.tableview_chat_message.reloadData()
        self.tableview_chat_message.scrollToRow(at: IndexPath(row: end, section: 0), at: .bottom, animated: true)
        if self.list.count > 0{
            self.uiview_chat_empty.isHidden = true
        }
    }
}

//MARK:Extension
extension MeetingViewController : AVAudioPlayerDelegate{
   public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished")//It is working now! printed "finished"!
        
        self.uibutton_play_view.isHidden = true
        self.uiview_audio_question.isHidden = false
    }
}

extension MeetingViewController: MFMailComposeViewControllerDelegate {
  public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
       controller.dismiss(animated: true, completion: nil)
   }
}

extension MeetingViewController : UITableViewDelegate, UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllers.chatmessageCell, for: indexPath) as! ChatMessageTableViewCell
        cell.uilabel_name.text = msg.displayName
        cell.uilabel_avatar.text = Utilities.getAvatarName(from: msg.displayName)
        cell.uilabel_message.text = msg.messageText
        cell.uilabel_timestamp.text = msg.timestamp
        
        // cell.update(type: type, message: msg)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
extension MeetingViewController: RatingViewDelegate {
   public func updateRatingFormatValue(_ value: Int) {
        self.ratingValue = value
        
    }
}
