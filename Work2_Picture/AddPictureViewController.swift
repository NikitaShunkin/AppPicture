import UIKit
import SnapKit
import PhotosUI


struct ImageItem {
    var image: UIImage
    var comment: String
}

class AddPictureViewController: UIViewController, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    static var savedImages: [ImageItem] = []

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Picture", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        return button
    }()

    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete\nPictures", for: .normal)
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

    private let imageView: UIImageView = {
        let imageView1 = UIImageView()
        imageView1.contentMode = .scaleAspectFill
        imageView1.clipsToBounds = true
        imageView1.layer.cornerRadius = 12
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        imageView1.backgroundColor = .white.withAlphaComponent(0.3)
        return imageView1
    }()

    private let commentTextField: UITextField = {
        let textField1 = UITextField()
        textField1.placeholder = "Введите комментарий"
        textField1.borderStyle = .roundedRect
        textField1.translatesAutoresizingMaskIntoConstraints = false
        return textField1
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        return button
    }()

    private var currentImageItem: ImageItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        title = "Add Picture"

        view.addSubview(addButton)
        view.addSubview(deleteButton)
        view.addSubview(favoriteButton)
        view.addSubview(imageView)
        view.addSubview(commentTextField)
        view.addSubview(saveButton)

        setupConstraints()

        addButton.addTarget(self, action: #selector(addPictureTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deletePicturesTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveCurrentImage), for: .touchUpInside)
        
        commentTextField.delegate = self
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deleteButton.widthAnchor.constraint(equalToConstant: 80),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),

            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favoriteButton.centerYAnchor.constraint(equalTo: deleteButton.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),

            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160),

            addButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.heightAnchor.constraint(equalToConstant: 50),

            commentTextField.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 16),
            commentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            commentTextField.widthAnchor.constraint(equalToConstant: 250),
            commentTextField.heightAnchor.constraint(equalToConstant: 40),

            saveButton.topAnchor.constraint(equalTo: commentTextField.bottomAnchor, constant: 16),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func addPictureTapped() {
        let alert = UIAlertController(title: "Добавить фото", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { _ in self.openPhotoLibrary() }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func deletePicturesTapped() {
        imageView.image = nil
        commentTextField.text = ""
        currentImageItem = nil
    }

    @objc private func favoriteTapped() {
        print("Favorite tapped")
    }
    

    @objc private func saveCurrentImage() {
        guard var item = currentImageItem else { return }
        item.comment = commentTextField.text ?? ""
        AddPictureViewController.savedImages.append(item)
        currentImageItem = nil
        imageView.image = nil
        commentTextField.text = ""
        print("Image saved! Total: \(AddPictureViewController.savedImages.count)")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        currentImageItem?.comment = textField.text ?? ""
        return true
    }

    private func openPhotoLibrary() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
                guard let self = self, let image = object as? UIImage else { return }
                DispatchQueue.main.async {
                    self.currentImageItem = ImageItem(image: image, comment: "")
                    self.imageView.image = image
                    self.commentTextField.text = ""
                }
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            currentImageItem = ImageItem(image: image, comment: "")
            imageView.image = image
            commentTextField.text = ""
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
