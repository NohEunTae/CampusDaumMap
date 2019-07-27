//
//  CDSetInitialCoreData.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 26..
//  Copyright © 2018년 user. All rights reserved.
//

import Foundation
import CoreData

func setInitialCoreData(completion: (()->())?)
{
//    removeAllOfCoreData()
    insertFacilities {
        completion?()
    }
}

func insertFacilities(completion: (() -> ())) {
    let allFacilityName: [CDFacilities] =        [.fBell, .fElevator, .fWomanToilet, .fManToilet, .fDisabledPublicToilet, .fPublicToilet, .fPublicToiletWoman, .fPark, .fWheelchairReport, .fSlopeWay, .fRest, .fDisabledRest]
    let allFacilityIcon: [CDFacilityImageName] =
        [.f_icon_bell, .f_icon_elevator, .f_icon_womanToilet, .f_icon_manToilet, .f_icon_disabledPublicToilet,
         .f_icon_publicToilet, .f_icon_publicToiletWoman, .f_icon_park, .f_icon_wheelchairReport, .f_icon_slopeWay, .f_icon_rest, .f_icon_disabledRest]
    
    for i in 0..<allFacilityName.count {
        CDCoreDataManager.store.insertIntoFacility(fName: allFacilityName[i].rawValue, iconName: allFacilityIcon[i].rawValue)
    }
    insertBuilding {
        completion()
    }
}

func insertBuilding(completion: (() -> ())) {
    var cnt = 0
    
    let allBuildingNames: [CDBuildingName] =
        [.leeGong, .hooSang, .bon, .shalom, .kyoYouk, .simJyunOld, .simJyunNew, .inMoon,
         .yeahSool, .wooWon, .joongDoe, .kyungChun, .chunEun, .mokYang]
    
    let allBuildingImages: [CDBuildingImage] =
        [.leeGong, .hooSang, .bon, .shalom, .kyoYouk, .simJyun, .simJyun, .inMoon,
         .yeahSool, .wooWon, .joongDoe, .kyungChun, .chunEun, .mokYang]
    
    for i in 0..<allBuildingNames.count {
        CDCoreDataManager.store.insertIntoBuilding(
            bName: allBuildingNames[i].rawValue,
            bImage: allBuildingImages[i].rawValue)
    }
    
    insertLayers {
        cnt += 1
        if cnt == 2 {
            cnt = 0
            completion()
        }
    }
    
    setGPSInfo {
        cnt += 1
        if cnt == 2 {
            cnt = 0
            completion()
        }
    }
}

func insertLayers(completion: (()->())) {
    
    //이공관 층
    let leegong = CDCoreDataManager.store.selectBuilding(bName: CDBuildingName.leeGong.rawValue)!
    for i in 1..<6 {
        CDCoreDataManager.store.insertIntoLayers(stairNumb: i, imageName: "leeGong_\(i)F",
            building: leegong)
    }
    
    let leegonglayers = CDCoreDataManager.store.selectAllCoreDataObjectFromLayers().filter {
        $0.building == leegong
    }
    
    for i in 1..<6 {
        var layerFacilities: [CDFacilities] = [CDFacilities]()
        switch i {
        case 1:
            layerFacilities = [.fSlopeWay, .fPublicToilet, .fManToilet, .fWomanToilet, .fBell]
            break
        case 2:
            layerFacilities = [.fRest ,.fSlopeWay]
            break
        case 3:
            layerFacilities = [.fRest, .fSlopeWay, .fPublicToilet, .fManToilet, .fWomanToilet]
            break
        case 4:
            layerFacilities = [.fRest, .fSlopeWay, .fPublicToilet, .fManToilet, .fWomanToilet]
            break
        case 5:
            layerFacilities = [.fSlopeWay, .fPublicToilet]
            break
        default:
            break
        }
        
        for layerFacility in layerFacilities {
            let facility = CDCoreDataManager.store.selectAllCoreDataObjectFromFacility().filter { $0.fName == layerFacility.rawValue }.first!
            let leegongLayer = leegonglayers.filter { $0.stairNumb == Int32(i) }.first!
            CDCoreDataManager.store.insertIntoEachLayerFacilities(facility: facility, layer: leegongLayer)
        }
    }
    
    
    //후생관 층
    let hoosang = CDCoreDataManager.store.selectBuilding(bName: CDBuildingName.hooSang.rawValue)!
    CDCoreDataManager.store.insertIntoLayers(stairNumb: -1, imageName: "hooSang_-1F",
                                             building: hoosang)
    for i in 1..<4 {
        CDCoreDataManager.store.insertIntoLayers(stairNumb: i, imageName: "hooSang_\(i)F",
            building: hoosang)
    }
    
    let hoosangLayers = CDCoreDataManager.store.selectAllCoreDataObjectFromLayers().filter {
        $0.building == hoosang
    }
    
    for i in -1..<4 {
        var layerFacilities: [CDFacilities] = [CDFacilities]()
        switch i {
        case -1:
            break
        case 0:
            break
        case 1:
            layerFacilities = [.fSlopeWay, .fPublicToilet, .fManToilet, .fWomanToilet]
            break
        case 2:
            layerFacilities = [.fPublicToilet]
            break
        case 3:
            layerFacilities = [.fPublicToilet]
            break
        default:
            break
        }
        if layerFacilities.count > 0 {
            for layerFacility in layerFacilities {
                let facility = CDCoreDataManager.store.selectAllCoreDataObjectFromFacility().filter { $0.fName == layerFacility.rawValue }.first!
                let hoosangLayer = hoosangLayers.filter { $0.stairNumb == Int32(i) }.first!
                CDCoreDataManager.store.insertIntoEachLayerFacilities(facility: facility, layer: hoosangLayer)
            }
        }
    }
    
    //본관 층
    let bon = CDCoreDataManager.store.selectBuilding(bName: CDBuildingName.bon.rawValue)!
    CDCoreDataManager.store.insertIntoLayers(stairNumb: -1, imageName: "bon_-1F",
                                             building: bon)
    for i in 1..<5 {
        CDCoreDataManager.store.insertIntoLayers(stairNumb: i, imageName: "bon_\(i)F",
            building: bon)
    }
    
    let bonLayers = CDCoreDataManager.store.selectAllCoreDataObjectFromLayers().filter {
        $0.building == bon
    }
    
    for i in -1..<5 {
        var layerFacilities: [CDFacilities] = [CDFacilities]()
        switch i {
        case -1:
            break
        case 0:
            break
        case 1:
            layerFacilities = [.fPublicToilet, .fManToilet, .fWomanToilet]
            break
        case 2:
            layerFacilities = [.fPublicToilet]
            break
        case 3:
            layerFacilities = [.fPublicToilet]
            break
        case 4:
            layerFacilities = [.fPublicToilet]
            break
        default:
            break
        }
        if layerFacilities.count > 0 {
            for layerFacility in layerFacilities {
                let facility = CDCoreDataManager.store.selectAllCoreDataObjectFromFacility().filter { $0.fName == layerFacility.rawValue }.first!
                let bonLayer = bonLayers.filter { $0.stairNumb == Int32(i) }.first!
                CDCoreDataManager.store.insertIntoEachLayerFacilities(facility: facility, layer: bonLayer)
            }
        }
    }
    
    
    //샬롬관 층
    let shalom = CDCoreDataManager.store.selectBuilding(bName: CDBuildingName.shalom.rawValue)!
    CDCoreDataManager.store.insertIntoLayers(stairNumb: -1, imageName: "shalom_-1F",
                                             building: shalom)
    for i in 1..<14 {
        CDCoreDataManager.store.insertIntoLayers(stairNumb: i, imageName: "shalom_\(i)F",
            building: shalom)
    }
    
    let shalomLayers = CDCoreDataManager.store.selectAllCoreDataObjectFromLayers().filter {
        $0.building == shalom
    }
    for i in -1..<14 {
        var layerFacilities: [CDFacilities] = [CDFacilities]()
        switch i {
        case -1:
            layerFacilities = [.fElevator, .fRest, .fPublicToilet, .fDisabledPublicToilet, .fBell]
            break
        case 0:
            break
        case 1:
            layerFacilities = [.fElevator, .fRest, .fPublicToilet, .fDisabledPublicToilet, .fBell]
            break
        default:
            layerFacilities = [.fElevator, .fRest, .fPublicToilet, .fDisabledPublicToilet]
            break
        }
        if layerFacilities.count > 0 {
            for layerFacility in layerFacilities {
                let facility = CDCoreDataManager.store.selectAllCoreDataObjectFromFacility().filter { $0.fName == layerFacility.rawValue }.first!
                let shalomLayer = shalomLayers.filter { $0.stairNumb == Int32(i) }.first!
                CDCoreDataManager.store.insertIntoEachLayerFacilities(facility: facility, layer: shalomLayer)
            }
        }
    }
    
    //교육관 층
    let kyoYouk = CDCoreDataManager.store.selectBuilding(bName: CDBuildingName.kyoYouk.rawValue)!
    for i in 1..<5 {
        CDCoreDataManager.store.insertIntoLayers(stairNumb: i, imageName: "kyoYouk_\(i)F",
            building: kyoYouk)
    }
    
    let kyoYoukLayers = CDCoreDataManager.store.selectAllCoreDataObjectFromLayers().filter {
        $0.building == kyoYouk
    }
    
    for i in 1..<5 {
        var layerFacilities: [CDFacilities] = [CDFacilities]()
        switch i {
        case 1:
            layerFacilities = [.fWheelchairReport, .fPublicToilet, .fManToilet, .fWomanToilet, .fBell]
            break
        default:
            layerFacilities = [.fPublicToilet]
            break
        }
        if layerFacilities.count > 0 {
            for layerFacility in layerFacilities {
                let facility = CDCoreDataManager.store.selectAllCoreDataObjectFromFacility().filter { $0.fName == layerFacility.rawValue }.first!
                let kyoYoukLayer = kyoYoukLayers.filter { $0.stairNumb == Int32(i) }.first!
                CDCoreDataManager.store.insertIntoEachLayerFacilities(facility: facility, layer: kyoYoukLayer)
            }
        }
    }
    
    //심전관 층
    let simJyunNew = CDCoreDataManager.store.selectBuilding(bName: CDBuildingName.simJyunNew.rawValue)!
    CDCoreDataManager.store.insertIntoLayers(stairNumb: -1, imageName: "simJyun_-1F",
                                             building: simJyunNew)
    for i in 1..<2 {
        CDCoreDataManager.store.insertIntoLayers(stairNumb: i, imageName: "simJyun_\(i)F",
            building: simJyunNew)
    }
    
    let simJyunLayers = CDCoreDataManager.store.selectAllCoreDataObjectFromLayers().filter {
        $0.building == simJyunNew
    }
    
    for i in 0..<2 {
        var layerFacilities: [CDFacilities] = [CDFacilities]()
        switch i {
        case -1:
            layerFacilities = [.fElevator, .fPublicToilet, .fWomanToilet, .fBell]
            break
        case 0:
            break
        case 1:
            layerFacilities = [.fElevator, .fRest, .fPublicToilet, .fManToilet, .fBell]
            break
        default:
            break
        }
        if layerFacilities.count > 0 {
            for layerFacility in layerFacilities {
                let facility = CDCoreDataManager.store.selectAllCoreDataObjectFromFacility().filter { $0.fName == layerFacility.rawValue }.first!
                let simJyunLayer = simJyunLayers.filter { $0.stairNumb == Int32(i) }.first!
                CDCoreDataManager.store.insertIntoEachLayerFacilities(facility: facility, layer: simJyunLayer)
            }
        }
    }
    
    //인문사회관 층
    let inMoon = CDCoreDataManager.store.selectBuilding(bName: CDBuildingName.inMoon.rawValue)!
    for i in 1..<6 {
        CDCoreDataManager.store.insertIntoLayers(stairNumb: i, imageName: "inMoon_\(i)F",
            building: inMoon)
    }
    
    let inMoonLayers = CDCoreDataManager.store.selectAllCoreDataObjectFromLayers().filter {
        $0.building == inMoon
    }
    
    for i in 1..<6 {
        var layerFacilities: [CDFacilities] = [CDFacilities]()
        switch i {
        case 1:
            layerFacilities = [.fSlopeWay, .fPublicToilet, .fManToilet, .fWomanToilet, .fBell]
            break
        default:
            layerFacilities = [.fPublicToilet, .fManToilet, .fWomanToilet, .fBell]
            break
        }
        if layerFacilities.count > 0 {
            for layerFacility in layerFacilities {
                let facility = CDCoreDataManager.store.selectAllCoreDataObjectFromFacility().filter { $0.fName == layerFacility.rawValue }.first!
                let inMoonLayer = inMoonLayers.filter { $0.stairNumb == Int32(i) }.first!
                CDCoreDataManager.store.insertIntoEachLayerFacilities(facility: facility, layer: inMoonLayer)
            }
        }
    }
    
    //예술관 층
    let yeahSool = CDCoreDataManager.store.selectBuilding(bName: CDBuildingName.yeahSool.rawValue)!
    CDCoreDataManager.store.insertIntoLayers(stairNumb: -1, imageName: "yeahSool_-1F",
                                             building: yeahSool)
    for i in 1..<6 {
        CDCoreDataManager.store.insertIntoLayers(stairNumb: i, imageName: "yeahSool_\(i)F",
            building: yeahSool)
    }
    
    let yeahSoolLayers = CDCoreDataManager.store.selectAllCoreDataObjectFromLayers().filter {
        $0.building == yeahSool
    }
    
    for i in -1..<6 {
        var layerFacilities: [CDFacilities] = [CDFacilities]()
        switch i {
        case -1:
            break
        case 0:
            break
        case 1:
            layerFacilities = [.fElevator, .fSlopeWay, .fPublicToilet, .fManToilet, .fWomanToilet, .fBell]
            break
        case 2:
            layerFacilities = [.fPublicToilet, .fElevator]
            break
        case 3:
            layerFacilities = [.fPublicToilet, .fElevator]
            break
        default:
            layerFacilities = [.fElevator]
            break
        }
        if layerFacilities.count > 0 {
            for layerFacility in layerFacilities {
                let facility = CDCoreDataManager.store.selectAllCoreDataObjectFromFacility().filter { $0.fName == layerFacility.rawValue }.first!
                let yeahSoolLayer = yeahSoolLayers.filter { $0.stairNumb == Int32(i) }.first!
                CDCoreDataManager.store.insertIntoEachLayerFacilities(facility: facility, layer: yeahSoolLayer)
            }
        }
    }
    
    
    //우원관 층
    let wooWon = CDCoreDataManager.store.selectBuilding(bName: CDBuildingName.wooWon.rawValue)!
    for i in 1..<5 {
        CDCoreDataManager.store.insertIntoLayers(stairNumb: i, imageName: "wooWon_\(i)F",
            building: wooWon)
    }
    
    let wooWonLayers = CDCoreDataManager.store.selectAllCoreDataObjectFromLayers().filter {
        $0.building == wooWon
    }
    
    for i in 1..<5 {
        var layerFacilities: [CDFacilities] = [CDFacilities]()
        switch i {
        case 1:
            layerFacilities = [.fElevator, .fDisabledRest, .fSlopeWay, .fPublicToilet, .fManToilet, .fWomanToilet, .fBell]
            break
        case 2:
            layerFacilities = [.fElevator, .fPublicToilet, .fManToilet, .fWomanToilet]
            break
        default:
            layerFacilities = [.fElevator, .fPublicToilet]
            break
        }
        
        if layerFacilities.count > 0 {
            for layerFacility in layerFacilities {
                let facility = CDCoreDataManager.store.selectAllCoreDataObjectFromFacility().filter { $0.fName == layerFacility.rawValue }.first!
                let wooWonLayer = wooWonLayers.filter { $0.stairNumb == Int32(i) }.first!
                CDCoreDataManager.store.insertIntoEachLayerFacilities(facility: facility, layer: wooWonLayer)
            }
        }
    }
    
    //중앙도서관 층
    let joongDoe = CDCoreDataManager.store.selectBuilding(bName: CDBuildingName.joongDoe.rawValue)!
    
    for i in 1..<5 {
        CDCoreDataManager.store.insertIntoLayers(stairNumb: i, imageName: "joongDoe_\(i)F",
            building: joongDoe)
    }
    
    let joongDoeLayers = CDCoreDataManager.store.selectAllCoreDataObjectFromLayers().filter {
        $0.building == joongDoe
    }
    
    for i in 1..<5 {
        var layerFacilities: [CDFacilities] = [CDFacilities]()
        switch i {
        case 1:
            layerFacilities = [.fSlopeWay, .fPublicToilet, .fManToilet, .fWomanToilet, .fBell]
            break
        default:
            layerFacilities = [.fPublicToilet]
            break
        }
        
        if layerFacilities.count > 0 {
            for layerFacility in layerFacilities {
                let facility = CDCoreDataManager.store.selectAllCoreDataObjectFromFacility().filter { $0.fName == layerFacility.rawValue }.first!
                let joongDoeLayer = joongDoeLayers.filter { $0.stairNumb == Int32(i) }.first!
                CDCoreDataManager.store.insertIntoEachLayerFacilities(facility: facility, layer: joongDoeLayer)
            }
        }
    }
    
    //경천관 층
    let kyungChun = CDCoreDataManager.store.selectBuilding(bName: CDBuildingName.kyungChun.rawValue)!
    CDCoreDataManager.store.insertIntoLayers(stairNumb: -1, imageName: "kyungChun_-1F",
                                             building: kyungChun)
    for i in 1..<6 {
        CDCoreDataManager.store.insertIntoLayers(stairNumb: i, imageName: "kyungChun_\(i)F",
            building: kyungChun)
    }
    
    let kyungChunLayers = CDCoreDataManager.store.selectAllCoreDataObjectFromLayers().filter {
        $0.building == kyungChun
    }
    
    for i in -1..<6 {
        var layerFacilities: [CDFacilities] = [CDFacilities]()
        switch i {
        case -1:
            break
        case 0:
            break
        case 1:
            layerFacilities = [.fRest, .fSlopeWay, .fPublicToilet]
            break
        case 2:
            layerFacilities = [.fPublicToilet]
            break
        case 3:
            layerFacilities = [.fSlopeWay, .fPublicToilet]
            break
        default:
            layerFacilities = [.fPublicToilet]
            break
        }
        
        if layerFacilities.count > 0 {
            for layerFacility in layerFacilities {
                let facility = CDCoreDataManager.store.selectAllCoreDataObjectFromFacility().filter { $0.fName == layerFacility.rawValue }.first!
                let kyungChunLayer = kyungChunLayers.filter { $0.stairNumb == Int32(i) }.first!
                CDCoreDataManager.store.insertIntoEachLayerFacilities(facility: facility, layer: kyungChunLayer)
            }
        }
    }
    
    //천은관 층
    let chunEun = CDCoreDataManager.store.selectBuilding(bName: CDBuildingName.chunEun.rawValue)!
    CDCoreDataManager.store.insertIntoLayers(stairNumb: -1, imageName: "chunEun_-1F",
                                             building: chunEun)
    for i in 1..<6 {
        CDCoreDataManager.store.insertIntoLayers(stairNumb: i, imageName: "chunEun_\(i)F",
            building: chunEun)
    }
    
    let chunEunLayers = CDCoreDataManager.store.selectAllCoreDataObjectFromLayers().filter {
        $0.building == chunEun
    }
    
    for i in -1..<6 {
        var layerFacilities: [CDFacilities] = [CDFacilities]()
        switch i {
        case -1:
            layerFacilities = [.fRest, .fSlopeWay, .fPublicToilet]
            break
        case 0:
            break
        case 1:
            layerFacilities = [.fSlopeWay, .fPublicToilet, .fManToilet, .fWomanToilet]
            break
        case 2:
            layerFacilities = [.fRest, .fSlopeWay, .fPublicToilet]
            break
        default:
            layerFacilities = [.fSlopeWay, .fPublicToilet]
            break
        }
        
        if layerFacilities.count > 0 {
            for layerFacility in layerFacilities {
                let facility = CDCoreDataManager.store.selectAllCoreDataObjectFromFacility().filter { $0.fName == layerFacility.rawValue }.first!
                let chunEunLayer = chunEunLayers.filter { $0.stairNumb == Int32(i) }.first!
                CDCoreDataManager.store.insertIntoEachLayerFacilities(facility: facility, layer: chunEunLayer)
            }
        }
    }
    
    //목양관 층
    let mokYang = CDCoreDataManager.store.selectBuilding(bName: CDBuildingName.mokYang.rawValue)!
    for i in 1..<3 {
        CDCoreDataManager.store.insertIntoLayers(stairNumb: i, imageName: "mokYang_\(i)F",
            building: mokYang)
    }
    
    let mokYangLayers = CDCoreDataManager.store.selectAllCoreDataObjectFromLayers().filter {
        $0.building == mokYang
    }
    
    for i in 1..<3 {
        var layerFacilities: [CDFacilities] = [CDFacilities]()
        switch i {
        case 1:
            layerFacilities = [.fSlopeWay, .fPublicToilet, .fManToilet, .fWomanToilet]
            break
        case 2:
            layerFacilities = [.fPublicToilet]
            break
        default:
            break
        }
        
        if layerFacilities.count > 0 {
            for layerFacility in layerFacilities {
                let facility = CDCoreDataManager.store.selectAllCoreDataObjectFromFacility().filter { $0.fName == layerFacility.rawValue }.first!
                let mokYangLayer = mokYangLayers.filter { $0.stairNumb == Int32(i) }.first!
                CDCoreDataManager.store.insertIntoEachLayerFacilities(facility: facility, layer: mokYangLayer)
            }
        }
    }
    
    completion()
}

func setGPSInfo(completion: ()->()) {
    insertGPSInfo(37.2734747077945, 127.12870398197106, nil)
    insertGPSInfo(37.273832511560755, 127.12903438586861, nil)
    insertGPSInfo(37.27393606336544, 127.12909657538378, nil)
    insertGPSInfo(37.27402165278743, 127.12910517782977, nil)
    insertGPSInfo(37.27417934064445, 127.12909980956498, nil)
    insertGPSInfo(37.27430995738274, 127.12913103915113, nil)
    insertGPSInfo(37.27442921883784, 127.1292468128809, nil)
    insertGPSInfo(37.27455738579308, 127.1294584409364, nil)
    insertGPSInfo(37.2746225352544, 127.12961922343318, nil)
    insertGPSInfo(37.27467633805944, 127.12985609406866, nil)
    insertGPSInfo(37.27482699580037, 127.13009876929856, "샬롬관")
    insertGPSInfo(37.27474585588877, 127.13014091156285, nil)
    insertGPSInfo(37.27503613359225, 127.13042047282534, nil)
    insertGPSInfo(37.274934692250206, 127.13048794902616, "샬롬관")
    insertGPSInfo(37.27485582655225, 127.13051036327961, nil)
    insertGPSInfo(37.2748962271399, 127.13064291655448, nil)
    insertGPSInfo(37.27417478871547, 127.13119133035617, nil)
    insertGPSInfo(37.27407802078409, 127.13110659939805, nil)
    insertGPSInfo(37.27404440655906, 127.13094869016763, nil)
    insertGPSInfo(37.27398832221001, 127.13074000444085, nil)
    insertGPSInfo(37.27392768878184, 127.13057077384319, nil)
    insertGPSInfo(37.27383998980277, 127.13043250318492, nil)
    insertGPSInfo(37.27396359034382, 127.13069768021606, nil)
    insertGPSInfo(37.27400396892314, 127.13084996334368, nil)
    insertGPSInfo(37.27405098963595, 127.13110655252227, nil)
    insertGPSInfo(37.27412741546886, 127.13125326108776, nil)
    insertGPSInfo(37.27475691510195, 127.13235650215039, nil)
    insertGPSInfo(37.2748312003134, 127.1324017329398, nil)
    insertGPSInfo(37.275137496503625, 127.13245300790071, nil)
    insertGPSInfo(37.27374768615926, 127.130384425095, nil)
    insertGPSInfo(37.27392245113661, 127.13123317391899, nil)
    insertGPSInfo(37.273935885445745, 127.13130648506876, nil)
    insertGPSInfo(37.27390866971959, 127.13147274474092, nil)
    insertGPSInfo(37.27395581449055, 127.13161658366009, nil)
    insertGPSInfo(37.27485336327304, 127.13272593339505, nil)
    insertGPSInfo(37.27499963651467, 127.13285585510144, nil)
    insertGPSInfo(37.275413, 127.133174, nil)
    insertGPSInfo(37.275853, 127.131123, nil)
    insertGPSInfo(37.27416307522426, 127.13159721307942, nil)
    insertGPSInfo(37.27429113751279, 127.13189904501529, "목양관")
    insertGPSInfo(37.27449351893637, 127.13221510184812, nil)
    insertGPSInfo(37.27438528413025, 127.13231356984465, "승리관")
    insertGPSInfo(37.275204749155094, 127.13274346315634, nil)
    insertGPSInfo(37.27316190303263, 127.12842157608694, nil)
    insertGPSInfo(37.2730127753358, 127.12884131331158, nil)
    insertGPSInfo(37.273345834019395, 127.12914066740784, nil)
    insertGPSInfo(37.27352589711403, 127.12927345610524, nil)
    insertGPSInfo(37.27355510081127, 127.12934679350231, nil)
    insertGPSInfo(37.27363395091082, 127.12933847214721, nil)
    insertGPSInfo(37.275240628266644, 127.13086619780317, "인문사회관")
    insertGPSInfo(37.27508058178045, 127.1309673977528, nil)
    insertGPSInfo(37.275170744830774, 127.13091399658175, nil)
    insertGPSInfo(37.2752784635983, 127.131280628775, nil)
    insertGPSInfo(37.27536851112766, 127.13133152383469, nil)
    insertGPSInfo(37.275438, 127.131334, nil)
    insertGPSInfo(37.2749683848306, 127.13057539001802, nil)
    insertGPSInfo(37.27599952828055, 127.13107046796486, nil)
    insertGPSInfo(37.27604695756002, 127.13095779653992, "예술관")
    insertGPSInfo(37.27569567430097, 127.13084725371365, nil)
    insertGPSInfo(37.2756191359094, 127.13080202003266, nil)
    insertGPSInfo(37.27561014732925, 127.1307822727045, nil)
    insertGPSInfo(37.27560350160775, 127.13068078351127, nil)
    insertGPSInfo(37.27590265421278, 127.13108157535082, nil)
    insertGPSInfo(37.27578332908882, 127.13102499181876, nil)
    insertGPSInfo(37.275697789742594, 127.13097128582523, nil)
    insertGPSInfo(37.27566628771209, 127.1309402241499, nil)
    insertGPSInfo(37.27554718361754, 127.13068350498273, nil)
    insertGPSInfo(37.275540547138775, 127.1305735594309, nil)
    insertGPSInfo(37.275398866635776, 127.13036190342784, nil)
    insertGPSInfo(37.2755136030257, 127.13049458589, nil)
    insertGPSInfo(37.274736417817515, 127.13255660053439, nil)
    insertGPSInfo(37.27546639171347, 127.13040993980303, nil)
    insertGPSInfo(37.27538985935885, 127.13035906907898, nil)
    insertGPSInfo(37.27532905480621, 127.13034487015832, nil)
    insertGPSInfo(37.275270505949756, 127.13032785633686, nil)
    insertGPSInfo(37.275236819390905, 127.13023477749314, nil)
    insertGPSInfo(37.27524581426614, 127.13024888704636, nil)
    insertGPSInfo(37.27520313275851, 127.13014169873219, nil)
    insertGPSInfo(37.27494007713313, 127.12968741906796, nil)
    insertGPSInfo(37.274971579497794, 127.12971847992296, nil)
    insertGPSInfo(37.27472168957667, 127.12958274913701, nil)
    insertGPSInfo(37.27542098537879, 127.13073120674022, "인문사회관")
    insertGPSInfo(37.27542715050849, 127.13126679288187, "인문사회관")
    insertGPSInfo(37.275276, 127.131264, nil)
    insertGPSInfo(37.276149, 127.134129, nil)
    insertGPSInfo(37.275863, 127.131099, nil)
    insertGPSInfo(37.275822, 127.131093, nil)
    insertGPSInfo(37.275980, 127.131377, nil)
    insertGPSInfo(37.276082, 127.131677, nil)
    insertGPSInfo(37.276321, 127.132627, nil)
    insertGPSInfo(37.276560, 127.132933, nil)
    insertGPSInfo(37.276564, 127.133067, nil)
    insertGPSInfo(37.275385, 127.131441, nil)
    insertGPSInfo(37.275583, 127.131745, nil)
    insertGPSInfo(37.275716, 127.131741, "우원관")
    insertGPSInfo(37.275739, 127.131984, nil)
    insertGPSInfo(37.27607913165436 ,127.13240955621824, nil)
    insertGPSInfo(37.276216, 127.132703, nil)
    insertGPSInfo(37.276190, 127.132399, nil)
    insertGPSInfo(37.276190, 127.132222, nil)
    insertGPSInfo(37.2762010, 127.1323413, nil)
    insertGPSInfo(37.276328, 127.132849, nil)
    insertGPSInfo(37.275216, 127.132492, nil)
    insertGPSInfo(37.275250, 127.132443, nil)
    insertGPSInfo(37.276222, 127.132927, nil)
    insertGPSInfo(37.275878, 127.133161, "본관")
    insertGPSInfo(37.275741, 127.133386, nil)
    insertGPSInfo(37.275661, 127.133410, "교육관")
    insertGPSInfo(37.275674, 127.1334447, nil)
    insertGPSInfo(37.2757133, 127.1336727, "교육관")
    insertGPSInfo(37.2756995, 127.1337089, nil)
    insertGPSInfo(37.275705, 127.134129, "천은관")
    insertGPSInfo(37.276403, 127.134493, nil)
    insertGPSInfo(37.275970, 127.133799, nil)
    insertGPSInfo(37.276168, 127.133638, nil)
    insertGPSInfo(37.276543, 127.133439, nil)
    insertGPSInfo(37.276172, 127.133906, nil)
    insertGPSInfo(37.276414, 127.134041, "경천관")
    insertGPSInfo(37.276204, 127.134216, nil)
    insertGPSInfo(37.276572, 127.133409, nil)
    insertGPSInfo(37.2768192, 127.1335809, "후생관")
    insertGPSInfo(37.2767733, 127.1336251, nil)
    insertGPSInfo(37.276950, 127.133919, nil)
    insertGPSInfo(37.277010, 127.134045, "이공관")
    insertGPSInfo(37.276709, 127.134252, nil)
    insertGPSInfo(37.276589, 127.134096, "경천관")
    insertGPSInfo(37.276643, 127.134338, nil)
    insertGPSInfo(37.276707, 127.134424, "이공관")
    insertGPSInfo(37.276523, 127.134491, nil)
    insertGPSInfo(37.2770425, 127.1338078, nil)
    insertGPSInfo(37.2769859, 127.1337012, "후생관")
    insertGPSInfo(37.277215, 127.133654, nil)
    insertGPSInfo(37.277392, 127.133773, nil)
    insertGPSInfo(37.277112, 127.134339, nil)
    insertGPSInfo(37.277150, 127.134457, nil)
    insertGPSInfo(37.276772, 127.134554, nil)
    insertGPSInfo(37.276691, 127.134562, nil)
    insertGPSInfo(37.276503, 127.134447, nil)
    insertGPSInfo(37.277588, 127.134095, "심전관(신관)")
    insertGPSInfo(37.277711, 127.134223, nil)
    insertGPSInfo(37.277797, 127.134239, nil)
    insertGPSInfo(37.277833, 127.134347, nil)
    insertGPSInfo(37.277833, 127.134457, nil)
    insertGPSInfo(37.277926, 127.134701, "심전관(구관)")
    insertGPSInfo(37.277803, 127.134575, nil)
    insertGPSInfo(37.277528, 127.134838, nil)
    insertGPSInfo(37.277453, 127.134999, nil)
    insertGPSInfo(37.277419, 127.135541, nil)

    //임시
    insertGPSInfo(37.27564404520821 , 127.13068367242158, nil)
    insertGPSInfo(37.274881522001934, 127.12967604342927, nil)
    insertGPSInfo(37.274809259746533, 127.12983940960875, nil)
    insertGPSInfo(37.276577, 127.133335, nil)
    insertGPSInfo(37.276495, 127.133426, nil)
    insertGPSInfo(37.276200, 127.132323, nil)
    insertGPSInfo(37.276298, 127.132314, "중앙도서관")
    insertGPSInfo(37.275631, 127.131821, nil)
    insertGPSInfo(37.276164, 127.132620, nil)
    insertGPSInfo(37.2761215, 127.1323065, nil)
    insertGPSInfo(37.276173, 127.131919, nil)
    insertGPSInfo(37.2762645, 127.1323377, nil)
    insertGPSInfo(37.276460, 127.132897, nil)
    insertGPSInfo(37.275258, 127.132556, nil)
    insertGPSInfo(37.275703, 127.133315, nil)
    insertGPSInfo(37.276038, 127.133056, nil)
    insertGPSInfo(37.275935, 127.133727, nil)
    insertGPSInfo(37.275257, 127.133055, nil)
    insertGPSInfo(37.275257, 127.133055, nil)
    insertGPSInfo(37.275517, 127.133492, nil)
    insertGPSInfo(37.2756989, 127.1338729, nil)
    insertGPSInfo(37.275984, 127.134307, nil)
    insertGPSInfo(37.27634721564954 ,127.13238747495028, nil)

    setConnection(completion: completion)
}

func insertGPSInfo(_ lat: Double, _ lon: Double, _ bName: String?) {
    CDCoreDataManager.store.insertIntoGPSInfo(latitude: lat, longitude: lon, bName: bName)
}

func setConnection(completion: ()->()) {
    insertConnection(37.2734747077945, 127.12870398197106, 37.273832511560755, 127.12903438586861, 2)
    insertConnection(37.273832511560755, 127.12903438586861, 37.27393606336544, 127.12909657538378, 2)
    insertConnection(37.27393606336544, 127.12909657538378, 37.27402165278743, 127.12910517782977, 2)
    insertConnection(37.27402165278743, 127.12910517782977, 37.27417934064445, 127.12909980956498, 2)
    insertConnection(37.27417934064445, 127.12909980956498, 37.27430995738274, 127.12913103915113, 2)
    insertConnection(37.27430995738274, 127.12913103915113, 37.27442921883784, 127.1292468128809, 2)
    insertConnection(37.27442921883784, 127.1292468128809, 37.27455738579308, 127.1294584409364, 2)
    insertConnection(37.27455738579308, 127.1294584409364, 37.2746225352544, 127.12961922343318, 2)
    insertConnection(37.2746225352544, 127.12961922343318, 37.27467633805944, 127.12985609406866, 2)
    insertConnection(37.27467633805944, 127.12985609406866, 37.27474585588877, 127.13014091156285, 2)
    insertConnection(37.27482699580037, 127.13009876929856, 37.27474585588877, 127.13014091156285, 1)
    insertConnection(37.27474585588877, 127.13014091156285, 37.27485582655225, 127.13051036327961, 2)
    insertConnection(37.27503613359225, 127.13042047282534, 37.274934692250206, 127.13048794902616, 1)
    insertConnection(37.274934692250206, 127.13048794902616, 37.27485582655225, 127.13051036327961, 1)
    insertConnection(37.27485582655225, 127.13051036327961, 37.2748962271399, 127.13064291655448, 2)
    insertConnection(37.2748962271399, 127.13064291655448, 37.27417478871547, 127.13119133035617, 1)
    insertConnection(37.27417478871547, 127.13119133035617, 37.27407802078409, 127.13110659939805, 1)
    insertConnection(37.27407802078409, 127.13110659939805, 37.27404440655906, 127.13094869016763, 1)
    insertConnection(37.27404440655906, 127.13094869016763, 37.27398832221001, 127.13074000444085, 1)
    insertConnection(37.27398832221001, 127.13074000444085, 37.27392768878184, 127.13057077384319, 1)
    insertConnection(37.27392768878184, 127.13057077384319, 37.27383998980277, 127.13043250318492, 1)
    insertConnection(37.27383998980277, 127.13043250318492, 37.27396359034382, 127.13069768021606, 2)
    insertConnection(37.27396359034382, 127.13069768021606, 37.27400396892314, 127.13084996334368, 2)
    insertConnection(37.27400396892314, 127.13084996334368, 37.27405098963595, 127.13110655252227, 2)
    insertConnection(37.27405098963595, 127.13110655252227, 37.27412741546886, 127.13125326108776, 2)
    insertConnection(37.27412741546886, 127.13125326108776, 37.27475691510195, 127.13235650215039, 1)
    insertConnection(37.27475691510195, 127.13235650215039, 37.2748312003134, 127.1324017329398, 2)
    insertConnection(37.2748312003134, 127.1324017329398, 37.275137496503625, 127.13245300790071, 2)
    insertConnection(37.275137496503625, 127.13245300790071, 37.275250, 127.132443, 2)
    insertConnection(37.27383998980277, 127.13043250318492, 37.27374768615926, 127.130384425095, 1)
    insertConnection(37.27374768615926, 127.130384425095, 37.27392245113661, 127.13123317391899, 5)
    insertConnection(37.27392245113661, 127.13123317391899, 37.273935885445745, 127.13130648506876, 5)
    insertConnection(37.273935885445745, 127.13130648506876, 37.27390866971959, 127.13147274474092, 5)
    insertConnection(37.27390866971959, 127.13147274474092, 37.27395581449055, 127.13161658366009, 2)
    insertConnection(37.27395581449055, 127.13161658366009, 37.27416307522426, 127.13159721307942, 1)
    insertConnection(37.27416307522426, 127.13159721307942, 37.274736417817515, 127.13255660053439, 1)
    insertConnection(37.274736417817515, 127.13255660053439, 37.27485336327304, 127.13272593339505, 1)
    insertConnection(37.27416307522426, 127.13159721307942, 37.27429113751279, 127.13189904501529, 1)
    insertConnection(37.27429113751279, 127.13189904501529, 37.27449351893637, 127.13221510184812, 1)
    insertConnection(37.27449351893637, 127.13221510184812, 37.27438528413025, 127.13231356984465, 1)
    insertConnection(37.27449351893637, 127.13221510184812, 37.27485336327304, 127.13272593339505, 1)
    insertConnection(37.27485336327304, 127.13272593339505, 37.27499963651467, 127.13285585510144, 1)
    insertConnection(37.27499963651467, 127.13285585510144, 37.275204749155094, 127.13274346315634, 1)
    insertConnection(37.275204749155094, 127.13274346315634, 37.275413, 127.133174, 1)
    insertConnection(37.27316190303263, 127.12842157608694, 37.2734747077945, 127.12870398197106, 1)
    insertConnection(37.2734747077945, 127.12870398197106, 37.273345834019395, 127.12914066740784, 1)
    insertConnection(37.2730127753358, 127.12884131331158, 37.273345834019395, 127.12914066740784, 1)
    insertConnection(37.273345834019395, 127.12914066740784, 37.27352589711403, 127.12927345610524, 2)
    insertConnection(37.27352589711403, 127.12927345610524, 37.27355510081127, 127.12934679350231, 2)
    insertConnection(37.27355510081127, 127.12934679350231, 37.27363395091082, 127.12933847214721, 1)
    insertConnection(37.27363395091082, 127.12933847214721, 37.27374768615926, 127.130384425095, 5)
    insertConnection(37.2748962271399, 127.13064291655448, 37.27508058178045, 127.1309673977528, 2)
    insertConnection(37.275240628266644, 127.13086619780317, 37.27508058178045, 127.1309673977528, 5)
    insertConnection(37.27508058178045, 127.1309673977528, 37.2752784635983, 127.131280628775, 2)
    insertConnection(37.275240628266644, 127.13086619780317, 37.27536851112766, 127.13133152383469, 1)
    insertConnection(37.275170744830774, 127.13091399658175, 37.275170744830774, 127.13091399658175, 5)
    insertConnection(37.2752784635983, 127.131280628775, 37.27536851112766, 127.13133152383469, 2)
    insertConnection(37.2752784635983, 127.131280628775, 37.275385, 127.131441, 2)
    insertConnection(37.27536851112766, 127.13133152383469, 37.275438, 127.131334, 2)
    insertConnection(37.275438, 127.131334, 37.275853, 127.131123, 4)
    insertConnection(37.275853, 127.131123, 37.275980, 127.131377, 1)
    insertConnection(37.2749683848306, 127.13057539001802, 37.2749683848306, 127.13057539001802, 5)
    insertConnection(37.27599952828055, 127.13107046796486, 37.27599952828055, 127.13107046796486, 5)
    insertConnection(37.27604695756002, 127.13095779653992, 37.27569567430097, 127.13084725371365, 1)
    insertConnection(37.27569567430097, 127.13084725371365, 37.2756191359094, 127.13080202003266, 1)
    insertConnection(37.2756191359094, 127.13080202003266, 37.27561014732925, 127.1307822727045, 1)
    insertConnection(37.27561014732925, 127.1307822727045, 37.27564404520821, 127.13068367242158, 1)
    insertConnection(37.27560350160775, 127.13068078351127, 37.27560350160775, 127.13068078351127, 5)
    insertConnection(37.275853, 127.131123, 37.27590265421278, 127.13108157535082, 4)
    insertConnection(37.27590265421278, 127.13108157535082, 37.27578332908882, 127.13102499181876, 2)
    insertConnection(37.27578332908882, 127.13102499181876, 37.275697789742594, 127.13097128582523, 2)
    insertConnection(37.275697789742594, 127.13097128582523, 37.27566628771209, 127.1309402241499, 2)
    insertConnection(37.27566628771209, 127.1309402241499, 37.27554718361754, 127.13068350498273, 2)
    insertConnection(37.27554718361754, 127.13068350498273, 37.275540547138775, 127.1305735594309, 2)
    insertConnection(37.275540547138775, 127.1305735594309, 37.2755136030257, 127.13049458589, 3)
    insertConnection(37.275398866635776, 127.13036190342784, 37.275398866635776, 127.13036190342784, 5)
    insertConnection(37.2755136030257, 127.13049458589, 37.27546639171347, 127.13040993980303, 3)
    insertConnection(37.27546639171347, 127.13040993980303, 37.27538985935885, 127.13035906907898, 3)
    insertConnection(37.27538985935885, 127.13035906907898, 37.275270505949756, 127.13032785633686, 3)
    insertConnection(37.27532905480621, 127.13034487015832, 37.27532905480621, 127.13034487015832, 5)
    insertConnection(37.275270505949756, 127.13032785633686, 37.27524581426614, 127.13024888704636, 3)
    insertConnection(37.275236819390905, 127.13023477749314, 37.275236819390905, 127.13023477749314, 5)
    insertConnection(37.27524581426614, 127.13024888704636, 37.27520313275851, 127.13014169873219, 3)
    insertConnection(37.27520313275851, 127.13014169873219, 37.274971579497794, 127.12971847992296, 1)
    insertConnection(37.27494007713313, 127.12968741906796, 37.27494007713313, 127.12968741906796, 5)
    insertConnection(37.274971579497794, 127.12971847992296, 37.274881522001934, 127.12967604342927, 3)
    insertConnection(37.2746225352544, 127.12961922343318, 37.27472168957667, 127.12958274913701, 2)
    insertConnection(37.27472168957667, 127.12958274913701, 37.274881522001934, 127.12967604342927, 2)
    insertConnection(37.27467633805944, 127.12985609406866, 37.27480925974653, 127.12983940960875, 1)
    insertConnection(37.27480925974653, 127.12983940960875, 37.274881522001934, 127.12967604342927, 1)
    insertConnection(37.27542098537879, 127.13073120674022, 37.27554718361754, 127.13068350498273, 1)
    insertConnection(37.27542715050849, 127.13126679288187, 37.27536851112766, 127.13133152383469, 2)
    insertConnection(37.276577, 127.133335, 37.276572, 127.133409, 1)
    insertConnection(37.276495, 127.133426, 37.276572, 127.133409, 1)
    insertConnection(37.276503, 127.134447, 37.276643, 127.134338, 3)
    insertConnection(37.275980, 127.131377, 37.276082, 127.131677, 2)
    insertConnection(37.276082, 127.131677, 37.276200, 127.132323, 1)
    insertConnection(37.276200, 127.132323, 37.276298, 127.132314, 1)
    insertConnection(37.276200, 127.132323, 37.276321, 127.132627, 1)
    insertConnection(37.276321, 127.132627, 37.276560, 127.132933, 1)
    insertConnection(37.276560, 127.132933, 37.276564, 127.133067, 2)
    insertConnection(37.276564, 127.133067, 37.276577, 127.133335, 1)
    insertConnection(37.275385, 127.131441, 37.275583, 127.131745, 1)
    insertConnection(37.275583, 127.131745, 37.275716, 127.131741, 1)
    insertConnection(37.275716, 127.131741, 37.275631, 127.131821, 1)
    insertConnection(37.275739, 127.131984, 37.276164, 127.132620, 1)
    insertConnection(37.275583, 127.131745, 37.275739, 127.131984, 2)
    insertConnection(37.27607913165436, 127.13240955621824, 37.2761215, 127.1323065, 5)
    insertConnection(37.276216, 127.132703, 37.276190, 127.132399, 4)
    insertConnection(37.276190, 127.132399, 37.276190, 127.132222, 1)
    insertConnection(37.276190, 127.132222, 37.276173, 127.131919, 4)
    insertConnection(37.2762010, 127.1323413, 37.2762645, 127.1323377, 5)
    insertConnection(37.276328, 127.132849, 37.276460, 127.132897, 5)
    insertConnection(37.275216, 127.132492, 37.275250, 127.132443, 1)
    insertConnection(37.275250, 127.132443, 37.275250, 127.132443, 1)
    insertConnection(37.275250, 127.132443, 37.275258, 127.132556, 1)
    insertConnection(37.275216, 127.132492, 37.275703, 127.133315, 2)
    insertConnection(37.276222, 127.132927, 37.276038, 127.133056, 1)
    insertConnection(37.275878, 127.133161, 37.276149, 127.134129, 1)
    insertConnection(37.275741, 127.133386, 37.275878, 127.133161, 1)
    insertConnection(37.275741, 127.133386, 37.275935, 127.133727, 3)
    insertConnection(37.275413, 127.133174, 37.275661, 127.133410, 2)
    insertConnection(37.275661, 127.133410, 37.275257, 127.133055, 1)
    insertConnection(37.275674, 127.1334447, 37.2757133, 127.1336727, 5)
    insertConnection(37.2757133, 127.1336727, 37.275517, 127.133492, 1)
    insertConnection(37.2756995, 127.1337089, 37.2756989, 127.1338729, 5)
    insertConnection(37.2756989, 127.1338729, 37.275705, 127.134129, 1)
    insertConnection(37.276403, 127.134493, 37.275984, 127.134307, 1)
    insertConnection(37.275970, 127.133799, 37.276168, 127.133638, 1)
    insertConnection(37.276168, 127.133638, 37.276495, 127.133426, 2)
    insertConnection(37.275970, 127.133799, 37.276149, 127.134129, 4)
    insertConnection(37.276543, 127.133439, 37.276172, 127.133906, 1)
    insertConnection(37.276172, 127.133906, 37.276149, 127.134129, 1)
    insertConnection(37.276414, 127.134041, 37.276503, 127.134447, 1)
    insertConnection(37.276403, 127.134493, 37.275705, 127.134129, 1)
    insertConnection(37.276204, 127.134216, 37.276503, 127.134447, 4)
    insertConnection(37.276572, 127.133409, 37.2767733, 127.1336251, 4)
    insertConnection(37.2767733, 127.1336251, 37.2768192, 127.1335809, 5)
    insertConnection(37.2767733, 127.1336251, 37.276950, 127.133919, 4)
    insertConnection(37.276950, 127.133919, 37.277010, 127.134045, 5)
    insertConnection(37.276950, 127.133919, 37.276709, 127.134252, 1)
    insertConnection(37.276709, 127.134252, 37.276589, 127.134096, 1)
    insertConnection(37.276709, 127.134252, 37.276643, 127.134338, 1)
    insertConnection(37.276643, 127.134338, 37.276707, 127.134424, 1)
    insertConnection(37.276643, 127.134338, 37.276523, 127.134491, 1)
    insertConnection(37.276950, 127.133919, 37.2770425, 127.1338078, 1)
    insertConnection(37.2770425, 127.1338078, 37.2769859, 127.1337012, 1)
    insertConnection(37.2770425, 127.1338078, 37.277215, 127.133654, 1)
    insertConnection(37.277215, 127.133654, 37.277392, 127.133773, 1)
    insertConnection(37.277392, 127.133773, 37.277112, 127.134339, 1)
    insertConnection(37.277112, 127.134339, 37.277150, 127.134457, 1)
    insertConnection(37.277150, 127.134457, 37.276772, 127.134554, 1)
    insertConnection(37.276772, 127.134554, 37.276691, 127.134562, 2)
    insertConnection(37.276691, 127.134562, 37.276503, 127.134447, 2)
    insertConnection(37.277112, 127.134339, 37.277588, 127.134095, 2)
    insertConnection(37.277150, 127.134457, 37.277711, 127.134223, 2)
    insertConnection(37.277711, 127.134223, 37.277797, 127.134239, 3)
    insertConnection(37.277797, 127.134239, 37.277833, 127.134347, 3)
    insertConnection(37.277833, 127.134347, 37.277833, 127.134457, 3)
    insertConnection(37.277833, 127.134457, 37.277926, 127.134701, 1)
    insertConnection(37.277833, 127.134457, 37.277803, 127.134575, 3)
    insertConnection(37.277803, 127.134575, 37.277528, 127.134838, 4)
    insertConnection(37.277528, 127.134838, 37.277453, 127.134999, 4)
    insertConnection(37.277453, 127.134999, 37.277419, 127.135541, 4)
    insertConnection(37.27634721564954, 127.13238747495028, 37.276200, 127.132323, 5)

    completion()
}

func insertConnection(_ lat1: Double, _ lon1: Double, _ lat2: Double, _ lon2: Double, _ w: Double) {
    let from = CDCoreDataManager.store.selectGPS(latitude: lat1, longitude: lon1)!
    let to = CDCoreDataManager.store.selectGPS(latitude: lat2, longitude: lon2)!
    CDCoreDataManager.store.insertIntoConnection(from: from, to: to, weight: w)
    CDCoreDataManager.store.insertIntoConnection(from: to, to: from, weight: w)
}


enum CDFacilities: String {
    case fBell = "도움벨"
    case fElevator = "엘리베이터"
    case fWomanToilet = "장애인 전용 화장실(여성)"
    case fManToilet = "장애인 전용 화장실(남성)"
    case fDisabledPublicToilet = "장애인 전용 화장실(공용)"
    case fPublicToilet = "일반 화장실"
    case fPublicToiletWoman = "일반 화장실(여성)"
    case fPark = "장애인 전용 주차장"
    case fWheelchairReport = "휠체어 리포트"
    case fSlopeWay = "경사로"
    case fRest = "휴게실"
    case fDisabledRest = "장애인 전용 휴게실"
}

enum CDFacilityImageName: String {
    case f_icon_bell = "f_icon_bell"
    case f_icon_elevator = "f_icon_elevator"
    case f_icon_womanToilet = "f_icon_womanToilet"
    case f_icon_manToilet = "f_icon_manToilet"
    case f_icon_disabledPublicToilet = "f_icon_disabledPublicToilet"
    case f_icon_publicToilet = "f_icon_publicToilet"
    case f_icon_publicToiletWoman = "f_icon_publicToiletWoman"
    case f_icon_park = "f_icon_park"
    case f_icon_wheelchairReport = "f_icon_wheelchairReport"
    case f_icon_slopeWay = "f_icon_slopeWay"
    case f_icon_rest = "f_icon_rest"
    case f_icon_disabledRest = "f_icon_disabledRest"
}

enum CDBuildingName: String {
    case leeGong = "이공관"
    case hooSang = "후생관"
    case bon = "본관"
    case shalom = "샬롬관"
    case kyoYouk = "교육관"
    case simJyunOld = "심전관(구관)"
    case simJyunNew = "심전관(신관)"
    case inMoon = "인문사회관"
    case yeahSool = "예술관"
    case wooWon = "우원관"
    case joongDoe = "중앙도서관"
    case kyungChun = "경천관"
    case chunEun = "천은관"
    case mokYang = "목양관"
    case syngLee = "승리관"
}

enum CDBuildingImage: String {
    case leeGong = "leeGong"
    case hooSang = "hooSang"
    case bon = "bon"
    case shalom = "shalom"
    case kyoYouk = "kyoYouk"
    case simJyun = "simJyun"
    case inMoon = "inMoon"
    case yeahSool = "yeahSool"
    case wooWon = "wooWon"
    case joongDoe = "joongDoe"
    case kyungChun = "kyungChun"
    case chunEun = "chunEun"
    case mokYang = "mokYang"
    case syngLee = "syngLee"
}

func removeAllOfCoreData() {
    removeGPSInfo()
    removeConnection()
    removeBuilding()
    removeFacility()
    removeEachLayerFacilities()
    removeLayers()
}

func removeConnection() {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Connection")
    let request = NSBatchDeleteRequest(fetchRequest: fetch)
    do {
        let _ = try CDCoreDataManager.store.managedObjectContext.execute(request)

    } catch {

    }
}

func removeGPSInfo() {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GPSInfo")
    let request = NSBatchDeleteRequest(fetchRequest: fetch)
    do {
        let _ = try CDCoreDataManager.store.managedObjectContext.execute(request)
        
    } catch {
        
    }
}

func removeBuilding() {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Building")
    let request = NSBatchDeleteRequest(fetchRequest: fetch)
    do {
        let _ = try CDCoreDataManager.store.managedObjectContext.execute(request)
        
    } catch {
        
    }
}

func removeLayers() {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Layers")
    let request = NSBatchDeleteRequest(fetchRequest: fetch)
    do {
        let _ = try CDCoreDataManager.store.managedObjectContext.execute(request)
        
    } catch {
        
    }
}

func removeFacility() {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Facility")
    let request = NSBatchDeleteRequest(fetchRequest: fetch)
    do {
        let _ = try CDCoreDataManager.store.managedObjectContext.execute(request)
        
    } catch {
        
    }
}

func removeEachLayerFacilities() {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EachLayerFacilities")
    let request = NSBatchDeleteRequest(fetchRequest: fetch)
    do {
        let _ = try CDCoreDataManager.store.managedObjectContext.execute(request)
        
    } catch {
        
    }
}



