import os
import hashlib
# reading file or folder for FIM

path = "D:/powershell_FIM/Files"

# read the directory tree

files = os.listdir(path)

# creating a dictionary for storing key and value.
hash_value = {}

# hashing function


def newhash(directory):
    for i in range(len(files)):
        hash_value[files[i]] = hashlib.sha3_512(files[i].encode('utf-8')).hexdigest()


newhash(path)
for k, v in hash_value.items():
    print(k, v)