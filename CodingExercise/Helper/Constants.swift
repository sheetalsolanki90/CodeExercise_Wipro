//
//  Constants.swift
//  CodingExercise
//
//  Created by Sheetal on 15/09/20.
//  Copyright © 2020 Sheetal.com. All rights reserved.
//

/**
 *  @Header
 *
 *  @Name : Constants.swift
 *
 *  @Purpose : This class contains all the constants required for TemperatureDial class.
 *
 *  @author : Renuka
 *
 *  COPYRIGHT NOTICE:
 *  (C) Honda R&D Americas Inc (HRA)
 *  Created in 2018 as an unpublished copyright work.
 *  All rights reserved.
 *  This document and the information it contains is
 *  confidential and proprietary to HRA.
 *  Hence, it may not be used, copied, reproduced, transmitted, or
 *  stored in any form or by any means, electronic, recording,
 *  photocopying, mechanical or otherwise, without the prior written
 *  permission of HRA.
 */

import Foundation

struct Constants{
    static let BASE_URL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    static let COUNTRY_TABLEVIEW_CELL_IDENTIFIER = "CountryTableViewCell"
    static let PULL_TO_REFRESH_MSG = "Pull to refresh"
    static let HTTP_METHOD_GET = "GET"

    struct ErrorConstants {
        static let NETWORK_ERROR = "Check your Internet connection."
        static let AUTHENTICATION_ERROR = "Authentication error"
        static let REQUEST_FAILED = "Request Failed"
    }

    struct AlertConstants {
        static let ALERT_TITLE = "Alert"
        static let ALERT_OK = "OK"

    }
}
