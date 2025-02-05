from setuptools import setup, find_packages

setup(
    name = "dbch1",
    version = "1.0.0",
    entry_points = {
        "console_scripts": [
            "dbch1-test = app:main"
        ]
    },
   packages = find_packages(
    where = "src",
   ),
   package_data = {
    "templates": [ "*.html" ]
   }

)