//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Gerard Recinto on 11/11/17.
//  Copyright © 2017 Gerard Recinto. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: ViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  var posts: [[String: Any]] = []

    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.delegate = self
      tableView.dataSource = self
        
      // Network request snippet
      let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
      let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
      session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
      let task = session.dataTask(with: url) { (data, response, error) in
        if let error = error {
          print(error.localizedDescription)
        } else if let data = data,
          let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
          print(dataDictionary)
          // Get the dictionary from the response key
          let responseDictionary = dataDictionary["response"] as! [String: Any]
          // Store the returned array of dictionaries in our posts property
          self.posts = responseDictionary["posts"] as! [[String: Any]]
          // TODO: Get the posts and store in posts property

          // TODO: Reload the table view
          self.tableView.reloadData()
        }
      }
      task.resume()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
    
    let post = posts[indexPath.row]
    if let photos = post["photos"] as? [[String: Any]] {
        // photos is NOT nil, we can use it!
        // Get the photo url
        let photo = photos[0]
        let originalSize = photo["original_size"] as! [String: Any]
        let urlString = originalSize["url"] as! String
        let url = URL(string: urlString)
        cell.photoImageView.af_setImage(withURL: url!)
    }
    
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return posts.count
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    headerView.backgroundColor = UIColor(white: 1, alpha:0.9)
    let profileView = UIImageView(frame: CGRect(x:10, y:10, width:30))
  }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      let vc = segue.destination as! PhotoDetailsViewController
      let cell = sender as! PhotoCell
      let indexPath = tableView.indexPath(for: cell)!
      vc.image = cell.photoImageView.image
  } 
  

}
