import SwiftUI
import UIKit

private enum DemoImageLoader {
    static func image(named name: String) -> UIImage? {
        guard !name.isEmpty else { return nil }
        if let image = UIImage(named: name) { return image }
        for fileExtension in ["png", "jpg", "jpeg"] {
            if let image = UIImage(named: "\(name).\(fileExtension)") { return image }
            for subdirectory in [nil, "DemoImages", "Resources/DemoImages"] {
                if let url = Bundle.main.url(forResource: name, withExtension: fileExtension, subdirectory: subdirectory),
                   let image = UIImage(contentsOfFile: url.path) {
                    return image
                }
            }
        }
        return nil
    }
}

struct DogArtwork: View {
    let dog: Dog
    var height: CGFloat = 430
    var cornerRadius: CGFloat = HussleTheme.radius

    var body: some View {
        dogImage
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .accessibilityLabel("Photo of \(dog.name), a \(dog.breed)")
    }

    @ViewBuilder
    private var dogImage: some View {
        if let data = dog.photoData.first, let image = UIImage(data: data) {
            Image(uiImage: image).resizable().interpolation(.high).antialiased(true).scaledToFill()
        } else if let image = DemoImageLoader.image(named: dog.imageName) {
            Image(uiImage: image).resizable().interpolation(.high).antialiased(true).scaledToFill()
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        ZStack {
            LinearGradient(
                colors: [.purple.opacity(0.18), .pink.opacity(0.18), .orange.opacity(0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(spacing: 12) {
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(HussleTheme.primary)
                Text("Photo unavailable")
                    .font(.headline)
                    .foregroundStyle(HussleTheme.text)
            }
        }
    }
}

struct DogThumbnail: View {
    let dog: Dog
    var size: CGFloat = 62

    var body: some View {
        ZStack {
            Color.white
            dogThumbnailImage
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .contentShape(Circle())
        .overlay(Circle().stroke(.white, lineWidth: max(2, size * 0.018)))
        .accessibilityLabel("Photo of \(dog.name)")
    }

    @ViewBuilder
    private var dogThumbnailImage: some View {
        if let data = dog.photoData.first, let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .interpolation(.high)
                .antialiased(true)
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size, alignment: .center)
                .clipped()
        } else if let image = DemoImageLoader.image(named: dog.imageName) {
            Image(uiImage: image)
                .resizable()
                .interpolation(.high)
                .antialiased(true)
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size, alignment: .center)
                .clipped()
        } else {
            ZStack {
                HussleTheme.primary.opacity(0.12)
                Image(systemName: "pawprint.fill").foregroundStyle(HussleTheme.primary)
            }
            .frame(width: size, height: size)
        }
    }
}

struct OwnerThumbnail: View {
    let dog: Dog
    var size: CGFloat = 48

    var body: some View {
        ZStack {
            Color.white
            ownerThumbnailImage
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .contentShape(Circle())
        .overlay(Circle().stroke(.white, lineWidth: max(2, size * 0.06)))
        .shadow(color: .black.opacity(0.10), radius: 5, y: 2)
        .accessibilityLabel("Photo of \(dog.ownerName), \(dog.name)’s owner")
    }

    @ViewBuilder
    private var ownerThumbnailImage: some View {
        if let data = dog.ownerPhotoData, let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .interpolation(.high)
                .antialiased(true)
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size, alignment: .center)
                .clipped()
        } else if let image = DemoImageLoader.image(named: dog.ownerImageName) {
            Image(uiImage: image)
                .resizable()
                .interpolation(.high)
                .antialiased(true)
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size, alignment: .center)
                .clipped()
        } else {
            ZStack {
                Color.gray.opacity(0.12)
                Image(systemName: "person.fill").foregroundStyle(.secondary)
            }
            .frame(width: size, height: size)
        }
    }
}

struct DogOwnerPortrait: View {
    let dog: Dog
    var dogSize: CGFloat = 168
    var ownerSize: CGFloat = 62

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            DogThumbnail(dog: dog, size: dogSize)
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(color: .black.opacity(0.08), radius: 10, y: 4)

            OwnerThumbnail(dog: dog, size: ownerSize)
                .offset(x: 4, y: 4)
        }
        .frame(width: dogSize + ownerSize * 0.18, height: dogSize + ownerSize * 0.18)
    }
}
