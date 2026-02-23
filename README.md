# Flutter Calculator App 

> Developed by **Goo Choi** for CSC 4360: Mobile App Development.

A modern, responsive calculator application built with Flutter. This project demonstrates widget composition, Dart programming fundamentals, and local state management through a clean, intuitive user interface.

## ✨ Features

### Part I: Core Functionality
* **Basic Arithmetic:** Supports addition (`+`), subtraction (`-`), multiplication (`×`), and division (`÷`).
* **Responsive Grid UI:** A clean, 4-column layout built with `Expanded` widgets that adapts perfectly to any screen size.
* **Smart Display:** Utilizes the `FittedBox` widget to dynamically scale down text, preventing long numbers from overflowing the screen.

### Part II: Enhanced Features
1. **Error Handling:** Safely catches and handles edge cases, displaying user-friendly messages like `"Cannot divide by 0"` and `"Incomplete"` instead of crashing.
2. **Percentage Operation (`%`):** Converts standard numbers to decimals and accurately calculates percentage-based arithmetic (e.g., `200 + 10% = 220`).
3. **Positive/Negative Toggle (`±`):** Seamlessly flips the sign of the current number, featuring strict edge-case handling for zero and post-operator inputs (e.g., `-0`).

### Expression Preview
* Dynamically displays the live math equation (e.g., `5 + 3`) in bright green text while the user is typing.
* Moves the completed equation to a subtle grey history text above the main display after the user presses `=`, keeping the interface clean and informative.

## 🚀 Getting Started

To run this project locally on your machine:

1. **Prerequisites:** Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
2. **Clone the repository:**
   ```bash
   git clone [https://github.com/yourusername/calculator_app.git](https://github.com/yourusername/calculator_app.git)