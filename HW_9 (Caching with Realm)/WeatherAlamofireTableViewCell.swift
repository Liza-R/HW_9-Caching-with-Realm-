//
//  WeatherAlamofireTableViewCell.swift
//  HW_9 (Caching with Realm)
//
//  Created by Elizaveta Rogozhina on 13.08.2021.
//

import UIKit

class WeatherAlamofireTableViewCell: UITableViewCell{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionTableAlam.delegate = self
        collectionTableAlam.dataSource = self
        collectionTableAlam.reloadData()
    }
    
    var dataForCollectionAlam: [DaysInfo.forBaseTableAlam] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataForCollectionAlam.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellWeatherAlam", for: indexPath) as! WeatherCollectionViewCellAlam,
            options = dataForCollectionAlam[indexPath.row]

        cell.temperLabelAlam.text = "\(options.temper_Alam)"
        cell.descriptLabelAlam.text = "\(options.descript_Alam)"
        cell.timeLabelAlam.text = options.time_Alam
        cell.iconImageAlam.image = options.icon_Alam
        return cell
}
    
    @IBOutlet weak var day_Label_Alam: UILabel!
    @IBOutlet weak var collectionTableAlam: UICollectionView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension WeatherAlamofireTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate{}

