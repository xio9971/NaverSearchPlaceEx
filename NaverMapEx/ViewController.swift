//
//  ViewController.swift
//  NaverMapEx
//
//  Created by 민트팟 on 2021/06/29.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController {


    @IBOutlet weak var addressSearchBtn: UITextField!
    
    let NaverClientId = Bundle.main.object(forInfoDictionaryKey: "NaverClientId") as? String
    let NaverClientSecret = Bundle.main.object(forInfoDictionaryKey: "NaverClientSecret") as? String
    let NaverGeocdeUrl = Bundle.main.object(forInfoDictionaryKey: "NaverGeocdeUrl") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        if let infoDic: [String:Any] = Bundle.main.infoDictionary {
//            if let clientId = infoDic["NaverClientId"] as? String {
//                print(clientId)
//            }
//        }
        
    }
    
    @IBAction func addressSearch(_ sender: Any) {
        
        naverGeocode()
        //naverSearchPlace()
    }
    

    /*
     * Geocoding : 주소의 텍스트를 입력받아 좌표를 포함한 상세정보들을 제공합니다.
     */
    func naverGeocode() {
        
        guard let searchText = addressSearchBtn.text else {
            return
        }
        
        let encodeAddress = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let header1 = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: NaverClientId!)
        let header2 = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: NaverClientSecret!)
        let headers = HTTPHeaders([header1,header2])
        
        
        AF.request(NaverGeocdeUrl! + encodeAddress, method: .get,headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value as [String:Any]):
                    let json = JSON(value)
                    print(json)
                    let data = json["addresses"]
                    let lat = data[0]["y"]
                    let lon = data[0]["x"]
                    print("\(searchText)의 위도는 \(lat) 경도는 \(lon)")
                case .failure(let error):
                    print(error.errorDescription ?? "")
                default :
                    fatalError()
                }
            }
        

        /* searchText = "서울시 마포구 동교동"
           네이버 Geocode 결과값
         {
           "status" : "OK",
           "errorMessage" : "",
           "addresses" : [
             {
               "x" : "126.9251193",
               "roadAddress" : "서울특별시 마포구 동교동",
               "addressElements" : [
                 {
                   "code" : "",
                   "longName" : "서울특별시",
                   "shortName" : "서울특별시",
                   "types" : [
                     "SIDO"
                   ]
                 },
                 {
                   "code" : "",
                   "longName" : "마포구",
                   "shortName" : "마포구",
                   "types" : [
                     "SIGUGUN"
                   ]
                 },
                 {
                   "code" : "",
                   "longName" : "동교동",
                   "shortName" : "동교동",
                   "types" : [
                     "DONGMYUN"
                   ]
                 },
                 {
                   "code" : "",
                   "longName" : "",
                   "shortName" : "",
                   "types" : [
                     "RI"
                   ]
                 },
                 {
                   "code" : "",
                   "longName" : "",
                   "shortName" : "",
                   "types" : [
                     "ROAD_NAME"
                   ]
                 },
                 {
                   "code" : "",
                   "shortName" : "",
                   "types" : [
                     "BUILDING_NUMBER"
                   ],
                   "longName" : ""
                 },
                 {
                   "code" : "",
                   "shortName" : "",
                   "types" : [
                     "BUILDING_NAME"
                   ],
                   "longName" : ""
                 },
                 {
                   "code" : "",
                   "shortName" : "",
                   "types" : [
                     "LAND_NUMBER"
                   ],
                   "longName" : ""
                 },
                 {
                   "code" : "",
                   "shortName" : "",
                   "types" : [
                     "POSTAL_CODE"
                   ],
                   "longName" : ""
                 }
               ],
               "jibunAddress" : "서울특별시 마포구 동교동",
               "y" : "37.557576",
               "englishAddress" : "Donggyo-dong, Mapo-gu, Seoul, Republic of Korea",
               "distance" : 0
             }
           ],
           "meta" : {
             "totalCount" : 1,
             "count" : 1,
             "page" : 1
           }
         }
         */
        
        
    }
    

    /*
     Search Place : 네이버 지역 서비스에 등록된 각 지역별 업체 및 상호 검색 결과를 출력해주는 REST API입니다
     최대 5건 밖에 안된다...
     카카오 로컬 API를 사용해봐야겠다..
     */
    func naverSearchPlace() {
        
        guard let searchText = addressSearchBtn.text else {
            return
        }
        
        let encodeAddress = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                
        let header1 = HTTPHeader(name: "X-Naver-Client-Id", value: "RGpwhNWkZxZItNAl6FO3")
        let header2 = HTTPHeader(name: "X-Naver-Client-Secret", value: "WgNr9Cctzk")
        let headers = HTTPHeaders([header1,header2])
        
        AF.request("https://openapi.naver.com/v1/search/local.json?query=" + encodeAddress + "&display=5", method: .get,headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value as [String:Any]):
                    let json = JSON(value)
                    print(json)
                    let data = json["addresses"]
                    let lat = data[0]["mapy"]
                    let lon = data[0]["mapx"]
                    print("\(searchText)의 위도는 \(lat) 경도는 \(lon)")
                case .failure(let error):
                    print(error.errorDescription ?? "")
                default :
                    fatalError()
                }
            }
        
        /* searchText = "화랑대"
           네이버 search place api 결과값
        {
          "start" : 1,
          "display" : 5,
          "lastBuildDate" : "Wed, 30 Jun 2021 13:48:41 +0900",
          "total" : 5,
          "items" : [
            {
              "roadAddress" : "서울특별시 노원구 노원로1길 67 대덕프라자 3층",
              "description" : "",
              "link" : "https:\/\/wannafitgym.modoo.at",
              "category" : "스포츠시설>헬스장",
              "mapx" : "319324",
              "address" : "서울특별시 노원구 공릉동 89-1",
              "title" : "워너핏휘트니스 <b>화랑대<\/b>점",
              "mapy" : "558009",
              "telephone" : ""
            },
            {
              "roadAddress" : "서울특별시 노원구 노원로1길 67 118호",
              "description" : "",
              "link" : "http:\/\/www.frankburger.co.kr\/",
              "category" : "음식점>햄버거",
              "mapx" : "319306",
              "address" : "서울특별시 노원구 공릉동 89-1",
              "title" : "프랭크버거 <b>화랑대<\/b>역점",
              "mapy" : "558014",
              "telephone" : ""
            },
            {
              "roadAddress" : "서울특별시 노원구 노원로1길 74 에드네트학원",
              "description" : "",
              "link" : "http:\/\/www.paris.co.kr\/",
              "category" : "카페,디저트>베이커리",
              "mapx" : "319263",
              "address" : "서울특별시 노원구 공릉동 240-236",
              "title" : "파리바게뜨 <b>화랑대<\/b>역점",
              "mapy" : "558046",
              "telephone" : ""
            },
            {
              "roadAddress" : "서울특별시 노원구 노원로1길 67 201호",
              "description" : "",
              "link" : "http:\/\/blog.naver.com\/kerkerxi",
              "category" : "생활,편의>미용실",
              "mapx" : "319308",
              "address" : "서울특별시 노원구 공릉동 89-1",
              "title" : "모로헤어 <b>화랑대<\/b>역점",
              "mapy" : "558014",
              "telephone" : ""
            },
            {
              "roadAddress" : "서울특별시 노원구 노원로1길 67 대덕프라자 108호",
              "description" : "",
              "link" : "http:\/\/www.mealkitshop.com",
              "category" : "음식점>한식>백반,가정식",
              "mapx" : "319321",
              "address" : "서울특별시 노원구 공릉동 89-1 대덕프라자 108호",
              "title" : "식사준비 <b>화랑대<\/b>역점",
              "mapy" : "558011",
              "telephone" : ""
            }
          ]
        }
         */
    }
    
    


}

