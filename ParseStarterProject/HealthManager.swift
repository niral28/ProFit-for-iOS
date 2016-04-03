//
//  HealthManager.swift
//  HKTutorial
//
//

import Foundation
import HealthKit

class HealthManager {
  let healthKitStore:HKHealthStore = HKHealthStore()
  
    func getHealthStore() ->HKHealthStore
    {
        return healthKitStore;
    }
    
  func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
  {
    print("hello1");
    
    // 1. Set the types you want to read from HK Store
    let healthKitTypesToRead = Set(arrayLiteral:
      HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!,
      HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
      HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!,
      HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!,
      HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!,
      HKObjectType.workoutType() )
    
    // 2. Set the types you want to write to HK Store
    let healthKitTypesToWrite = Set(arrayLiteral:
      HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)!,
      HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
      HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
      HKQuantityType.workoutType()
      )
    
    // 3. If the store is not available (for instance, iPad) return an error and don't go on.
    if !HKHealthStore.isHealthDataAvailable()
    {
      let error = NSError(domain: "com.parse.ParseStarterProject-Swift28t", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
      if( completion != nil )
      {
        completion(success:false, error:error)
      }
      return;
    }
    
    // 4.  Request HealthKit authorization
    healthKitStore.requestAuthorizationToShareTypes(healthKitTypesToWrite, readTypes: healthKitTypesToRead) { (success, error) -> Void in
      
      if( completion != nil )
      {
        completion(success:success,error:error)
      }
    }
  }
  
  func readProfile() -> ( age:Int?,  biologicalsex:HKBiologicalSexObject?, bloodtype:HKBloodTypeObject?)
  {
    var error = false
    var age:Int?
    
    let birthDay: NSDate?;
    // 1. Request birthday and calculate age
    do{
      birthDay = try healthKitStore.dateOfBirth()
      let today = NSDate()
      let calendar = NSCalendar.currentCalendar()
      let differenceComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: birthDay!, toDate: today, options: NSCalendarOptions(rawValue: 0))
      
      age = differenceComponents.year
      
          
    } catch {
    
      print("Error reading Birthday:)")
      //error = true;
    
    }
    // 2. Read biological sex
   var biologicalSex:HKBiologicalSexObject?
    do {
    biologicalSex =  try healthKitStore.biologicalSex();
    }catch{
      print("Error reading Biological Sex:");
    
    }
    
    // 3. Read blood type
    var bloodType:HKBloodTypeObject?
    do {
      bloodType =  try healthKitStore.bloodType();
    }catch{
      print("Error reading Blood Type:");
      
    }
  
    // 4. Return the information read in a tuple
    return (age, biologicalSex, bloodType )
}
  func readMostRecentSample(sampleType:HKSampleType , completion: ((HKSample!, NSError!) -> Void)!)
  {
    
    // 1. Build the Predicate
    let past = NSDate.distantPast() as! NSDate
    let now   = NSDate()
    let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
    
    // 2. Build the sort descriptor to return the samples in descending order
    let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
    // 3. we want to limit the number of samples returned by the query to just 1 (the most recent)
    let limit = 1
    
    // 4. Build samples query
    let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
      { (sampleQuery, results, error ) -> Void in
        
        if let queryError = error {
          completion(nil,error)
          return;
        }
        print(results?.endIndex);
        // Get the first sample
        let mostRecentSample = results!.first as? HKQuantitySample
        
        // Execute the completion closure
        if completion != nil {
          completion(mostRecentSample,nil)
        }
    }
    // 5. Execute the Query
    self.healthKitStore.executeQuery(sampleQuery)
  }
    
    func readPastDayEnergy(sampleType:HKSampleType , completion: ((Double, NSError!) -> Void)!)
    {
        
        // 1. Build the Predicate
        guard let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) else {
            fatalError("*** This should never fail. ***")
        }
        
        let now   = NSDate()
        let past = calendar.startOfDayForDate(now);
        
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
        
        // 2. Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. There is no limit set
        // 4. Build samples query
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor])
        { (sampleQuery, results, error ) -> Void in
            
            if let queryError = error {
                print("Error Reading calories!")
                completion(-1,error)
                return;
            }
            print("calories:")
            print(results?.endIndex);
            
            // Get the first sample
            var mostRecentSample = 0.0;
            if(results!.endIndex > 0){
                for sample in results! {
                    let s = sample as? HKQuantitySample;
                       mostRecentSample += (s!).quantity.doubleValueForUnit(HKUnit.jouleUnit())
                    
                }
            }
            
            // Execute the completion closure
            if completion != nil {
                completion(mostRecentSample,nil)
            }
        }
        // 5. Execute the Query
        self.healthKitStore.executeQuery(sampleQuery)
    }
    
    func readDayEnergy(sampleType:HKSampleType , date:NSDate, completion: ((Double, NSError!) -> Void)!)
    {
        
        // 1. Build the Predicate
        guard let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) else {
            fatalError("*** This should never fail. ***")
        }
        
        let now   = date;
        let past = calendar.startOfDayForDate(now);
        
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
        
        // 2. Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. There is no limit set
        // 4. Build samples query
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor])
        { (sampleQuery, results, error ) -> Void in
            
            if let queryError = error {
                print("Error Reading calories!")
                completion(-1,error)
                return;
            }
            print("calories:")
            print(results?.endIndex);
            
            // Get the first sample
            var mostRecentSample = 0.0;
            if(results!.endIndex > 0){
                for sample in results! {
                    let s = sample as? HKQuantitySample;
                    mostRecentSample += (s!).quantity.doubleValueForUnit(HKUnit.jouleUnit())
                    
                }
            }
            
            // Execute the completion closure
            if completion != nil {
                completion(mostRecentSample,nil)
            }
        }
        // 5. Execute the Query
        self.healthKitStore.executeQuery(sampleQuery)
    }
    
    
    
    func readPastWeekEnergy(sampleType:HKSampleType , completion: ((Double, NSError!) -> Void)!)
    { // read past week's active energy
        
        // 1. Build the Predicate
        guard let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) else {
            fatalError("*** This should never fail. ***")
        }
        
        var now   = NSDate()
        //now = calendar.dateByAddingUnit(.Day, value: -1, toDate: now, options: .WrapComponents)!;
        let past = calendar.dateByAddingUnit(.Day, value: -7, toDate: now, options: .WrapComponents);
        
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
        
        // 2. Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. There is no limit set
        // 4. Build samples query
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor])
        { (sampleQuery, results, error ) -> Void in
            
            if let queryError = error {
                print("Error Reading calories!")
                completion(-1,error)
                return;
            }
            print("calories:")
            print(results?.endIndex);
            
            // Get the first sample
            var mostRecentSample = 0.0;
            if(results!.endIndex > 0){
                for sample in results! {
                    let s = sample as? HKQuantitySample;
                    mostRecentSample += (s!).quantity.doubleValueForUnit(HKUnit.jouleUnit())
                   // print(mostRecentSample);
                }
            }
            print("Print mostRecentSample");
            print(mostRecentSample);
            
            // Execute the completion closure
            if completion != nil {
                completion(mostRecentSample,nil)
            }
        }
        // 5. Execute the Query
        self.healthKitStore.executeQuery(sampleQuery)
    }
  
    func readPastAllEnergy(sampleType:HKSampleType , completion: (([Double], NSError!) -> Void)!)
    { // read Energy from past week
        
        // 1. Build the Predicate
        guard let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) else {
            fatalError("*** This should never fail. ***")
        }
        
        let now   = NSDate()
        let past = calendar.dateByAddingUnit(.Day, value: -7, toDate: now, options: .WrapComponents);
        
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
        let limit = 200;
        // 2. Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. There is no limit set
        // 4. Build samples query
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: 7, sortDescriptors: .None)
        { (sampleQuery, results, error ) -> Void in
            
            if let queryError = error {
                print("Error Reading calories!")
                completion([-1],error)
                return;
            }
            print("calories:")
            print(results?.endIndex);
            
            // Get the first sample
            var mostRecentSample = [Double]()
            var i = 0;
            if(results!.endIndex > 0){
                for sample in results! {
                    let s = sample as? HKQuantitySample;
                    print(i);
                    mostRecentSample.append((s!).quantity.doubleValueForUnit(HKUnit.jouleUnit()))
                    
                    ++i;
                }
            }
            
            // Execute the completion closure
            if completion != nil {
                completion(mostRecentSample,nil)
            }
        }
        // 5. Execute the Query
        self.healthKitStore.executeQuery(sampleQuery)
    }
    
   /* func readArrayEnergy(sampleType:HKSampleType, eDate:NSDate, length:Int, completion: (([Double], NSError!) -> Void)!)
    {
        print("In readArrayEnergy");
        var array = [Double]();
        // 1. Build the Predicate
        guard let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) else {
            fatalError("*** This should never fail. ***")
        }
        var startDate = calendar.dateByAddingUnit(.Day, value: (length-1), toDate: eDate, options: .WrapComponents);
        for var i = 0; i<length; i++ {
            var day = Double();
            self.readDayEnergy(sampleType, date: startDate!, completion: { (mostRecentCalories, error) -> Void in
                
                if( error != nil )
                {
                    print("Error reading calories from HealthKit Store: \(error.localizedDescription)")
                    return;
                }
                else{
                    day = mostRecentCalories;
                    array.append(day)
                }
            
            startDate = calendar.dateByAddingUnit(.Day, value: 1, toDate: startDate!, options: .WrapComponents);
        })// end for
        if completion != nil {
            completion(array,nil)
        }
        
    }*/
    
  func saveBMISample(bmi:Double, date:NSDate ) {
    
    // 1. Create a BMI Sample
    let bmiType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)
    let bmiQuantity = HKQuantity(unit: HKUnit.countUnit(), doubleValue: bmi)
    let bmiSample = HKQuantitySample(type: bmiType!, quantity: bmiQuantity, startDate: date, endDate: date)
    
    // 2. Save the sample in the store
    healthKitStore.saveObject(bmiSample, withCompletion: { (success, error) -> Void in
      if( error != nil ) {
        print("Error saving BMI sample: \(error!.localizedDescription)")
      } else {
        print("BMI sample saved successfully!")
      }
    })
  }
  
}