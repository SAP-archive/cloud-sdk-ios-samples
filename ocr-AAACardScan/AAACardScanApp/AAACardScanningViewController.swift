//
//  AAACardScanningViewController.swift
//
//  Copyright © 2019 SAP SE or an SAP affiliate company. All rights reserved.
//

import UIKit
import SAPML
import SAPFiori

class AAACardScanningViewController: UIViewController {
    
    let recognitionView = FUITextRecognitionView()
    var memIdObv: RecognizeTextObservation?
    var clubIdObv: RecognizeTextObservation?
    var validThruObv: RecognizeTextObservation?
    var memberSinceObv: RecognizeTextObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(recognitionView)
        recognitionView.observationHandler = self.observationhandler
        recognitionView.captureMaskPath = {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 350, height: 220), cornerRadius: 4)
            path.lineWidth = 1
            return path
        }()
        recognitionView.translatesAutoresizingMaskIntoConstraints = false
        recognitionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        recognitionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        recognitionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        recognitionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recognitionView.startSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recognitionView.stopSession()
        recognitionView.showTexts(for: [], with: nil)
        memIdObv = nil
        clubIdObv = nil
        validThruObv = nil
        memberSinceObv = nil
    }
    
    func nextObservationInColumn(observations: [RecognizeTextObservation], for observation: RecognizeTextObservation) -> RecognizeTextObservation? {
        let toleranceFactor: CGFloat = 0.02
        let rangeX = (observation.bottomLeft.x - toleranceFactor)...(observation.bottomLeft.x + toleranceFactor)
        let rangeY = (observation.bottomLeft.y)...(observation.bottomLeft.y + toleranceFactor)
        return observations.first(where: { rangeX.contains($0.topLeft.x) &&  rangeY.contains($0.topLeft.y)})
    }
    
    func observationhandler(observations: [RecognizeTextObservation]) -> Bool {
     
        if let memObservation = observations.first(where: { $0.value.range(of: "membership", options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) != nil}) {
            memIdObv = memIdObv ?? nextObservationInColumn(observations: observations, for: memObservation)
        }
        
        if let clubCodeObservation = observations.first(where: {$0.value.compare("club", options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) == .orderedSame}) {
            clubIdObv = clubIdObv ?? nextObservationInColumn(observations: observations, for: clubCodeObservation)
        }

       if let memberSinceObservation = observations.first(where: {$0.value.compare("member", options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) == .orderedSame}) {
           memberSinceObv = memberSinceObv ?? nextObservationInColumn(observations: observations, for: memberSinceObservation)
       }
        
        if let validThruObservation = observations.first(where: {$0.value.compare("valid", options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) == .orderedSame}) {
            validThruObv = validThruObv ?? nextObservationInColumn(observations: observations, for: validThruObservation)
        }
        
        guard let memIdObv = memIdObv, let validThruObv = validThruObv, let memberSinceObv = memberSinceObv, let clubIdObv = clubIdObv else { return false }
        let allObvs: [RecognizeTextObservation] = [memIdObv, clubIdObv, memberSinceObv, validThruObv]
        recognitionView.showTexts(for: allObvs, with: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.recognitionView.stopSession()
            let form = AAACardFormTableViewController()
            form.membershipId = memIdObv.value
            form.validThru = validThruObv.value
            form.memberSince = memberSinceObv.value
            form.clubId = clubIdObv.value
            self?.navigationController?.pushViewController(form, animated: true)
        }
        return true
    }
}
