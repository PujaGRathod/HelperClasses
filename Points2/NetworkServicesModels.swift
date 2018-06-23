//
//  NetworkServicesModels.swift
//  Points2Miles_Akshit
//
//  Created by Intelivex Labs on 23/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
struct NetworkServicesModels {
    
    struct signUp {
        struct request {
            var first_name: String?
            var last_name: String?
            var email : String?
            var password: String?
            var device_token: String?
        }
    }
    
    struct logIn {
        struct request {
            var email : String?
            var password: String?
            var device_token: String?
        }
    }
    
    struct user {
        struct request {
            var userid: String
            var email : String
            var firstName: String
            var lastName: String
        }
    }

    struct rewardsPoints {
        struct request {
            var tripID: String
            var hotelCheckoutID: String
        }
    }

    struct userProfileImage {
        struct request {
            var userid: String
            var image: UIImage
        }
    }
    
    struct addDeviceToken {
        struct request {
            var authToken: String?
            var deviceToken: String?
        }
    }
    
    struct deleteDeviceToken {
        struct request {
            var authToken: String?
            var deviceToken: String?
        }
    }
    
    struct forgotPassword {
        struct request {
            var email: String!
        }
        struct response {
            var isSuccess: Bool = false
            var errorMessage: String?
        }
    }
    
    struct changePassword {
        struct request {
            var email: String
            var password: String
            var otp: String
        }
        struct response {
            var isSuccess: Bool = false
            var errorMessage: String?
        }
    }
    
    struct createTrip {
        struct request {
            var startLocationLatitude: String
            var startLocationLongitude: String
            var hotelId: String
            var startLocationAddress: String?
            var startLocationCity: String?
            var startLocationState: String?
            var startLocationZip: String?
            var locationPoints: String?
        }
    }
    
    struct endTrip {
        struct request {
            var tripId: String
            var distance: Double
        }
        struct response {
            var isSuccess: Bool = false
        }
    }
    
    struct deleteTrip {
        struct request {
            var tripId: String
        }
        struct response {
            var isSuccess: Bool = false
        }
    }
    
    struct drawMapPath {
        struct request {
            var rootLocation: CLLocationCoordinate2D
            var destinationLocation: CLLocationCoordinate2D
            var googleApiKey: String?
        }
    }
}
