import os

def append_to_file(file_name, content, endl='yes'):
    file_handle = open(file_name, "a+")
    file_handle.write(content)
    if (endl == "yes"):
        file_handle.write("\n")
    file_handle.close()


stream = os.popen('eopkg li')
output = stream.readlines()

for line in output:
    package = line.strip().split('-')[0].strip()
    print(package)
    append_to_file("pkgs.txt", package)
