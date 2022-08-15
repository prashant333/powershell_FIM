import os
import hashlib
import time
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
"""

newhash(path)
for k, v in hash_value.items():
    print(k, v)
    
"""


def hash_compare(check_dir_name, old_hash):
    new_hash = {}
    files_name = os.listdir(check_dir_name)
    for i in range(len(files_name)):
        new_hash[files_name[i]] = hashlib.sha3_512(files_name[i].encode('utf-8')).hexdigest()

    if old_hash == new_hash:
        print("File integrity intact!")
    else:
        print("File tampered.")


while True:
    time.sleep(2)
    hash_compare(path, hash_value)

