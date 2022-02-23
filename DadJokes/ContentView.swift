//
//  ContentView.swift
//  DadJokes
//
//  Created by Russell Gordon on 2022-02-21.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Stored Properties
    var currentJoke: DadJoke = DadJoke(id: "", joke: "Knock,knock...", status: 0)
    // MARK: Computed properties
    
    
    var body: some View {
        VStack {
            
            Text(currentJoke.joke)
                .font(.title)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.leading)
                .padding(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.primary, lineWidth: 4)
                )
                .padding(10)
            Image(systemName: "heart.circle")
                .font(.largeTitle)
            Button(action: {
                // the task type allows us to run asynchronous code
                // within a button and have the user interface be updated
                // when the data is ready.
                // we wait for the data to come back from the web server.
                Task {
                    // call a new func that will give us a new joke!
                    await loadNewJoke()
                }
                
            }, label: {
                Text("Another one!")
            })
                .buttonStyle(.bordered)
            HStack {
                Text("Favourites")
                    .bold()
                Spacer()
            }
            List {
                Text("Which side of the chicken has more feathers? The outside.")
                Text("Why did the Clydesdale give the pony a glass of water? Because he was a little horse!")
                Text("The great thing about stationery shops is they're always in the same place...")
            }
            
            Spacer()
            
        }
        // When the app opens, get a new joke from the web service
        .task {
            // load joke from the endpoint!
            // we are calling or invoking a func named loadNewJoke
            // a term for this is the "call site" of a func
            // this just means programmers are aware that this func is asynchronous.
            // result might come right away, or take some time to complete.
            // ALSO: Any code below this call will run before the func call completes.
            await loadNewJoke()
            
        }
        .navigationTitle("icanhazdadjoke?")
        .padding()
    }
    // MARK: Functions
    // define the func "loadNewJoke"
    // teaching our app to do a new thing
    // using the "async" keyword means that this func can potentially be run alongside other tasks that the app needs to do (ex: updating user interface)
    func loadNewJoke() async {
        // Assemble the URL that points to the endpoint
        let url = URL(string: "https://icanhazdadjoke.com/")!
        
        // Define the type of data we want from the endpoint
        // Configure the request to the web site
        var request = URLRequest(url: url)
        // Ask for JSON data
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        // Start a session to interact (talk with) the endpoint
        let urlSession = URLSession.shared
        
        // Try to fetch a new joke
        // It might not work, so we use a do-catch block
        do {
            
            // Get the raw data from the endpoint
            let (data, _) = try await urlSession.data(for: request)
            
            // Attempt to decode the raw data into a Swift structure
            // Takes what is in "data" and tries to put it into "currentJoke"
            //                                 DATA TYPE TO DECODE TO
            //                                         |
            //                                         V
            @State var currentJoke = try JSONDecoder().decode(DadJoke.self, from: data)
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
            print(error)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
