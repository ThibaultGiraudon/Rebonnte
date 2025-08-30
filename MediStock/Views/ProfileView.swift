//
//  ProfileView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 27/08/2025.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State private var email: String = "thibault.giraudon@gmail.com"
    @State private var fullname: String = "Thibault Giraudon"
    @State private var selectedItem: PhotosPickerItem?
    @State private var showPhotosPicker: Bool = false
    @State private var isImageLoading: Bool = false
    
    @EnvironmentObject var session: SessionStore
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .center) {
            Group {
                if let imageURL = session.session?.imageURL, !imageURL.isEmpty {
                    FBImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipped()
                            .clipShape(Circle())
                            .padding(.top, 100)
                            .id(imageURL)
                    }
                }
                else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .foregroundStyle(Color.gray)
                        .background {
                            Circle()
                                .fill(.white)
                        }
                        .padding(.top, 100)
                }
            }
            .overlay(alignment: .bottom) {
                if isImageLoading {
                    ProgressView()
                        .tint(.gray)
                        .controlSize(.large)
                        .frame(width: 200, height: 200)
                        .background {
                            Circle()
                                .fill(.white.opacity(0.5))
                        }
                }
            }
            .onTapGesture {
                showPhotosPicker = true
            }
            .photosPicker(isPresented: $showPhotosPicker, selection: $selectedItem, matching: .images)
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            selectedItem = nil
                            isImageLoading = true
                            await session.uploadImage(uiImage)
                            isImageLoading = false
                        }
                    }
                }
            }
            TextField("Name", text: $fullname)
                .multilineTextAlignment(.center)
                .font(.system(size: 36))
                .bold()
            Text(email)
                .font(.title2)
            Spacer()
            customButton("Save", color: .lightBlue) {
                Task {
                    await session.updateUser(fullname: fullname)
                }
            }
            customButton("Log Out", color: .darkBlue) {
                session.signOut()
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image(colorScheme == .dark ? "background-dark" : "background-light")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .onAppear {
            self.email = session.session?.email ?? "email@email.com"
            self.fullname = session.session?.fullname ?? "New user"
        }
    }
    
    @ViewBuilder
    func customButton(_ title: String, color: Color,  completion: @escaping () -> Void) -> some View {
        Button {
            completion()
        } label: {
            Text(title)
                .foregroundStyle(.white)
                .font(.title)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color)
                }
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    let session = SessionStore()
    session.session = User(uid: "test", email: "test@gmail.com", fullname: "Test User", imageURL: "")
    return ProfileView()
        .environmentObject(session)
    
}
