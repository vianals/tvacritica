//
//  ViewController.swift
//  Acritica FM 93
//
//  Created by Administrador on 14/10/16.
//  Copyright © 2016 EasyTiDev. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!

    @IBOutlet weak var myVolumeController: UISlider!
    @IBAction func controlVolume(_ sender: AnyObject) {
        RadioPlayer.sharedInstance.mudaVolume(volume: myVolumeController.value)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*CHAMA A FUNCAO beginReceivingRemoteControlEvents DO ARQUIVO APPDELEGATE.
         FOI COM ELA QUE CONSEGUIMOS RESOLVER O CONTROLE DO STREAMING VIA LOCK SCREEN E CENTRAL DE CONTROLE
         RESPONSÁVEL PELA ADAPTACAO: PATRIC OLIVEIRA
        */
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
        /*CRIA UMA SESSAO DE AUDIO DO STREAMING EM EXECUÇÃO ATIVA E É UTILIZADA PELA FUNCAO ACIMA 
         COMO BASE DE INFORMAÇÃO
         RESPONSÁVEL PELA ADAPTACAO: PATRIC OLIVEIRA
         */
     
        do {
        
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        /* GERANDO INFORMAÇÕES PARA SEREM UTILIZADAS NO REMOTE CONTROL
         COMO NOME DA RÁDIO etc
         RESPONSÁVEL PELA ADAPTACAO: PATRIC OLIVEIRA
         */
       if NSClassFromString("MPNowPlayingInfoCenter") != nil {
           let image:UIImage = UIImage(named: "logo_player_background")! // comment this if you don't use an image
           let albumArt = MPMediaItemArtwork(image: image) // comment this if you don't use an image
           let songInfo = [
                MPMediaItemPropertyTitle: "Rádio A Crítica",
                MPMediaItemPropertyArtist: "93,1 fm",
                MPMediaItemPropertyArtwork: albumArt // comment this if you don't use an image
            ] as [String : Any]
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
            }
        
        
        }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func playButtonPressed(_ sender: AnyObject) { //ACTION DO BOTÃO PLAY/PAUSE
        
        toggle()//COMUTA PARA O STREAMING
        
    }
    
    
    func toggle() {//VERIFICA SE ESTÁ TOCANDO
        
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            pauseRadio()
        } else {
            playRadio()
        }
    }
    
    
    func playRadio() {
        RadioPlayer.sharedInstance.play()
        //playButton.setTitle("Pause", for: UIControlState.normal)
        playButton.setImage(#imageLiteral(resourceName: "pause"), for: UIControlState.normal)
    }
    
    func pauseRadio() {
        RadioPlayer.sharedInstance.pause()
        //playButton.setTitle("Play", for: UIControlState.normal)
        playButton.setImage(#imageLiteral(resourceName: "play"), for: UIControlState.normal)
        
    }


}

