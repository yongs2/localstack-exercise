# diagram.py
from diagrams import Diagram
from diagrams.aws.compute import Lambda
from diagrams.aws.mobile import APIGateway
from diagrams.aws.management import Cloudwatch
from diagrams.aws.storage import S3

with Diagram("lambda-api-gateway", show=False):
    s3 = S3("bucket")
    s3 >> Lambda("hello-world.zip")

    gateway = APIGateway("hello")
    func = Lambda("HelloWorld")
    gateway >> func

    gateway >> Cloudwatch("api_gw")
    func >> Cloudwatch("lambda")
