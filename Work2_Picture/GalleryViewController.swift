import UIKit
import SnapKit


class GalleryViewController: UIViewController {

    private var images: [ImageItem] = []
    private var currentIndex = 0

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete\nPicture", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        title = "Gallery"

        images = AddPictureViewController.savedImages

        view.addSubview(imageView)
        view.addSubview(commentLabel)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        view.addSubview(deleteButton)
        view.addSubview(favoriteButton)

        setupConstraints()
        updateUI()

        leftButton.addTarget(self, action: #selector(previousImage), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(nextImage), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteCurrentImage), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: 250),
            imageView.heightAnchor.constraint(equalToConstant: 250),

            commentLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            commentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            commentLabel.widthAnchor.constraint(equalToConstant: 300),

            leftButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            leftButton.widthAnchor.constraint(equalToConstant: 40),
            leftButton.heightAnchor.constraint(equalToConstant: 40),

            rightButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            rightButton.widthAnchor.constraint(equalToConstant: 40),
            rightButton.heightAnchor.constraint(equalToConstant: 40),

            deleteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deleteButton.widthAnchor.constraint(equalToConstant: 80),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),

            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favoriteButton.centerYAnchor.constraint(equalTo: deleteButton.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func updateUI() {
        guard !images.isEmpty else {
            imageView.image = nil
            commentLabel.text = ""
            return
        }
        if currentIndex >= images.count {
            currentIndex = images.count - 1
        }
        let item = images[currentIndex]
        imageView.image = item.image
        commentLabel.text = item.comment
    }

    @objc private func previousImage() {
        guard !images.isEmpty else { return }
        currentIndex = (currentIndex - 1 + images.count) % images.count
        updateUI()
    }

    @objc private func nextImage() {
        guard !images.isEmpty else { return }
        currentIndex = (currentIndex + 1) % images.count
        updateUI()
    }

    @objc private func deleteCurrentImage() {
        guard !images.isEmpty else { return }
        images.remove(at: currentIndex)
        AddPictureViewController.savedImages = images
        if currentIndex >= images.count {
            currentIndex = max(0, images.count - 1)
        }
        updateUI()
    }

    @objc private func favoriteTapped() {
        print("Favorite tapped")
    }
}
