# Dev-ops_study
My Notes relating to dev-ops (Disclaimer, this is not original code, copied from various sources to look back on as a reference and use as a guide If i forget something, I can look at this repo.


terraform can be used to create our cluter VPC using infrastructure as code, we can then create a jenkins node in our cluster for CI/CD , and in the
continuous integration we pull and build an application from source and test it continously after a trigger and build a docker image, and If it passes the tests and compiles and builds succesfully, then we get a new working version of the application after the developer's integration to the code base. Then in the code deployment part of jenkins, we could use kubernetes to manage and deploy our container using the kubernetes cluster.

(just an example)

We could also let AWS do this for us.
