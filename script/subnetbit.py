import json
import argparse
 
ap = argparse.ArgumentParser()
ap.add_argument("-b", "--subnetbits", required=True, help="numer of subnets, as a integer")
args = vars(ap.parse_args())

print(json.dumps({"subnetbits" : str((len(str(int(bin(int(args["subnetbits"]))[2:])))))}))
