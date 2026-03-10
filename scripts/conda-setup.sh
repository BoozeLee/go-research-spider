#!/bin/bash
# Jazzy Jellyfish OS - Conda/Miniforge Setup for AI Development
# Installs Miniforge3 (lightweight conda) and configures AI/ML environment

set -e

echo "🪼 Jazzy Jellyfish OS - Conda/Miniforge Setup"
echo "=============================================="

CONDA_DIR="${CONDA_DIR:-$HOME/miniforge3}"
ENV_NAME="${ENV_NAME:-jazzy-ai}"
PYTHON_VERSION="${PYTHON_VERSION:-3.11}"

# Download Miniforge3
echo "Downloading Miniforge3..."
wget -q https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O /tmp/miniforge.sh

# Install silently
echo "Installing to $CONDA_DIR..."
bash /tmp/miniforge.sh -b -p "$CONDA_DIR"
rm /tmp/miniforge.sh

# Initialize conda
echo "Initializing conda..."
source "$CONDA_DIR/etc/profile.d/conda.sh"
conda init bash

# Create AI development environment
echo "Creating AI environment: $ENV_NAME"
conda create -n "$ENV_NAME" python="$PYTHON_VERSION" -y

# Activate environment
conda activate "$ENV_NAME"

# Install core AI/ML packages
echo "Installing core AI/ML packages..."
conda install -y \
    numpy \
    pandas \
    scipy \
    scikit-learn \
    matplotlib \
    seaborn \
    jupyterlab \
    ipykernel \
    notebook

# Install deep learning frameworks
echo "Installing PyTorch (CPU version)..."
conda install -y pytorch cpuonly -c pytorch

# Install NLP tools
echo "Installing NLP tools..."
pip install --no-cache-dir \
    transformers \
    tokenizers \
    sentencepiece \
    accelerate \
    datasets

# Install Groq SDK
echo "Installing Groq SDK..."
pip install --no-cache-dir groq

# Install other AI tools
echo "Installing additional AI tools..."
pip install --no-cache-dir \
    langchain \
    langchain-community \
    langchain-groq \
    llama-index \
    openai \
    anthropic \
    python-dotenv \
    requests \
    httpx \
    aiohttp \
    beautifulsoup4 \
    lxml \
    playwright

# Install Playwright browsers
echo "Installing Playwright browsers..."
playwright install

# Create project directory
PROJECT_DIR="$HOME/projects/jazzy-ai"
mkdir -p "$PROJECT_DIR"

# Create starter notebook
cat > "$PROJECT_DIR/welcome.ipynb" << 'NOTEBOOK'
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": ["# 🪼 Jazzy Jellyfish AI Environment\n", "Welcome to your AI development environment!"]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Test imports\n",
    "import numpy as np\n",
    "import pandas as pd\n",
    "from groq import Groq\n",
    "print('✅ All imports successful!')"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Example: Groq API usage\n",
    "import os\n",
    "from dotenv import load_dotenv\n",
    "load_dotenv()\n",
    "\n",
    "client = Groq(api_key=os.environ.get(\"GROQ_API_KEY\"))\n",
    "response = client.chat.completions.create(\n",
    "    messages=[{\"role\": \"user\", \"content\": \"Hello!\"}],\n",
    "    model=\"llama3-8b-8192\"\n",
    ")\n",
    "print(response.choices[0].message.content)"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
NOTEBOOK

# Create .env template
cat > "$PROJECT_DIR/.env.example" << 'ENV'
# Jazzy Jellyfish AI - Environment Variables
GROQ_API_KEY=your_groq_api_key_here
OPENAI_API_KEY=your_openai_api_key_here
ANTHROPIC_API_KEY=your_anthropic_api_key_here
ENV

# Create .gitignore
cat > "$PROJECT_DIR/.gitignore" << 'GITIGNORE'
.env
*.pyc
__pycache__/
.ipynb_checkpoints/
*.ipynb
GITIGNORE

echo ""
echo "=============================================="
echo "✅ Setup Complete!"
echo ""
echo "To activate your environment:"
echo "  conda activate $ENV_NAME"
echo ""
echo "To start Jupyter Lab:"
echo "  jupyter lab"
echo ""
echo "Project directory: $PROJECT_DIR"
echo ""
echo "🪼 Jazzy Jellyfish OS"
