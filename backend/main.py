from fastapi import FastAPI

app = FastAPI(
    title="SentinelAI API",
    description="AI-Powered Industrial Safety Intelligence Platform",
    version="1.0.0"
)

@app.get("/")
def home():
    return {
        "status": "running",
        "message": "Welcome to SentinelAI 🚀"
    }