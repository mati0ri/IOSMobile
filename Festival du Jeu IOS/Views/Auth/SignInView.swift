//
//  SignInView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 17/03/2024.
//

import SwiftUI

struct SignInView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var phoneNumber = ""
    @State private var selectedSize = ""
    @State private var pageConnexion = false
    
    @ObservedObject var viewModel: SignInViewModel
    
    let tshirtSizes = ["XXS", "XS", "S", "M", "L", "XL", "XXL"]
    
    init(viewModel: SignInViewModel = SignInViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        if viewModel.isSignedIn || pageConnexion {
            LoginView()
        } else {
            VStack {
                Text("S'inscrire")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20)
                
                TextField("Prénom", text: $firstName)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                
                TextField("Nom", text: $lastName)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                
                TextField("Email", text: $email)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                
                SecureField("Mot de passe", text: $password)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                
                TextField("Numéro de téléphone", text: $phoneNumber)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .keyboardType(.numberPad)
                    .onReceive(phoneNumber.publisher.collect()) { stringArray in
                        let filtered = stringArray.filter { $0.isNumber }
                        let numberString = String(filtered.prefix(10))
                        self.phoneNumber = numberString
                    }
                
                Text("Taille T-shirt")
                    .foregroundColor(.secondary)
                
                Picker(selection: $selectedSize, label: Text("Taille de t-shirt")) {
                    ForEach(tshirtSizes, id: \.self) { size in
                        Text(size)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 20)
                
                Button("S'inscrire") {
                    viewModel.signInUser(firstName: firstName, lastName: lastName, email: email, password: password, phoneNumber: phoneNumber, tshirtSize: selectedSize)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .disabled(firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty)
                
            }
            .padding()
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            
            VStack{
                HStack{
                    Text("Vous avez déjà un compte ?").foregroundColor(.secondary)
                    Button("Se connecter") {
                        pageConnexion = true
                    }.foregroundColor(.blue).background(Color.white)
                }
            }
        }
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
