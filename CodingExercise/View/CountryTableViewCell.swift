//
//  CountryTableViewCell.swift
//  CodingExercise
//
//  Created by Sheetal on 01/09/20.
//  Copyright © 2020 Sheetal.com. All rights reserved.
//

import UIKit
import Kingfisher
class CountryTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var isLoaded = false
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        return view
    }()
    let imgView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.layer.cornerRadius = img.frame.size.height / 2
        img.layer.borderColor = UIColor.orange.cgColor
        img.layer.borderWidth = 3.0
        img.clipsToBounds = true
        return img
    }()
    let titleLbl:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor =  UIColor.black
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let descriptionLbl:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor =  UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.clipsToBounds = true
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var countryCellViewModel : CountryCellViewModel? {
        didSet {
            titleLbl.text = countryCellViewModel?.titleText
            descriptionLbl.text = countryCellViewModel?.descText
            guard let urlStr = countryCellViewModel?.imageUrl else {
                print("something went wrong, element.Name can not be cast to String")
                return
            }
            print("imgUrl: \(countryCellViewModel!.imageUrl)")
            if countryCellViewModel != nil {
                var str = countryCellViewModel!.imageUrl
                str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""

                let url = URL(string:str)
                //            let url = URL(string: value)!
                print("imgUrl: \(countryCellViewModel!.imageUrl)")
                self.imgView.kf.setImage(with: url)

            }


        }
    }
    // MARK: Initializing
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Initializing

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews{
            view.removeFromSuperview()
        }
        containerView.addSubview(imgView)
        containerView.addSubview(titleLbl)
        containerView.addSubview(descriptionLbl)
        self.contentView.addSubview(containerView)
        setConstraints()
        isLoaded = false
    }


    func setConstraints(){
        self.containerView.removeConstraints(self.containerView.constraints)
        self.contentView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute:.bottom, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: 0))


       let containerHeightConstraint =  NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 140)// constant is 140 because we kept the image height as 100, so minimum height of container will be 140
        containerView.addConstraints([containerHeightConstraint])


        let imageXConstraint = NSLayoutConstraint(item: imgView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 10)
        containerView.addConstraints([imageXConstraint])
        let imageTopConstraint = NSLayoutConstraint(item: imgView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 20)
        containerView.addConstraints([imageTopConstraint])

        let imageWidthConstraint = NSLayoutConstraint(item: imgView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        containerView.addConstraints([imageWidthConstraint])
        let imageHeigthConstraint = NSLayoutConstraint(item: imgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        containerView.addConstraints([imageHeigthConstraint])

        let titleLabelTopConstraint =  NSLayoutConstraint(item: titleLbl, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 20)
        containerView.addConstraint(titleLabelTopConstraint)
        let titleLabelLeadingConstraint =  NSLayoutConstraint(item: titleLbl, attribute: .leading, relatedBy: .equal, toItem: imgView, attribute: .trailing, multiplier: 1.0, constant: 10)
        containerView.addConstraint(titleLabelLeadingConstraint)
        let titleLabelTrailingConstraint =  NSLayoutConstraint(item: titleLbl, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 10)
        containerView.addConstraint(titleLabelTrailingConstraint)

        let descLabelTopConstraint =  NSLayoutConstraint(item: descriptionLbl, attribute: .top, relatedBy: .equal, toItem: titleLbl, attribute: .bottom, multiplier: 1.0, constant: 10)
        containerView.addConstraint(descLabelTopConstraint)

        let descLabelLeadingConstraint =  NSLayoutConstraint(item: descriptionLbl, attribute: .leading, relatedBy: .equal, toItem: imgView, attribute: .trailing, multiplier: 1.0, constant: 10)
        containerView.addConstraint(descLabelLeadingConstraint)

        let descLabelTrailingConstraint =  NSLayoutConstraint(item: descriptionLbl, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: -10)
        containerView.addConstraint(descLabelTrailingConstraint)

       let descLabelBottomConstraint =  NSLayoutConstraint(item: descriptionLbl, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: -10)
        containerView.addConstraint(descLabelBottomConstraint)


    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        descriptionLbl.sizeToFit()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



