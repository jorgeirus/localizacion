//
//  ViewController.swift
//  EjemploMapa
//
//  Created by Jorge Andres Moreno Castiblanco on 17/05/16.
//  Copyright © 2016 eworld. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    private let manejador = CLLocationManager()
    private var miPosicion = CLLocationCoordinate2D()
    private var posicion : CLLocation!
    private var distancia: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        configuracionCamara()
        
        
        
//        let pin = MKPointAnnotation()
//        pin.title = "Bogotá"
//        pin.subtitle = "Granada Norte"
//        pin.coordinate = miPosicion
//        mapa.addAnnotation(pin)
        
        
    }
    
    
    func configuracionCamara(){
        mapa.camera.altitude = 1400
        mapa.camera.pitch = 50
        mapa.camera.heading = 180
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            
        }else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let miLocalizacion = locations[locations.count - 1]
        print("Latitud: \(miLocalizacion.coordinate.latitude) Longitud:\(miLocalizacion.coordinate.longitude)")
        if posicion == nil{
            posicion = miLocalizacion
            distancia = 0
            let latitud:CLLocationDegrees = miLocalizacion.coordinate.latitude
            let longitud:CLLocationDegrees = miLocalizacion.coordinate.longitude
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            let localizacion: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitud, longitud)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(localizacion, span)
            mapa.setRegion(region, animated: false)
        }else{
            let distanciaActual = miLocalizacion.distanceFromLocation(posicion)
            if distanciaActual >= 50{
                distancia += distanciaActual
                posicion = miLocalizacion
                let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
               miPosicion.latitude = posicion.coordinate.latitude
                miPosicion.longitude = posicion.coordinate.longitude
                let region:MKCoordinateRegion = MKCoordinateRegionMake(miPosicion, span)
                mapa.setRegion(region, animated: false)
                print("avanzo")
                colocarPunto()
            }
        }
        
    }
    
    func colocarPunto(){
        let pin = MKPointAnnotation()
        pin.title = "Latitud: \(posicion.coordinate.latitude) Longitud: \(posicion.coordinate.longitude)"
        pin.subtitle = "Distancia: \(distancia)"
        pin.coordinate = miPosicion
        mapa.addAnnotation(pin)
    }

    @IBAction func controlTipoMapa(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 1:
            mapa.mapType = MKMapType.SatelliteFlyover
            configuracionCamara()
        case 2:
            mapa.mapType = MKMapType.HybridFlyover
            configuracionCamara()
        default:
            mapa.mapType = MKMapType.Standard
            configuracionCamara()
        }
        
    }

}

