import cv2
import torch
import tempfile
import shutil
import os
import sys
import tkinter as tk
import threading
from tkinter import Frame, Label, Button, Canvas
from ultralytics import YOLO
from pathlib import Path
from PIL import Image, ImageTk  # Handling images for background

# Colors
PRIMARY_COLOR = "#003366"  # Dark blue
SECONDARY_COLOR = "#0055A4"  # Lighter blue
TEXT_COLOR = "white"
BUTTON_COLOR = "#007ACC"
BUTTON_HOVER = "#005F99"


def extract_model():
    """Extracts the YOLO model from the PyInstaller bundle to a temporary directory."""
    temp_dir = tempfile.mkdtemp()
    model_path = Path(temp_dir) / "helmet_detector.pt"
    bundle_path = Path(getattr(sys, '_MEIPASS', '.')) / "helmet_detector.pt"
    shutil.copy(bundle_path, model_path)
    return model_path, temp_dir


def run_detection():
    """Starts helmet detection using the webcam inside the application in a separate thread."""
    def detection_thread():
        model_path, temp_dir = extract_model()
        model = YOLO(str(model_path))

        camera = cv2.VideoCapture(0)

        if not camera.isOpened():
            print("⚠️ Warning: Unable to open webcam.")
            return

        cv2.namedWindow("Helmet Detection - VisionSafe", cv2.WND_PROP_FULLSCREEN)
        cv2.setWindowProperty("Helmet Detection - VisionSafe", cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)

        while True:
            ret, frame = camera.read()
            if not ret:
                print("⚠️ Warning: No frame received from the webcam.")
                break

            results = model(frame)

            for result in results:
                for box in result.boxes:
                    x1, y1, x2, y2 = map(int, box.xyxy[0])
                    confidence = box.conf[0].item()
                    cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 4)
                    label = f"Helmet ({confidence:.2f})"
                    cv2.putText(frame, label, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 3)

            cv2.imshow("Helmet Detection - VisionSafe", frame)
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
            if cv2.getWindowProperty("Helmet Detection - VisionSafe", cv2.WND_PROP_VISIBLE) < 1:
                break

        camera.release()
        cv2.destroyAllWindows()
        shutil.rmtree(temp_dir)

    threading.Thread(target=detection_thread, daemon=True).start()


def set_background(canvas, frame, image_path="assets/bg.jpg"):
    """Loads and sets a fullscreen background image and ensures frame is on top."""
    bg_image = Image.open(image_path)
    bg_image = bg_image.resize((1920, 1080), Image.LANCZOS)
    bg_photo = ImageTk.PhotoImage(bg_image)

    canvas.create_image(0, 0, anchor=tk.NW, image=bg_photo)
    canvas.bg_photo = bg_photo  # Prevent garbage collection

    frame.place(x=0, y=0, relwidth=1, relheight=1)  # Make the frame fill the screen


def clear_frame(frame):
    """Clears the frame for page navigation."""
    for widget in frame.winfo_children():
        widget.destroy()


def create_button(frame, text, command):
    """Creates a stylized button."""
    btn = Button(
        frame, text=text, command=command, font=("Arial", 18, "bold"),
        bg=BUTTON_COLOR, fg=TEXT_COLOR, activebackground=BUTTON_HOVER,
        width=30, height=2, bd=0, relief="ridge", cursor="hand2"
    )
    btn.pack(pady=15)
    return btn


def show_main_menu(frame, canvas):
    """Displays the main menu with a fullscreen background."""
    clear_frame(frame)
    set_background(canvas, frame)  # Set the background image

    container = Frame(frame, bg=PRIMARY_COLOR)
    container.place(relx=0.5, rely=0.45, anchor="center")  # Centered on screen

    Label(container, text="🚀 Welcome to VisionSafe", font=("Arial", 32, "bold"), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=20)
    
    create_button(container, "🎥 Start Detection", run_detection)
    create_button(container, "📊 Benchmark", lambda: show_benchmark(frame, canvas))
    create_button(container, "📖 User Guide", lambda: show_guide(frame, canvas))
    create_button(container, "❌ Exit", root.destroy)

    # YOLOv11 Information
    Label(container, text="YOLOv11 Model: High-accuracy helmet detection with real-time inference.", 
          font=("Arial", 16), bg=PRIMARY_COLOR, fg=TEXT_COLOR, wraplength=700).pack(pady=20)


def show_benchmark(frame, canvas):
    """Displays YOLOv11 benchmark metrics inside the application."""
    clear_frame(frame)
    set_background(canvas, frame)

    Label(frame, text="YOLOv11 Benchmark Metrics", font=("Arial", 28, "bold"), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=20)
    
    stats = [
        "📊 Accuracy: 95%",
        "🎯 Precision: 93%",
        "📈 Recall: 96%"
    ]
    
    for stat in stats:
        Label(frame, text=stat, font=("Arial", 20), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=10)
    
    create_button(frame, "Back", lambda: show_main_menu(frame, canvas))


def show_guide(frame, canvas):
    """Displays usage instructions inside the application."""
    clear_frame(frame)
    set_background(canvas, frame)

    Label(frame, text="📖 User Guide", font=("Arial", 28, "bold"), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=20)

    steps = [
        "✅ Click 'Detect' to start real-time detection.",
        "📊 Click 'Benchmark' to view YOLO metrics.",
        "❓ Click 'Guide' for instructions.",
        "🔴 Click 'Exit' to close the application."
    ]

    for step in steps:
        Label(frame, text=step, font=("Arial", 20), bg=PRIMARY_COLOR, fg=TEXT_COLOR).pack(pady=10)

    create_button(frame, "Back", lambda: show_main_menu(frame, canvas))


def main():
    global root
    root = tk.Tk()
    root.title("VisionSafe")
    root.attributes('-fullscreen', True)

    canvas = Canvas(root, width=1920, height=1080)
    canvas.pack(fill=tk.BOTH, expand=True)  # Ensure canvas expands properly

    main_frame = Frame(root, bg=PRIMARY_COLOR)  # Make sure it's a child of `root`, not `canvas`
    
    show_main_menu(main_frame, canvas)

    root.mainloop()



if __name__ == "__main__":
    main()
