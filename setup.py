from setuptools import setuptools

setup(
    name = "dbch1",
    version = "1.0.0",
    entry_points = {
        "console_scripts": [
            "dbch-test = app:main"
        ]
    }
)