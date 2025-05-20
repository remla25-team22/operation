from setuptools import setup, find_packages
def read_version():
    with open("VERSION.txt") as f:
        return f.read().strip()
        
setup(
    name="operation",
    version=read_version(),
    packages=find_packages(),
    install_requires=[
        "nltk",
    ],
    author="Team 22",
    description=" ",
)
