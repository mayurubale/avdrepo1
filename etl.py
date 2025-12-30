import pandas as pd
import streamlit as st

data= {
    "langauge":["python","c++","java"],
    "status":["known","unknown","unknown"]
}

df= pd.DataFrame(data)
st.title("streamlit application")
st.write(df)