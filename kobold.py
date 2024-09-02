import requests
import json

r = {
  "max_context_length": 2048,
  "max_length": 1000,
  "quiet": False,
  "rep_pen": 1.1,
  "rep_pen_range": 256,
  "rep_pen_slope": 1,
  "temperature": 0.5,
  "tfs": 1,
  "top_a": 0,
  "top_k": 100,
  "top_p": 0.9,
  "typical": 1
}

topic = "A cute tween girl standing in her bedroom",
style = "Realistic photograph"

message = [
    "You are an AI assistant specialized in creating detailed prompts for image generation based on given topics and styles. ",
    "Your task is to analyze the input and create a comprehensive, creative, and coherent prompt that can guide an image generation AI to produce a vivid and accurate representation of the described scene or concept.",
    "Please create a detailed image generation prompt based on the following information:",
    f"Topic: {topic}",
    f"Style: {style}",
    "Your prompt should include the following elements :",
    "1. Main subject or character description",
    "2. Background and setting details",
    "3. Lighting, color scheme, and atmosphere",
    "4. Any specific actions or poses for characters",
    "5. Important objects or elements to include",
    "6. Overall mood or emotion to convey",
    " ",
    "Here's your prompt: ",
]

r['prompt'] = "\n".join(message)

r = requests.post("https://192.168.0.119:5001/api/v1/generate", json=r, verify=False)
print (r.json()['results'][0]['text'])