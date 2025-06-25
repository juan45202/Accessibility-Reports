# Accessibility Report + Selenium + Axe Core

## ✅ Description
Test automation framework written in Java, implementing Selenium and the Axe Core 4.10.1 library version used to evaluate accessibility in static web sites. In the following framework a “.ftl” cast is integrated to interpret the results delivered by Axe Core in a graphical and better interpretable way for end users. Additionally, the framework has the functionality to generate multiple reports from a list of URLs uploaded by the user.

## 📋 Prerequisites
* Java 11: Install and configure Java 11 version in the environment variables device 

## 🚀 How to use
1. Clone this repository in your machine
   ```bash
   git clone https://github.com/usuario/repositorio.git
   cd Accessibility-Reports

2. Install all dependencies
   ```bash
   mvn install

Now let's run some Accessibility tests

3. Go to the file src > test > resources > urls.json. In this file you can add all the URLs where you want to check the Accesibility percentage following the next example.
  
     ![image](https://github.com/user-attachments/assets/ba3e947a-0b56-4b38-bc20-346daa41c324)

4. With "urls.json" file configured, is time now to run the tests with the following command
    ```bash
    mvn test

5. when the execution finishes you can see the report file for each URL in the folder root > target

     ![image](https://github.com/user-attachments/assets/cff736f0-49ab-499c-bccc-e25063fee696)

7. You can open a file in your browser and see the report details

     ![image](https://github.com/user-attachments/assets/fd1c0632-d649-46de-8cf0-6e08d6a31fec)

### Happy coding!!
