//
//  ViewController.swift
//  Twittermenti
//
import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!

    
    let swifter = Swifter(consumerKey: "Zf7ZGQjdhnZp2XnZnLdTFcYdM", consumerSecret: "8SEHbAVv7dTYTCMjgU9NYKGZvK2lElbGxvaEwDFUTN6f7jT8BM") // 1..... this is the instanciated object  of the swifter framework that is being used to fetch the twitter tweets data we have instantiated

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func predictPressed(_ sender: Any) {
    
        if let searchedText = textField.text
        {
            let sentimentClassifier = TwitterSenti() //8..... now we're creating a new object from the ml learning model class that is twittersenti class that we've imported on the project
                // now its time to use it and perfrom the analysis on the json data we will fetch from the below function call
            
            //          2.....
            // this is a method that is present in the swifter framework
            // here using refers to the string we want to search twitter
            // success means what to do when the string is successfully searched response similarly for failure as well
            // results here is the successful json data we get back from twitter
            
            
            swifter.searchTweet(using: searchedText , lang : "en", count: 100 , tweetMode: .extended) {   results, searchMetadata in
                
                
                var arrayOfTweets = [TwitterSentiInput]()// 4.....  we now have an array of tweets now to classify these tweets we would now feed the entire array of tweets to our model and what we want is an array of predictions for each tweet [neg,pos,nuetral]
                
                for i in 0...100 //7..... this for loop is to iterate through all the 100 tweets we've fetched through the api
                {
                    if let tweet = results[i]["full_text"].string  // 5...... we tap into the json formatted result
                     {
                        print(results[i]["full_text"])
            
                        let tweetForClassification = TwitterSentiInput(text: tweet) // 6...... in order to feed the tweet to our model we need to convert the tweets that are string type to a type which the model is compatible with
                        arrayOfTweets.append(tweetForClassification) // now we append the converted tweets to the array of tweets that will be used for prediction
                    }
                }
                
                
                
                // 9.... now we pass the array of converted tweets to the model
                do
                {
                   let predictions =  try sentimentClassifier.predictions(inputs: arrayOfTweets) // prediction holds the prediction made by the model and now we would like to tally all the 100 tweets we've recieved and will to this by scoring the tweets one by one
                    
                    
                    var sentimentScore = 0
                   
                    for pred in predictions {
                        
                        if(pred.label == "Neg")
                        {
                            sentimentScore = sentimentScore - 1
                        }
                        else if ( pred.label == "Pos")
                        {
                            sentimentScore = sentimentScore + 1
                        }
                        
                    }
                    
                    print(sentimentScore)
                    
                    if(sentimentScore > 20)
                    {
                        self.sentimentLabel.text = "🥰"
                    }
                    else if (sentimentScore > 10)
                    {
                        self.sentimentLabel.text = "😀"
                    }
                    else if(sentimentScore > 0)
                    {
                        self.sentimentLabel.text = "🤔"
                    }
                    else if(sentimentScore == 0)
                    {
                        self.sentimentLabel.text = "😐"
                    }
                    else if(sentimentScore > -10)
                    {
                        self.sentimentLabel.text = "😣"
                    }
                    else if(sentimentScore > -20)
                    {
                        self.sentimentLabel.text = "🤮"
                    }
                    else
                    {
                        self.sentimentLabel.text = "🤬"
                    }
                }
                catch
                {
                    print("there was an error making a prediction")
                }
                
                
                
                
                
                
                
                
                
                
            } failure: { error in
                print("there was an error with the twitter api request \(error)")
            }
            
            // now we tap into one of the methods using the object  we instatiated and the method is called prediction
    //        let prediction = try! sentimentClassifier.prediction(text: "apple products are top notch ")
    //
    //        print(prediction.label)// .label is because on the label specified while training the data
            
            
            
        }
    }
    
}

