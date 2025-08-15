import streamlit as st
import iris
import pathlib
import os
from faster_whisper import WhisperModel
import time

def initialize_iris_connection():
    connection_string = "iris:1972/RAG"
    username = "SuperUser"

    # Read iris password from docker secret
    with open('/run/secrets/iris_pw') as f:
        password = f.readline()
    #password = "SYS"
    connection = iris.connect(connection_string, username, password)
    irispy = iris.createIRIS(connection)

    return irispy

def get_business_service(target):
    irispy = initialize_iris_connection()
    iris_object = iris.IRISReference(None)
    irispy.classMethodValue("Ens.Director", "CreateBusinessService", target, iris_object)
    return iris_object.getValue()

service = get_business_service("Streamlit Service")

def get_llm_response(prompt):
    response = service.invoke("Ask", prompt)
    return response

# Read the SVG file
svg_path = str(pathlib.Path(__file__).parent.resolve()) + "/logo.SVG"
with open(svg_path, "r") as file:
    svg_logo = file.read()

st.set_page_config(
    page_title="IRIS Vector Search Demo",
    page_icon="🤖",
    layout="wide",
)

st.markdown(f"""
    <style>
        .block-container{{
            padding-top: 60px;
            padding-bottom: 1px;
        }}
        .reportview-container {{
            background: #ffffff;
            padding-top: 0rem;
        
        }}
        .sidebar .sidebar-content {{
            background: #ffffff;
            color: #ffffff;
        }}
        header {{
            padding-top: 0rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 0.01rem;
        }}
        header h1 {{
            padding-top: 0rem;
            font-size: 2.5rem;
            margin: 0;
            padding-bottom: 0px;
        }}
        header .logo-container {{
            padding-top: 0rem;
            width: 150px;
            height: auto;
            padding-bottom: 0px;
        }}
    </style>
    <header>
        <h1 style="color:#302A96;">💻 IRIS Vector Search Demo</h1>
        <div class="logo-container">
            {svg_logo}
        </div>
    </header>
""", unsafe_allow_html=True)

USER_AVATAR = "🧑‍💼"
BOT_AVATAR = "🤖"
file_name = "recorded_audio.wav" 


@st.fragment
def transcribe_audio():
    text=""
    model_size = "small"
    model = WhisperModel(model_size, device='cpu', compute_type="int8")     
    if os.path.exists(file_name):
        segments, info = model.transcribe("recorded_audio.wav", language='en', beam_size=5, vad_filter=False, initial_prompt="This is a demo from InterSystems with Roche company.")
        for segment in segments:
            text = text + segment.text
        os.remove(file_name)
    return text

@st.fragment
def text_message(submit_button):
    if submit_button:
        text_message = None
        if text_input:
            text_message = text_input
            # Add user's message to history
            st.session_state.messages.append({"role": "User", "content": text_message})
            # Generate bot's response
            with st.spinner("LLM is processing..."):
                start_time = time.time()
                bot_response = get_llm_response(text_message)
                elapsed_time = time.time() - start_time
                st.write(f"\n Response generated in {int(elapsed_time)} s.")
            # Add bot's response to history
            st.session_state.messages.append({"role": "Bot", "content": bot_response})
            # Clear input components by re-rendering the form
            st.rerun()
        else:
            st.warning("Please provide a text input.")
    return

@st.fragment
def audio_message(submit_button2):
    if submit_button2:
        audio_message = None
        if audio_value:
            with st.spinner("Transcribing audio..."):
                audio_message = transcribe_audio()
        if audio_message:
            # Add user's message to history
            st.session_state.messages.append({"role": "User", "content": audio_message})
            # Generate bot's response
            with st.spinner("LLM is processing..."):
                start_time = time.time()
                bot_response = get_llm_response(audio_message)
                elapsed_time = time.time() - start_time
                st.write(f"\n Response generated in {int(elapsed_time)} s.")
            # Add bot's response to history
            st.session_state.messages.append({"role": "Bot", "content": bot_response})
            # Clear input components by re-rendering the form
            st.rerun()
        else:
            st.warning("Please provide an audio recording.")



with st.container(height=340,border=True):   
    # Initialize session state for chat history
    if "messages" not in st.session_state:
        st.session_state.messages = []
    for message in st.session_state.messages:
        #st.markdown(f"{role} {message['content']}")
        with st.chat_message(name=message["role"], 
                                avatar=BOT_AVATAR if message["role"] == "Bot" else USER_AVATAR):
            st.write(f"**:gray[{message['role']}:]** "+message["content"])

# Input area
row1 = st.columns((2,1), gap="small")
with row1[0]:
    with st.form(key="input_form1", clear_on_submit=True, border=False):
        text_input = st.text_input("Enter your text here:", placeholder="Your message...")
        row01 = st.columns((3,1), gap="small")
        with row01[1]:
            submit_button = st.form_submit_button(label="Submit", use_container_width=True)
     
text_message(submit_button)
        
with row1[1]:
    with st.container(height=230, border=False):
        with st.form(key="input_form2", clear_on_submit=True, border=False):
            with st.expander("Audio Recorder", icon="🎙️"):
                audio_value = st.audio_input("Record a voice message:")
                if audio_value:
                    with open(file_name, "wb") as file:
                        file.write(audio_value.getvalue())
                        file.close()
                row1 = st.columns((1,1), gap="small")
                with row1[1]:
                    submit_button2 = st.form_submit_button(label="Submit", use_container_width=True)
                    
audio_message(submit_button2)
