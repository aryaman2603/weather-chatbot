import os
from dotenv import load_dotenv
import google.generativeai as genai

# Load environment variables (make sure .env is in the same directory)
load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
if not GEMINI_API_KEY:
    raise ValueError("GEMINI_API_KEY not found in .env file.")

genai.configure(api_key=GEMINI_API_KEY)

print("Listing models that support 'generateContent':\n")
found_flash_model = False
for m in genai.list_models():
    # Check if the model supports text generation
    if "generateContent" in m.supported_generation_methods:
        print(f"Name: {m.name}")
        print(f"  Display Name: {m.display_name}")
        print(f"  Description: {m.description}")
        print(f"  Input Token Limit: {m.input_token_limit}")
        print(f"  Output Token Limit: {m.output_token_limit}")
        print(f"  Supported Methods: {m.supported_generation_methods}")
        print("-" * 30)
        if "flash" in m.name.lower() or "flash" in m.display_name.lower():
            found_flash_model = True

if not found_flash_model:
    print("\nNote: 'gemini-flash' or similar 'flash' models were not found among those supporting 'generateContent'.")
    print("This might be due to regional availability or API key permissions.")
else:
    print("\n'flash' model (or variants) found among those supporting 'generateContent'.")