//
//  AuthManager.swift
//  Spotify
//
// This authenticates Firebase instead of Spotify. 
//
//  Created by Tejvir Mann on 2/16/21.
//

import FirebaseAuth
import Foundation

final class AuthManager{
    static let shared = AuthManager()
    
    private init(){}
        
    //in app delegate, this is called. If user logged in, then automatically home screen.
    var isSignedIn: Bool{
        if FirebaseAuth.Auth.auth().currentUser != nil{
            return false
        }
        else{
            return false //then would have to log in. 
        }
    }
    
    
    //Dont need anythin below, since Firebase takes care of this for us.
    private var accessToken : String? {
        return nil
    }

    private var tokenExperiationDate: Date? {
        return nil
    }

    //https://stackoverflow.com/questions/49929134/how-to-get-refresh-token-for-google-api-using-firebase-authentication?rq=1
    //Firebase already refreshes the tokens for you automatically.
    private var shouldRefreshToken: Bool {
        return false;
    }
    
    

}
