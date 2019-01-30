# KSNetwork - Smart HTTP Networking

- Gelecekte yapılacakalr
- [ ] internet olmadığı zamanda localdeki cacheden dataların getirilmesi
- [ ] Belirli sürede isteklerin tekrarlanması
- [ ] Yapılan isteklerin iptal edilmesi
- Kurulum
- Eğitim
-  Referanslar
-  Gereksinimler



## Kurulum

### CocoaPods

[CocoaPods](http://cocoapods.org/)  is a dependency manager for Cocoa projects. You can install it with the following command:

$ gem install cocoapods

> CocoaPods 1.1+ is required to build KSNetwork 1.0

To integrate KSNetwork into your Xcode project using CocoaPods, specify it in your  `Podfile`:

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'Target Name'  do
pod 'Networking', :git => 'http://bellatrix:8080/tfs/KSProjectCollection/KSFrameworkIOS/_git/NetworkingV2' , :branch => 'lib'
end

Then, run the following command:

$ pod install

## Gereksinimler
-   iOS 10.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+
-   Xcode 9.2+
-   Swift 4
- 
## Basit Get & Post istekleri
**1. Get İstekleri**

>Herhangi bir ön hazırlık yapılmadan sadece ilgili url ve dönüş tipleri belirtilerek yapılan isteklerdir. BasicGet dönüş tipi olarak String dir. Get ve Post ise  gelen json modellerini belirtilen tiplere otomatik dönüştürür.

		// Basit Get İstekleri
		//lk parametre URL alır ikinci parametre string tipinde json nesnesini döndürür
		
		KSNetworkManager().basicGet("https://api.github.com/users/Google/repos") { (json) in
            print(json) //String tipinde json döner
        }

---
	//Gelişmiş Get İstekleri
	// istek yapabilmek için "Serializable" Tipinde bir tane Model yaratıyoruz
	
	func getRespository(, success: @escaping (ResultModel<Repo>) -> Void, fail: @escaping Fail) {
      KSNetworkManager().get("https://api.github.com/users/Google/repos", success: success, fail: (ErrorModel) -> Void).fetch()
    }

**2. Post İstekleri**

	//Basit Post isteği. 
	//İlk parametre URL alır ikinci parametre string tipinde json nesnesi döndürür
	
	KSNetworkManager().basicPost("https://api.github.com/users/Google/users") { (json) in
		print(json) //String tipinde json döner
     }
---

	//Gelişmiş Post İstekleri
	//istek yapabilmek için "Serializable" Tipinde bir tane Model yaratıyoruz
	 	func userList(success: @escaping (ResultModel<Repo>) -> Void, fail:  @escaping (ErrorModel) -> Void) {
    	    manager.post("https://api.github.com/users/Google/users", bodyParameters: "", success: success, fail: fail).fetch()
  	}
	// Eğer body parametresinde Json Yollamak istiyorsanız bodyParameters içine "Serializable" tipinde object gönderebiliriz


### Örnek Model Oluşturma 
>Gelişmiş istekler yapabilmemiz için hazırlanan Model

	class Repo:Serializable{
	    var id:Int!
    	var name:String!
	    var description:String!
	    init(id:Int,name:String,description:String){
    	    self.id = id
        	self.name = name
	        self.description = description
	    }
	}


## Gelişmiş Kullanım

**1.Learning**
Aşağıdaki senaryoda isSucced alanı true geldiği durumlar için başarılı diğer durumlar hatalı olarak belirlenmiştir. Hata olan durumları için ErrorModel hata mesajı eklenmiştir. CheckCustomError belirlenen 402,401,vb durumlar için tetiklenecek alandır.


	class NetworkLearning: KSNetworkLearning {
    
    func sendError(errorModel: ErrorModel, fail: (ErrorModel) -> Void) {
    }
    
    func checkCustomError<ResultType>(errorModel: ErrorModel, success: (ResultModel<ResultType>) -> Void, fail: (ErrorModel) -> Void) where ResultType: Serializable {
        fail(errorModel)
    }
    
	    func checkSuccess<ResultType>(responseModel: ResultModel<ResultType>, success: (ResultModel<ResultType>) -> Void, fail: (ErrorModel) -> Void) where ResultType: Serializable {
    
			var response = getMappedModel(json: responseModel.getJson())
    	    let isSucceed = response?["isSucceed"] as? Bool
	        if isSucceed == true {
            	success(responseModel)
        	} else {
    	        let errorModel = ErrorModel()
	            if let singleData = response?["singleData"] as? String {
            	    errorModel.setData(data: singleData)
        	    } else if let exceptionMessage = response?["exceptionMessage"] as? String {
    	            errorModel.setData(data: exceptionMessage)
	            }
            	fail(errorModel)
        	}
    	}
	}


**2.Manager**

	import Networking
	class NetworkManager {

		let manager: KSNetworkManager
		let config = KSNetworkConfig.shared //Konfigrasyon nesnemiz - Servis URL bilgisi, Header bilgisi, Hata bilgilerini alır
		let defaultHeaders: [String: String] = ["Content-Type": "application/json"]

		init() {
			manager = KSNetworkManager()
			manager.setJsonKey(["multiData", "singleData"])
			manager.setNetworkLearning(learning: NetworkLearning()) 

			config.setURL(URL: "https://localhost.com:3000") //Servisin merkez url'si
			config.setDefaultHeaders(defaultHeaders: defaultHeaders)
			config.addCustomErrorStatusCodes(statusCode: 401) // Servisten dönen hata kodları istenildiği kadar eklenebilir.
			config.addHeader(parameters: customHeaders()) //Servise Varsayılan Header ile birlikte yollamak istediğiniz Header nesnesi
		}
	
		func customHeaders() -> [String: String]? {
			var headers: [String: String] = [:]
			headers["CompanyId"] = "COMPANY_ID"
			headers["Token"] = "TOKEN_NUMBER" 
			return headers
			}
	}
---
	//NetworkManager Sınıfımıza functionlarımızı ekliyoruz.
	extension NetworkManager{
	//MARK: Post User List
		func userList(success: @escaping (ResultModel<Repo>) -> Void, fail:  @escaping (ErrorModel) -> Void) {
			manager.post("Google/users", bodyParameters: "", success: success, fail:fail).setJsonKey(nil).fetch()
	}
---
	// Örnek Kullanım Senaryosu
		NetworkManager().userList(success: { (ResultM) in
            
            let response = ResultM.getModel(type: Repo.self)  //Dönen Json eğer Object tipinde ise kullanımı
			let responseArray = ResultM.getModel(type:[Repo].self) // Dönen json Object Array tipinde ise kullanımı
            self.tableView.reloadData()
            self.hideHud()
			
        }, fail: { error in
            print(error)
            self.hideHud()            
        })
        
	


###  Hata Tipleri
>Network isteklerinde alınabilecek hata tipleri

	Public Enum NetworkErrorTypes: Error {
		case noConnectionError
		case timeoutError
		case authFailureError
		case serverError
		case networkError
		case parseError
		case notValidJson
	}

----------
> json parse işlemlerinde alınabilecek hata tipleri

	public enum JSONSerializerError: Error {
		case jsonIsNotDictionary
		case jsonIsNotArray
		case jsonIsNotValid
	}










