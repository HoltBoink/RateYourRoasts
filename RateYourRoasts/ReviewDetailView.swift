//
//  ReviewDetailView.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/27/23.
//

import SwiftUI

struct ReviewDetailView: View {
    @EnvironmentObject var reviewVM: ReviewViewModel
    @State var review: Review
    @Environment(\.dismiss) private var dismiss
    @State private var showCoffeeLookupSheet = false
    @State private var bodyRating = 0.0
    @State private var aroma = 0.0
    @State private var acidity = 0.0
    @State private var flavor = 0.0
    @State private var isEditing = false
    @State private var isEditing2 = false
    @State private var isEditing3 = false
    @State private var isEditing4 = false
    
    var body: some View {
        VStack {
            Group {
                TextField("Roaster", text: $review.name)
                    .font(.title)
                TextField("Coffee Name", text: $review.coffeeName)
                    .font(.title2)
            }
            .disabled(review.id == nil ? false : true)
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: review.id == nil ? 2 : 0)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Group {
                HStack {
                    Text("Aroma:")
                    Text("\(review.aroma)")
                            .foregroundColor(isEditing ? .red : .blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Slider(value: $review.aroma, in: 0...10, step: 1) {
                    Text("Aroma")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("10")
                } onEditingChanged: { editing in
                    isEditing = editing
                }
                HStack {
                    Text("Acidity:")
                    Text("\(Int(acidity))")
                            .foregroundColor(isEditing2 ? .red : .blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Slider(value: $acidity, in: 0...10, step: 1) {
                    Text("Acidity")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("10")
                } onEditingChanged: { editing in
                    isEditing2 = editing
                }
                HStack {
                    Text("Body:")
                    Text("\(Int(bodyRating))")
                            .foregroundColor(isEditing3 ? .red : .blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Slider(value: $bodyRating, in: 0...10, step: 1) {
                    Text("Body")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("10")
                } onEditingChanged: { editing in
                    isEditing3 = editing
                }
                HStack {
                    Text("Flavor:")
                    Text("\(Int(flavor))")
                            .foregroundColor(isEditing4 ? .red : .blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Slider(value: $flavor, in: 0...10, step: 1) {
                    Text("Body")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("10")
                } onEditingChanged: { editing in
                    isEditing4 = editing
                }
            }
            .disabled(review.id == nil ? false : true)
            .padding(.horizontal)
            
            
            Spacer()
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(review.id == nil)
        .toolbar {
            if review.id == nil {
                ToolbarItem (placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem (placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            let success = await reviewVM.saveReview(review: review)
                            if success {
                                dismiss()
                            } else {
                                print("ERROR Saving Spot!")
                            }
                        }
                        dismiss()
                    }
                }
                ToolbarItemGroup (placement: .bottomBar) {
                    Spacer()
                    
                    Button {
                        showCoffeeLookupSheet.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                        Text("Lookup Roaster")
                    }
                }
            }
        }
        .sheet(isPresented: $showCoffeeLookupSheet) {
            NavigationStack {
                CoffeeLookupView(review: $review)
            }
        }
    }
}

struct ReviewDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReviewDetailView(review: Review())
                .environmentObject(ReviewViewModel())
        }
    }
}
