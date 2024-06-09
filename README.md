# Creative Programming And Computing, A.Y. 2023/2024
- Marco Furio Colombo
- Mattia Massimi
- Alessandra Moro
  
<center>
  <img src="assets/logo.jpg" alt="PixelPiano by Colombo, Massimi, Moro" width="400" title="PixelPiano by Colombo, Massimi, Moro"/>
</center>


# PixelPiano - The interactive virtual piano
This innovative project transforms the way we interact with musical instruments by combining wearable technology, computer vision, and real-time data processing. 
By using a glove embedded with pressure sensors and a camera-based hand tracking system, you can play a virtual piano on any flat surface, making music accessible and portable.


## Setup 
Chose a convenient path on your local computer and clone this repository  `git clone https://github.com/ale-moro/PixelPiano`

### Python Installation
Inside the cloned folder, open the python subfolder: `cd python`

#### Virtual environment
- If not already installed install `virtualenv`: `pip install virtualenv`
- Create virtual environment : `python -m venv venv` or `python3 -m venv venv` or `py -m venv venv`
- Activate virtual environment:
  - on windows machines: `.\venv\Scripts\activate`
  - on mac machines: `source venv\bin\activate`

#### Install required dependencies
- Install require dependencies: `pip install -r requirements.txt`

### Bela
Starting from the root of the project, the `Bela` folder contains the file handling the pressure sensors management and messages.
- Connect your Bela board to you computer.
- Copy the `render.cpp` file inside the `Bela` folder into your Bela and make sure it runs.
  If you have any trouble doing this from terminal, you can also open the Bela editor in your [browser](http://bela.local/) and upload it from its GUI.
- Plug-in your sensor glove into the Bela.

### Processing
Starting from the root of the project, the `Processing` folder contains all Processing Java files that compose GUI.
- Install the [Processing IDE](https://processing.org/download), if your don't have it already installed on your machine.

## Run
In order to run the whole application, all three systems need to be running.
- **Bela**: open the Bela IDE in your [browser](http://bela.local/), select the loaded file `render.cpp` and run it.
- **python**: activate the virtual environment you created following the Python Installation instructions and run the script:
  `python hand_landmarker_video.py` or `python3 hand_landmarker_video.py`
- **Processing**: open one of the files inside the `Processing` folder in the Processing IDE, it should automatically open all Prcessing project files.
  Run the skecth: press the IDE start button.

  NOTE:
  Since python contains a socket server and the Processing Java code contains a socket client:
  **Run the python script before launching your Processing Java code**
   
