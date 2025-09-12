//
//  ProfileView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 27/08/2025.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State private var email: String = ""
    @State private var fullname: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var showPhotosPicker: Bool = false
    @State private var isImageLoading: Bool = false
    
    var shouldDisabled: Bool {
        fullname.isEmpty
    }
    
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
            .accessibilityElement(children: .ignore)
            .accessibilityValue("Profile's picture")
            .accessibilityLabel("Import from galery button")
            .accessibilityHint("Double-tap to import a new picture from galery")
            
            TextField("Name", text: $fullname)
                .multilineTextAlignment(.center)
                .font(.system(size: 36))
                .bold()
            Text(email)
                .font(.title2)
            Spacer()
            CustomButton("Save", color: .lightBlue) {
                Task {
                    await session.updateUser(fullname: fullname)
                }
            }
            .padding(.horizontal, 20)
            .disabled(shouldDisabled)
            .opacity(shouldDisabled ? 0.6 : 1)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Save button")
            .accessibilityHint(shouldDisabled ? "Button disabled, fill in all fields" : "Double-tap to save changes")
            
            CustomButton("Log Out", color: .darkBlue) {
                session.signOut()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Log out button")
            .accessibilityHint("Double-tap to log out")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image(colorScheme == .dark ? "background-dark" : "background-light")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .accessibilityHidden(true)
        }
        .onAppear {
            self.email = session.session?.email ?? "email@email.com"
            self.fullname = session.session?.fullname ?? "New user"
        }
    }
}

#Preview {
    let session = SessionStore()
    session.session = User(uid: "test", email: "test@gmail.com", fullname: "Test User", imageURL: "")
    return ProfileView()
        .environmentObject(session)
    
}
