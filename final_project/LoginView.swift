//
//  LoginView.swift
//  final_project
//
//  Created by roykesydone on 2022/12/25.
//

import SwiftUI

struct Head: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX-30, y: rect.midY-30))
        path.addLine(to: CGPoint(x: rect.midX-10, y: rect.midY-15))
        path.addLine(to: CGPoint(x: rect.midX+10, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX+20, y: rect.midY+35))
        path.addLine(to: CGPoint(x: rect.midX-10, y: rect.midY+25))
        path.addLine(to: CGPoint(x: rect.midX-10, y: rect.maxY))
        
        return path
    }
}

struct Tail: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        
        return path
    }
}

struct User: Encodable {
    let login: String
    let password: String
}

struct RegisterUser: Encodable {
    let login: String
    let email: String
    let password: String
}

struct LoginBody: Encodable {
    let user: User
}

struct RegisterBody: Encodable{
    let user: RegisterUser
}

struct LoginResponse: Decodable {
    let userToken: String?
    let login: String?
    let email: String?
    let error_code: Int?
    let message: String?
    
    enum CodingKeys : String, CodingKey {
        case userToken = "User-Token"
        case login = "login"
        case email = "email"
        case error_code = "error_code"
        case message = "message"
    }
}

struct RegisterResponse: Decodable {
    let userToken: String?
    let login: String?
    let error_code: Int?
    let message: String?
    
    enum CodingKeys : String, CodingKey {
        case userToken = "User-Token"
        case login = "login"
        case error_code = "error_code"
        case message = "message"
    }
}

struct LoginView: View {
    @State var signInPage = true
    @State var loginSuccess = false
    
    @State var account = ""
    @State var password = ""
    @State var alertMessage = ""
    @State var showError = false
    @State var username = ""
    @State var email = ""
    @State var checkPassword = ""
    
    var body: some View {
        if !loginSuccess{
            VStack(spacing:0){
                Head()
                    .frame(width: 130, height: 130)
                    .foregroundColor(.red)
                    .offset(x:35)
                VStack(spacing:0){
                    Spacer()
                    Text("Pokédex")
                        .font(.system(size: 35, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 10)
                    VStack{
                        Text(signInPage ? "Login" : "Register")
                            .font(.system(size: 35, weight: .heavy, design: .rounded))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 10)
                        
                        Spacer()
                        if signInPage{
                            TextField("Username or Email", text: $account)
                                .padding()
                            //                        .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                                .textInputAutocapitalization(.never)
                            
                            SecureField("Password", text: $password)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                                .textInputAutocapitalization(.never)
                            
                        }
                        else{
                            TextField("Username", text: $username)
                                .padding()
                            //                        .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                                .textInputAutocapitalization(.never)
                            TextField("Email", text: $email)
                                .padding()
                            //                        .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                                .textInputAutocapitalization(.never)
                            
                            SecureField("Password", text: $password)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                                .textInputAutocapitalization(.never)
                            
                            SecureField("Check Password", text: $checkPassword)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                                .textInputAutocapitalization(.never)
                        }
                        HStack{
                            Button {
                                signInPage.toggle()
                            } label: {
                                Text(signInPage ? "Sign Up" : "Sign In")
                                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding(5)
                                //                                    .background(.red)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            
                            Button {
                                if signInPage{
                                    let _ = print("hi!")
                                    let url = URL(string: "https://favqs.com/api/session")!
                                    var request = URLRequest(url: url)
                                    request.httpMethod = "POST"
                                    request.setValue("Token token=\"\(apiToken)\"", forHTTPHeaderField: "Authorization")
                                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                    let encoder = JSONEncoder()
                                    let user = LoginBody(user: User(login: account, password: password))
                                    let data = try? encoder.encode(user)
                                    request.httpBody = data
                                    
                                    URLSession.shared.dataTask(with: request) { data, response, error in
                                        if let data {
                                            do {
                                                let decoder = JSONDecoder()
                                                let response = try decoder.decode(LoginResponse.self, from: data)
                                                if response.userToken != nil{
                                                    loginSuccess = true
                                                }
                                                else{
                                                    alertMessage = response.message!
                                                    showError = true
                                                }
                                                print(response)
                                            } catch  {
                                                print(error)
                                            }
                                        }
                                    }.resume()
                                }
                                else{
                                    if checkPassword != password{
                                        alertMessage = "Password is not equal to Check password"
                                        showError = true
                                        return
                                    }
                                    
                                    let url = URL(string: "https://favqs.com/api/users")!
                                    var request = URLRequest(url: url)
                                    request.httpMethod = "POST"
                                    request.setValue("Token token=\"\(apiToken)\"", forHTTPHeaderField: "Authorization")
                                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                    let encoder = JSONEncoder()
                                    let user = RegisterBody(user: RegisterUser(login: username,email: email, password: password))
                                    let data = try? encoder.encode(user)
                                    request.httpBody = data
                                    
                                    URLSession.shared.dataTask(with: request) { data, response, error in
                                        if let data {
                                            do {
                                                let decoder = JSONDecoder()
                                                let response = try decoder.decode(RegisterResponse.self, from: data)
                                                if response.userToken != nil{
                                                    loginSuccess = true
                                                }
                                                else{
                                                    alertMessage = response.message!
                                                    showError = true
                                                }
                                                print(response)
                                            } catch  {
                                                print(error)
                                            }
                                        }
                                    }.resume()
                                }
                            } label: {
                                Text((!signInPage) ? "Sign Up" : "Sign In")
                                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(5)
                                    .background(.red)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            .alert(alertMessage, isPresented: $showError, actions: {
                            })
                        }
                        .padding(.top, 30)
                        
                        
                        
                        Spacer()
                    }
                    .padding(30)
                    .frame(width: 250, height: 400)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    Spacer()
                }
                .frame(width: 270, height: 450)
                .padding(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 5)
                        .padding(10)
                )
                .background(.red)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Tail()
                    .foregroundColor(.red)
                    .frame(width: 70, height: 90)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 230/255, green: 230/255, blue: 230/255))
            .onAppear{
                let _ = print("test")
            }
        }
        else{
            ContentView()
        }
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
