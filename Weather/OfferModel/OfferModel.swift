//
//  OfferModel.swift
//  Weather
//
//  Created by Dima  on 15.07.2022.
//

import Foundation

class OfferModel:Codable{
    var cod:String?
    var message:Float?
    var cnt:Float?
    var list:[ListOfferModel]?
    var city:CityModel?
    
}
