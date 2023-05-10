# diagram.py
from diagrams import Cluster,Diagram
from diagrams.onprem.network import Internet
from diagrams.aws.network import VPC, PublicSubnet, PrivateSubnet, NATGateway, RouteTable
from diagrams.aws.general import InternetGateway

with Diagram("aws-network", show=False, direction="LR"):
    internet = Internet("Internet")
    with Cluster("VPC", direction="TB"):
        igw = InternetGateway("igw")
        natgw = NATGateway("natgw")

        with Cluster("subnet1", direction="TB"):
            pub_subnet1 = PublicSubnet("pub-subnet1")
            pri_subnet1 = PrivateSubnet("pri-subnet1")

        with Cluster("subnet2", direction="TB"):
            pub_subnet2 = PublicSubnet("pub-subnet2")
            pri_subnet2 = PrivateSubnet("pri-subnet2")

        public_route_table = RouteTable("public-route-table")
        private_route_table = RouteTable("private-route-table")

        internet >> igw >> public_route_table
        natgw >> private_route_table

        public_route_table_association =  pub_subnet1 >> public_route_table << pub_subnet2
        private_route_table_association = pri_subnet1 >> private_route_table << pri_subnet2
