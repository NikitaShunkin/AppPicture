import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    let buttonAddPicture = UIButton()
    let buttonGallery = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray3
        
        setupButton(buttonAddPicture, title: "Add Picture")
        setupButton(buttonGallery, title: "Gallery")
        
        view.addSubview(buttonAddPicture)
        view.addSubview(buttonGallery)
        
        buttonAddPicture.addTarget(self, action: #selector(openAddPicture), for: .touchUpInside)
        buttonGallery.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        
        buttonAddPicture.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
        
        buttonGallery.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(buttonAddPicture.snp.bottom).offset(30)
            make.width.equalTo(buttonAddPicture)
            make.height.equalTo(buttonAddPicture)
        }
    }
    
    private func setupButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 15
    }
    
    @objc private func openAddPicture() {
        let addViewController = AddPictureViewController()
        navigationController?.pushViewController(addViewController, animated: true)
    }

    @objc private func openGallery() {
        let galleryViewController = GalleryViewController()
        navigationController?.pushViewController(galleryViewController, animated: true)
    }
}
