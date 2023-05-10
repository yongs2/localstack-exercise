# diagram.py
from diagrams import Diagram
from diagrams.aws.compute import Lambda
from diagrams.aws.mobile import APIGateway
from diagrams.aws.management import Cloudwatch
from diagrams.aws.storage import S3
from diagrams.aws.analytics import Kinesis
from diagrams.aws.database import DynamodbTable

with Diagram("lambda-hotdog", show=False):
    dogs_db = DynamodbTable("dogs")

    caught_dogs_stream = Kinesis("caughtDogs")
    hot_dogs_stream = Kinesis("hotDogs")
    eaten_hot_dogs_stream = Kinesis("eatenHotDogs")

    gateway = APIGateway("hotdog")
    dog_catcher_lambda = Lambda("dogCatcher")
    dog_processor_lambda = Lambda("dogProcessor")
    hot_dog_despatcher_lambda = Lambda("hotDogDespatcher")

    gateway >> dog_catcher_lambda >> caught_dogs_stream

    caught_dogs_stream >> dog_processor_lambda >> dogs_db
    dog_processor_lambda >> hot_dogs_stream
    
    hot_dogs_stream >> hot_dog_despatcher_lambda >> eaten_hot_dogs_stream

    eaten_hot_dogs_stream >> dog_processor_lambda >> dogs_db
    