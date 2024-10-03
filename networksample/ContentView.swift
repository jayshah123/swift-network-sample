//
//  ContentView.swift
//  networksample
//
//  Created by jay shah on 03/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var responseText = "No response yet"
    @State private var isLoading = false

    var body: some View {
        VStack {
            Text("Network Request Simulator")
                .font(.title)
                .padding()

            Button(action: {
                self.makeRequest()
            }) {
                Text("Make Request")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isLoading)

            if isLoading {
                ProgressView()
                    .padding()
            }

            Text(responseText)
                .padding()
                .frame(minHeight: 100)
        }
    }

    func makeRequest() {
        isLoading = true
        responseText = "Loading..."

        guard let url = URL(string: "http://localhost:8000") else {
            responseText = "Invalid URL"
            isLoading = false
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    responseText = "Error: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    responseText = "Invalid response"
                    return
                }

                responseText = "Status code: \(httpResponse.statusCode)\n"

                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    responseText += "Response data: \(responseString)"
                } else {
                    responseText += "No response data"
                }
            }
        }

        task.resume()
    }
}

struct NetworkRequestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
