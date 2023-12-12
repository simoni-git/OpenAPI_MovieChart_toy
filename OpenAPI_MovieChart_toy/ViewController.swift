//
//  ViewController.swift
//  OpenAPI_MovieChart_toy
//
//  Created by 시모니 on 12/12/23.
//

import UIKit


struct DailyBoxOfficeList: Codable {
    var movieNm: String
    var rank: String
}

struct BoxOfficeResult: Codable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}
struct MovieData: Codable {
    let boxOfficeResult: BoxOfficeResult
}

class ViewController: UIViewController {
    
    var movie: MovieData?
    let movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=자신의 키값을 넣어주세요! &targetDt=20231211"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        getData()
    }
    func getData() {
        guard let url = URL(string: movieURL) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                return
            }
            guard let JSONdata = data else {return} // data 값이 들어온게 있으면 그것을 JSONdata 라고 명칭함. 아직 팟싱되지 않은상태
            let dataString = String(data: JSONdata, encoding: .utf8)// 팟싱을 해줌.
            print(dataString)
            
            let decoder = JSONDecoder()
            do {
                let decodeData = try decoder.decode(MovieData.self, from: JSONdata)
                self.movie = decodeData
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            } catch {
                print(error)
            }
        
        }
        task.resume()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as? MyCell else {
            return UITableViewCell()
        }
        let data = movie?.boxOfficeResult.dailyBoxOfficeList[indexPath.row]
        cell.rankNumLabel.text = data?.rank
        cell.movieNmLabel.text = data?.movieNm
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

